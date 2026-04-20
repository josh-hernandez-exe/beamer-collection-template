# Python example: Generate a sample plot
# Place this file in code/ and run with: python3 generate_plot.py

import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

def generate_example_plot(output_path: str) -> None:
    """Generate an example plot for the presentation.

    Args:
        output_path: Path where the PDF should be saved.
    """
    x = np.linspace(0, 2 * np.pi, 100)
    y = np.sin(x)

    plt.figure(figsize=(8, 6))
    plt.plot(x, y, linewidth=2, label="sin(x)", color="#143B6E")
    plt.fill_between(x, 0, y, alpha=0.2, color="#A01423")
    plt.xlabel("x")
    plt.ylabel("y")
    plt.title("Example: Sine Wave")
    plt.legend()
    plt.grid(True, alpha=0.3)
    plt.tight_layout()

    Path(output_path).parent.mkdir(parents=True, exist_ok=True)
    plt.savefig(output_path, format="pdf", dpi=300)
    plt.close()

    print(f"Plot saved to {output_path}")

if __name__ == "__main__":
    generate_example_plot("../images/example-plot.pdf")
