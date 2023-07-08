from utils import AverageMeter, calculate_metrics, AttrDict
from tqdm import tqdm
import torch
import torch.nn.functional as F
from loss import ce_loss, consistency_loss
from optimizer import build_optimizer
from lr_scheduler import build_scheduler
import numpy as np
from ema import ModelEMA
from datetime import datetime, date
import os


class FERClassifier:
    def __init__(self, model, opt_func="Adam", lr=1e-3, device="cpu"):
        self.model = model
        self.opt_func = opt_func
        self.device = device
        self.model.to(self.device)

    def get_dataloader(self, train_dl, valid_dl, test_dl=None):
        self.train_labeled_dl, self.train_unlabeled_dl = train_dl
        self.valid_dl = valid_dl
        self.test_dl = test_dl

    def get_config(self, config):
        self.config = AttrDict(config)

        if self.config.use_ema:
            self.ema_model = ModelEMA(
                model=self.model, decay=self.config.ema_decay, device=self.device
            )

        self.optimizer = build_optimizer(
            self.model, opt_func=self.opt_func, lr=self.config.lr
        )

        self.lr_scheduler = build_scheduler(
            config=self.config, optimizer=self.optimizer
        )

    def train_all_labels(self, epoch):
        self.model.train()
        summary_loss = AverageMeter()

        tk0 = tqdm(self.train_labeled_dl, total=len(self.train_labeled_dl))
        for batch_idx, (images, targets) in enumerate(tk0):
            images = images.to(self.device, non_blocking=True)
            targets = targets.to(self.device, non_blocking=True)

            outputs = self.model(images)
            losses = ce_loss(outputs, targets, reduction="mean")

            self.optimizer.zero_grad()

            losses.backward()
            self.optimizer.step()
            self.lr_scheduler.step_update(epoch * self.config.eval_step + batch_idx)

            if self.config.use_ema:
                self.ema_model.update(self.model)
            self.model.zero_grad()

            summary_loss.update(losses.item(), self.config.batch_size)
            tk0.set_postfix(loss=summary_loss.avg)

        return summary_loss

    def train_fixmatch(self, epoch):
        self.model.train()
        labeled_iter = iter(self.train_labeled_dl)
        unlabeled_iter = iter(self.train_unlabeled_dl)

        summary_loss = AverageMeter()

        tk0 = tqdm(range(self.config.eval_step), total=self.config.eval_step)

        for batch_idx, _ in enumerate(tk0):
            try:
                inputs_x, targets_x = labeled_iter.next()
            except:
                labeled_iter = iter(self.train_labeled_dl)
                inputs_x, targets_x = labeled_iter.next()
            try:
                (inputs_u_w, inputs_u_s), _ = unlabeled_iter.next()
            except:
                unlabeled_iter = iter(self.train_unlabeled_dl)
                (inputs_u_w, inputs_u_s), _ = unlabeled_iter.next()

            bs_lb = inputs_x.shape[0]
            bs_ulb = inputs_u_w.shape[0]
            inputs = torch.cat((inputs_x, inputs_u_w, inputs_u_s)).to(
                self.device, non_blocking=True
            )
            targets_x = targets_x.to(self.device, non_blocking=True)

            outputs = self.model(inputs)
            outputs_x = outputs[:bs_lb]
            outputs_u_w, outputs_u_s = outputs[bs_lb:].chunk(2)

            del outputs

            lx = ce_loss(outputs_x, targets_x, reduction="mean")
            lu, mask = consistency_loss(
                outputs_u_w,
                outputs_u_s,
                T=self.config.T,
                p_cutoff=self.config.threshold,
            )
            losses = lx + self.config.lambda_u * lu
            self.optimizer.zero_grad()

            losses.backward()
            self.optimizer.step()
            self.lr_scheduler.step_update(epoch * self.config.eval_step + batch_idx)

            if self.config.use_ema:
                self.ema_model.update(self.model)
            self.model.zero_grad()

            summary_loss.update(losses.item(), self.config.batch_size)
            tk0.set_postfix(loss=summary_loss.avg)

        return summary_loss

    def evaluate_one(self):
        if self.config.use_ema:
            eval_model = self.ema_model.ema
        else:
            eval_model = self.model

        eval_model.eval()

        summary_loss = AverageMeter()
        list_outputs = []
        list_targets = []
        with torch.no_grad():
            tk0 = tqdm(self.valid_dl, total=len(self.valid_dl))
            for step, (images, targets) in enumerate(tk0):
                images = images.to(self.device, non_blocking=True)
                targets = targets.to(self.device, non_blocking=True)

                outputs = eval_model(images)
                losses = ce_loss(outputs, targets, reduction="mean")

                summary_loss.update(losses.item(), self.config.batch_size)
                tk0.set_postfix(loss=summary_loss.avg)
                targets = targets.cpu().numpy()
                outputs = F.softmax(outputs, dim=1)
                outputs = outputs.cpu().numpy()
                list_outputs += list(outputs)
                list_targets += list(targets)
            metric = calculate_metrics(np.array(list_outputs), np.array(list_targets))
            return summary_loss, metric

    def fit(self):
        for epoch in range(1, self.config.epochs + 1):
            self.epoch = epoch
            train_loss = self.train_one(self.epoch)
            print(f"Training epoch: {self.epoch}")
            print(f"\tTrain Loss: {train_loss.avg:.3f}")
            if (epoch) % self.config.freq_eval == 0:
                valid_loss, valid_metric = self.evaluate_one()
                print(f"\tValid Loss: {valid_loss.avg:.3f}")
                print(f"\tMetric: {valid_metric}")

    def test_one(self):
        if self.config.use_ema:
            eval_model = self.ema_model.ema
        else:
            eval_model = self.model

        eval_model.eval()

        list_outputs = []
        list_targets = []
        with torch.no_grad():
            for step, (images, targets) in tqdm(
                enumerate(self.valid_dl), total=len(self.valid_dl)
            ):
                images = images.to(self.device, non_blocking=True)
                targets = targets.to(self.device, non_blocking=True)

                outputs = eval_model(images)
                targets = targets.cpu().numpy()
                outputs = F.softmax(outputs, dim=1)
                outputs = outputs.cpu().numpy()
                list_outputs += list(outputs)
                list_targets += list(targets)
        return list_outputs, list_targets

    def save_checkpoint(self, foldname):
        checkpoint = {}

        if self.config.use_ema:
            checkpoint["ema_state_dict"] = self.ema_model.ema.state_dict()

        d = date.today().strftime("%m_%d_%Y")
        h = datetime.now().strftime("%H_%M_%S").split("_")
        h_offset = int(datetime.now().strftime("%H_%M_%S").split("_")[0]) + 1
        h[0] = str(h_offset)
        h = "_".join(h)
        filename = d + "_" + h

        checkpoint["epoch"] = self.epoch

        checkpoint["model_state_dict"] = self.model.state_dict()
        checkpoint["optimizer"] = self.optimizer.state_dict()
        checkpoint["scheduler"] = self.lr_scheduler.state_dict()

        f = os.path.join(foldname, filename + ".pth")
        torch.save(checkpoint, f)
        print("Saved checkpoint")

    def load_checkpoint(self, checkpoint_dir, is_train=False):
        checkpoint = torch.load(checkpoint_dir, map_location={"cuda:0": "cpu"})
        self.model.load_state_dict(checkpoint["model_state_dict"])
        if is_train:
            for parameter in self.model.parameters():
                parameter.requires_grad = True
        else:
            for parameter in self.model.parameters():
                parameter.requires_grad = False
        if self.config.use_ema:
            self.ema_model.ema.load_state_dict(checkpoint["ema_state_dict"])
            if is_train:
                for parameter in self.ema_model.ema.parameters():
                    parameter.requires_grad = True
            else:
                for parameter in self.ema_model.ema.parameters():
                    parameter.requires_grad = False

        self.optimizer.load_state_dict(checkpoint["optimizer"])
        self.lr_scheduler.load_state_dict(checkpoint["scheduler"])
