from torchvision import transforms
import numpy as np
import torch
from torch.utils.data import Dataset
from PIL import Image
from randaugment import RandAugmentMC

mean = [0.485, 0.456, 0.406]
std = [0.229, 0.224, 0.225]


class TransformFixMatch(object):
    def __init__(self, config, mean, std):
        self.weak = transforms.Compose(
            [
                transforms.Resize((config["size"], config["size"])),
                transforms.RandomHorizontalFlip(),
                transforms.RandomCrop(
                    size=config["size"],
                    padding=int(config["size"] * 0.125),
                    padding_mode="reflect",
                ),
            ]
        )

        self.strong = transforms.Compose(
            [
                transforms.Resize((config["size"], config["size"])),
                transforms.RandomHorizontalFlip(),
                transforms.RandomCrop(
                    size=config["size"],
                    padding=int(config["size"] * 0.125),
                    padding_mode="reflect",
                ),
                RandAugmentMC(n=2, m=10),
            ]
        )
        self.normalize = transforms.Compose(
            [transforms.ToTensor(), transforms.Normalize(mean=mean, std=std)]
        )

    def __call__(self, x):
        weak = self.weak(x)
        strong = self.strong(x)
        return self.normalize(weak), self.normalize(strong)


def get_transform(config, is_train=False, is_labeled=True):
    if is_train:
        if is_labeled:
            trf_aug = transforms.Compose(
                [
                    transforms.Resize((config["size"], config["size"])),
                    transforms.RandomHorizontalFlip(0.5),
                    transforms.ToTensor(),
                    transforms.Normalize(mean, std),
                ]
            )
        else:
            trf_aug = TransformFixMatch(config, mean, std)
    else:
        trf_aug = transforms.Compose(
            [
                transforms.Resize((config["size"], config["size"])),
                transforms.ToTensor(),
                transforms.Normalize(mean, std),
            ]
        )
    return trf_aug


class FERDataset(Dataset):
    def __init__(self, df, transform):
        """
        df: is the dataframe annotation image and attribute
        transform: transform augmentation
        """
        self.df = df
        self.transform = transform
        self.image = list(self.df["pixels"])
        self.target = list(self.df["emotion"])

    def __getitem__(self, idx):
        img_arr = np.reshape(
            np.array(self.image[idx].split(" "), dtype=np.uint8), (48, 48)
        )
        img_arr = np.repeat(img_arr[:, :, np.newaxis], 3, axis=2)
        img = Image.fromarray(img_arr)
        img = self.transform(img)

        target = torch.tensor(int(self.target[idx]))

        return img, target

    def __len__(self):
        return len(self.df)
