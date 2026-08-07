#!/usr/bin/env python3
"""Render preview figures for the default/dark/minimal matplotlib styles.

Not stowed into $HOME — lives here purely as a reference/demo for the styles
defined in home/.config/matplotlib/. Run with: python3 preview.py
"""
import pathlib

import matplotlib.pyplot as plt
import numpy as np

REPO_ROOT = pathlib.Path(__file__).resolve().parent.parent
MPL_DIR = REPO_ROOT / "home" / ".config" / "matplotlib"
OUT_DIR = pathlib.Path(__file__).resolve().parent

STYLES = {
    "default": [MPL_DIR / "matplotlibrc"],
    "dark": [MPL_DIR / "matplotlibrc", MPL_DIR / "stylelib" / "dark.mplstyle"],
    "minimal": [MPL_DIR / "matplotlibrc", MPL_DIR / "stylelib" / "minimal.mplstyle"],
}


def plot_lines(ax, rng):
    x = np.linspace(0, 10, 200)
    for i in range(6):
        ax.plot(x, np.sin(x + i * 0.6) + i * 0.4, label=f"series {i + 1}")
    ax.set_title("Line")
    ax.legend()


def plot_bars(ax, rng):
    categories = ["A", "B", "C", "D", "E"]
    ax.bar(categories, rng.uniform(2, 10, size=5), color=plt.rcParams["axes.prop_cycle"].by_key()["color"][:5])
    ax.set_title("Bar")


def plot_scatter(ax, rng):
    for i in range(4):
        x = rng.normal(i, 0.6, size=60)
        y = rng.normal(i * 0.5, 0.6, size=60)
        ax.scatter(x, y, label=f"cluster {i + 1}", alpha=0.8)
    ax.set_title("Scatter")
    ax.legend()


def render(style_name, rc_files):
    rng = np.random.default_rng(0)
    with plt.style.context(["default", *[str(p) for p in rc_files]]):
        fig, axes = plt.subplots(1, 3, figsize=(14, 4.2))
        fig.suptitle(f"matplotlib style: {style_name}")
        plot_lines(axes[0], rng)
        plot_bars(axes[1], rng)
        plot_scatter(axes[2], rng)
        out_path = OUT_DIR / f"preview_{style_name}.png"
        fig.savefig(out_path)
        plt.close(fig)
    return out_path


def main():
    for style_name, rc_files in STYLES.items():
        out_path = render(style_name, rc_files)
        print(f"wrote {out_path.relative_to(REPO_ROOT)}")


if __name__ == "__main__":
    main()
