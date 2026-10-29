"""Synthetic RC-TCL anchor-conflict smoke test.

Purpose
-------
Test the first falsifiable RC-TCL hypothesis before changing the main TCL repo.

This uses the same structural ingredients as canonical TCL:
- EMA of squared gradients as per-parameter importance,
- normalized importance maps,
- task-end parameter checkpoints,
- importance-weighted quadratic memory penalty,
- SGD with momentum.

It intentionally uses small synthetic binary-classification tasks so the
experiment is cheap and fully reproducible. It is a smoke test, not evidence
about CIFAR-10/ResNet-18 performance.

Primary predictor:
    mean_i (1-r_i) * C_i

where C_i is anchor-conflict variance and r_i is the isolated TCL horizon
contraction factor.

Controls:
- independently permuted anchor coordinates,
- independently permuted importance coordinates.

Run:
    python experiments/rc_tcl_conflict_smoke.py
"""

from __future__ import annotations

import math
from dataclasses import dataclass

import numpy as np
import torch
from scipy.stats import pearsonr, spearmanr

torch.set_num_threads(1)

TRIALS = 80
N_TASKS = 5
D = 10
N = 256
EPOCHS = 18
BATCH = 64
LR = 0.05
LAMBDA_TCL = 0.02
MOMENTUM = 0.9
EMA_BETA = 0.99
SEED_BASE = 16000


def make_tasks(seed: int):
    g = torch.Generator().manual_seed(seed)
    x = torch.randn(N, D, generator=g)
    base = torch.randn(D, generator=g)
    base = base / base.norm()

    tasks = []
    for _ in range(N_TASKS):
        mix = torch.rand(1, generator=g).item()
        v = torch.randn(D, generator=g)
        v = v / v.norm()
        w = (1.0 - mix) * base + mix * v
        if torch.rand(1, generator=g).item() < 0.25:
            w = -w
        w = w / w.norm()

        logits = x @ w
        logits = logits + 0.15 * torch.randn(logits.shape, generator=g)
        y = (logits > 0).float().unsqueeze(1)
        tasks.append((x.clone(), y))
    return tasks


class LinearBinary(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.linear = torch.nn.Linear(D, 1)

    def forward(self, x):
        return self.linear(x)


class ThermalImportance:
    def __init__(self, model: torch.nn.Module):
        self._v = {
            name: torch.zeros_like(param)
            for name, param in model.named_parameters()
            if param.requires_grad
        }

    def accumulate(self, model: torch.nn.Module):
        for name, param in model.named_parameters():
            if param.grad is None or name not in self._v:
                continue
            self._v[name].mul_(EMA_BETA).add_(
                param.grad.detach() ** 2,
                alpha=1.0 - EMA_BETA,
            )

    def finalize(self):
        out = {}
        for name, value in self._v.items():
            z = value.clone()
            vmax = z.max()
            if vmax > 1e-30:
                z = z / vmax
            out[name] = z.detach().clone()
        return out


@dataclass
class Checkpoint:
    weights: dict[str, torch.Tensor]
    importance: dict[str, torch.Tensor]


def memory_penalty(model: torch.nn.Module, memory: list[Checkpoint]):
    total = torch.zeros((), dtype=torch.float32)
    for checkpoint in memory:
        for name, param in model.named_parameters():
            if name not in checkpoint.weights:
                continue
            diff = param - checkpoint.weights[name]
            total = total + (checkpoint.importance[name] * diff * diff).sum()
    return total


def accuracy(model: torch.nn.Module, task) -> float:
    x, y = task
    with torch.no_grad():
        pred = (torch.sigmoid(model(x)) >= 0.5).float()
        return float((pred == y).float().mean())


def horizon_factor(total_importance: float, steps: int) -> float:
    c = 2.0 * LAMBDA_TCL * total_importance
    matrix = np.array(
        [
            [1.0 - LR * c, -LR * MOMENTUM],
            [c, MOMENTUM],
        ],
        dtype=np.float64,
    )
    return float(np.linalg.matrix_power(matrix, steps)[0, 0])


def conflict_score(
    memory: list[Checkpoint],
    *,
    rng: np.random.Generator | None = None,
    shuffle_anchor: bool = False,
    shuffle_importance: bool = False,
):
    anchors = np.stack(
        [
            ck.weights["linear.weight"].detach().numpy().reshape(-1)
            for ck in memory
        ]
    )
    importance = np.stack(
        [
            ck.importance["linear.weight"].detach().numpy().reshape(-1)
            for ck in memory
        ]
    )

    if rng is not None and shuffle_anchor:
        anchors = np.stack(
            [row[rng.permutation(row.size)] for row in anchors]
        )
    if rng is not None and shuffle_importance:
        importance = np.stack(
            [row[rng.permutation(row.size)] for row in importance]
        )

    total = importance.sum(axis=0)
    mu = np.zeros_like(total)
    nonzero = total > 1e-12
    mu[nonzero] = (
        importance[:, nonzero] * anchors[:, nonzero]
    ).sum(axis=0) / total[nonzero]

    conflict = np.zeros_like(total)
    conflict[nonzero] = (
        importance[:, nonzero]
        * (anchors[:, nonzero] - mu[nonzero]) ** 2
    ).sum(axis=0) / total[nonzero]

    steps = math.ceil(N / BATCH) * EPOCHS
    r = np.array([horizon_factor(float(a), steps) for a in total])
    r = np.clip(r, 0.0, 1.0)

    score = float(np.mean((1.0 - r) * conflict))
    locked = float(np.mean(r <= 0.1))
    ambiguous = float(np.mean((r > 0.1) & (r < 0.9)))
    return score, float(r.mean()), locked, ambiguous


def run_trial(seed: int):
    torch.manual_seed(seed)
    tasks = make_tasks(seed)
    model = LinearBinary()
    memory: list[Checkpoint] = []
    rows = []

    rng_anchor = np.random.default_rng(seed + 777)
    rng_importance = np.random.default_rng(seed + 1777)

    for task_idx, task in enumerate(tasks):
        pre_old = [accuracy(model, tasks[j]) for j in range(task_idx)]

        if len(memory) >= 2:
            score, mean_r, locked, ambiguous = conflict_score(memory)
            shuffled_anchor = conflict_score(
                memory,
                rng=rng_anchor,
                shuffle_anchor=True,
            )[0]
            shuffled_importance = conflict_score(
                memory,
                rng=rng_importance,
                shuffle_importance=True,
            )[0]
        else:
            score = shuffled_anchor = shuffled_importance = None
            mean_r = locked = ambiguous = None

        importance = ThermalImportance(model)
        optimizer = torch.optim.SGD(
            model.parameters(),
            lr=LR,
            momentum=MOMENTUM,
        )
        x, y = task
        gen = torch.Generator().manual_seed(seed * 100 + task_idx)

        for _ in range(EPOCHS):
            order = torch.randperm(N, generator=gen)
            for start in range(0, N, BATCH):
                idx = order[start : start + BATCH]
                optimizer.zero_grad()
                loss = torch.nn.functional.binary_cross_entropy_with_logits(
                    model(x[idx]),
                    y[idx],
                )
                if memory:
                    loss = loss + LAMBDA_TCL * memory_penalty(model, memory)
                loss.backward()
                importance.accumulate(model)
                optimizer.step()

        memory.append(
            Checkpoint(
                weights={
                    name: param.detach().clone()
                    for name, param in model.named_parameters()
                },
                importance=importance.finalize(),
            )
        )

        if score is not None:
            post_old = [accuracy(model, tasks[j]) for j in range(task_idx)]
            new_acc = accuracy(model, task)

            rows.append(
                {
                    "score": score,
                    "shuffle_anchor": shuffled_anchor,
                    "shuffle_importance": shuffled_importance,
                    "forget_signed": float(
                        np.mean(np.asarray(pre_old) - np.asarray(post_old))
                    ),
                    "forget_positive": float(
                        np.mean(
                            np.maximum(
                                0.0,
                                np.asarray(pre_old) - np.asarray(post_old),
                            )
                        )
                    ),
                    "post_old_accuracy": float(np.mean(post_old)),
                    "new_accuracy": new_acc,
                    "joint_accuracy": float(np.mean(post_old + [new_acc])),
                    "mean_r": mean_r,
                    "locked_fraction": locked,
                    "ambiguous_fraction": ambiguous,
                }
            )

    return rows


def correlation(rows, predictor: str, target: str):
    x = np.asarray([row[predictor] for row in rows], dtype=float)
    y = np.asarray([row[target] for row in rows], dtype=float)
    p = pearsonr(x, y)
    s = spearmanr(x, y)
    return float(p.statistic), float(p.pvalue), float(s.statistic), float(s.pvalue)


def main():
    rows = []
    for offset in range(TRIALS):
        rows.extend(run_trial(SEED_BASE + offset))

    print(f"transition_points={len(rows)}")
    print(
        "mean_state "
        f"r={np.mean([row['mean_r'] for row in rows]):.6f} "
        f"locked={np.mean([row['locked_fraction'] for row in rows]):.6f} "
        f"ambiguous={np.mean([row['ambiguous_fraction'] for row in rows]):.6f}"
    )

    targets = [
        "forget_signed",
        "forget_positive",
        "post_old_accuracy",
        "new_accuracy",
        "joint_accuracy",
    ]
    predictors = ["score", "shuffle_anchor", "shuffle_importance"]

    for predictor in predictors:
        print(f"\n[{predictor}]")
        for target in targets:
            r, p, rho, ps = correlation(rows, predictor, target)
            print(
                f"{target:20s} "
                f"pearson_r={r:+.6f} p={p:.6g} "
                f"spearman_rho={rho:+.6f} p={ps:.6g}"
            )


if __name__ == "__main__":
    main()
