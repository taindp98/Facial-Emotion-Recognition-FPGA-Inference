import torch.nn.functional as F
import torch


def ce_loss(logits, targets, use_hard_labels=True, reduction="none"):
    """
    wrapper for cross entropy loss in pytorch.

    Args
        logits: logit values, shape=[Batch size, # of classes]
        targets: integer or vector, shape=[Batch size] or [Batch size, # of classes]
        use_hard_labels: If True, targets have [Batch size] shape with int values. If False, the target is vector (default True)
    """
    if use_hard_labels:
        return F.cross_entropy(logits, targets, reduction=reduction)
    else:
        assert logits.shape == targets.shape
        log_pred = F.log_softmax(logits, dim=-1)
        nll_loss = torch.sum(-targets * log_pred, dim=1)
        return nll_loss


def consistency_loss(
    logits_w, logits_s, name="ce", T=1.0, p_cutoff=0.0, use_hard_labels=True
):
    assert name in ["ce", "L2"]
    logits_w = logits_w.detach()
    if name == "L2":
        assert logits_w.size() == logits_s.size()
        return F.mse_loss(logits_s, logits_w, reduction="mean")

    elif name == "L2_mask":
        pass

    elif name == "ce":
        pseudo_label = torch.softmax(logits_w, dim=-1)
        max_probs, max_idx = torch.max(pseudo_label, dim=-1)
        mask = max_probs.ge(p_cutoff).float()

        if use_hard_labels:
            masked_loss = (
                ce_loss(logits_s, max_idx, use_hard_labels, reduction="none") * mask
            )
        else:
            pseudo_label = torch.softmax(logits_w / T, dim=-1)
            masked_loss = ce_loss(logits_s, pseudo_label, use_hard_labels) * mask
        return masked_loss.mean(), mask.mean()

    else:
        assert Exception("Not Implemented consistency_loss")
