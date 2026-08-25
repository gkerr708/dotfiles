#!/usr/bin/env python3
"""An example for dark-modern.mplstyle, distinct from preview_dark_modern.png's
generic line/bar/scatter grid -- a single accuracy-curve chart that actually
shows off what changed: borderless grid axes, thick rounded lines, and
markers with a dark cutout ring.

Not stowed into $HOME -- lives here purely as a reference/demo for the styles
defined in home/.config/matplotlib/. Run with: python3 dark_example.py
"""
import pathlib

import matplotlib.pyplot as plt
import numpy as np

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
MPL_DIR = REPO_ROOT / "home" / ".config" / "matplotlib"
OUT_DIR = pathlib.Path(__file__).resolve().parent


def main():
    rng = np.random.default_rng(1)
    epochs = np.arange(1, 21)
    train = 60 + 30 * (1 - np.exp(-epochs / 6)) + rng.normal(0, 0.6, epochs.size)
    test = 55 + 22 * (1 - np.exp(-epochs / 7)) + rng.normal(0, 0.9, epochs.size)

    style_files = [str(MPL_DIR / "matplotlibrc"), str(MPL_DIR / "stylelib" / "dark-modern.mplstyle")]
    with plt.style.context(["default", *style_files]):
        fig, ax = plt.subplots(figsize=(7, 4.5))
        ax.plot(epochs, train, marker="o", label="Training accuracy")
        ax.plot(epochs, test, marker="o", label="Held-out accuracy")
        ax.set_xlabel("Epoch")
        ax.set_ylabel("Accuracy (%)")
        ax.set_title("dark-modern.mplstyle: borderless grid, thick rounded lines, cutout markers")
        ax.legend()
        out_path = OUT_DIR / "dark_example.png"
        fig.savefig(out_path)
        plt.close(fig)
        print(f"wrote {out_path.relative_to(REPO_ROOT)}")


if __name__ == "__main__":
    main()
