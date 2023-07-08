import torch
import torch.nn as nn
import torch.nn.functional as F
from torch import optim as optim


def check_keywords_in_name(name, keywords=()):
    isin = False
    for keyword in keywords:
        if keyword in name:
            isin = True
    return isin


def set_weight_decay(model, skip_list=(), skip_keywords=()):
    has_decay = []
    no_decay = []

    for name, param in model.named_parameters():
        if not param.requires_grad:
            continue  # frozen weights
        if (
            len(param.shape) == 1
            or name.endswith(".bias")
            or (name in skip_list)
            or check_keywords_in_name(name, skip_keywords)
        ):
            no_decay.append(param)
            # print(f"{name} has no weight decay")
        else:
            has_decay.append(param)
    return [{"params": has_decay}, {"params": no_decay, "weight_decay": 0.0}]


def build_optimizer(model, opt_func="Adam", lr=1e-3):
    """
    Build optimizer, set weight decay of normalization to 0 by default.
    """
    skip = {}
    skip_keywords = {}
    if hasattr(model, "no_weight_decay"):
        skip = model.no_weight_decay()
    if hasattr(model, "no_weight_decay_keywords"):
        skip_keywords = model.no_weight_decay_keywords()
    parameters = set_weight_decay(model, skip, skip_keywords)

    opt_lower = opt_func.lower()
    optimizer = None
    if opt_lower == "sgd":
        optimizer = optim.SGD(
            parameters, momentum=0.9, nesterov=True, lr=lr, weight_decay=0.05
        )
    elif opt_lower == "adamw":
        optimizer = optim.AdamW(
            parameters, eps=1e-8, betas=(0.9, 0.999), lr=lr, weight_decay=0.05
        )
    elif opt_lower == "adam":
        optimizer = optim.Adam(
            parameters, lr=lr, betas=(0.9, 0.999), eps=1e-08, weight_decay=0
        )

    return optimizer
