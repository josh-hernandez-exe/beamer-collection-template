# Beamer Collection Template

A public GitHub template for creating beautiful LaTeX Beamer presentations and professional documents with Python automation, designed for GitHub Codespaces and local Docker development.

**Perfect for:** Academic presentations, corporate reports, technical documentation, scientific papers, and any content combining LaTeX, code, and images.

## Features

- ✨ **Two Professional Themes**
  - **University of Twin Stars** — Academic, warm color palette (navy, crimson, gold)
  - **ACME Corp** — Corporate, modern flat design (charcoal, red)

- 🚀 **Python-Focused Automation**
  - Generate plots and images with matplotlib, seaborn, etc.
  - Automate presentation generation with AI chat bots
  - Full support for Jupyter notebooks in devcontainer

- 💻 **13+ Languages Syntax Highlighting**
  - Python, Java, JavaScript, TypeScript
  - Bash/Shell, PowerShell
  - C, C++, C#, Rust, Go, Ruby
  - JSON, YAML

- 📦 **GitHub Codespaces Ready**
  - Open in browser, no local setup
  - All LaTeX, Python, and tooling pre-installed
  - VS Code configured with extensions

- 🐳 **Local Docker Support**
  - Run via VS Code devcontainer
  - Reproducible build environment
  - PDF → PowerPoint conversion pipeline

- 🔧 **Smart Build Scripts**
  - Build single projects or all at once
  - Automatic PDF copying to distribution folder
  - PDF to PPTX conversion via pandoc/LibreOffice

## Quick Start

### Option 1: GitHub Codespaces (Recommended)

1. Click **"Code" → "Codespaces" → "Create codespace on main"** (or use this button)
2. Wait for environment to initialize (~2 minutes)
3. Open a terminal and run:
   ```bash
   ./scripts/build.sh presentations/university-demo
   ```
4. PDF opens in VS Code PDF viewer!

### Option 2: Local Docker via VS Code

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/beamer-collection-template.git
   cd beamer-collection-template
   ```

2. Open in VS Code with devcontainer:
   - Install "Dev Containers" extension
   - Press `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"
   - Wait for environment setup

3. Build a presentation:
   ```bash
   ./scripts/build.sh presentations/university-demo
   ```

#### Optional: 1Password SSH Agent Forwarding In Devcontainer

If you use 1Password to manage SSH keys, the devcontainer can forward your host SSH agent socket into the container using the `mounts` block in `.devcontainer/devcontainer.json`.

Use exactly one host-specific mount entry:

- Linux host:
   - `"source=${localEnv:HOME}/.1password/agent.sock,target=/tmp/1p-agent.sock,type=bind"`
- macOS host:
   - `"source=/Users/${localEnv:USER}/.1password/agent.sock,target=/tmp/1p-agent.sock,type=bind"`
- Windows (WSL2):
   - `"source=//./pipe/openssh-ssh-agent,target=/tmp/1p-agent.sock,type=bind"`

Keep `remoteEnv.SSH_AUTH_SOCK` set to `/tmp/1p-agent.sock`.

Common failure mode: using a macOS path (`/Users/...`) on Linux (`/home/...`) causes the container startup bind mount to fail.

Quick validation on host before rebuilding:

```bash
ls -l "$HOME/.1password/agent.sock"
```

Quick validation inside container after rebuild:

```bash
echo "$SSH_AUTH_SOCK"
ssh-add -l
```

### Option 3: Your Local Machine

Requires: TeXLive (or similar), Python 3.8+, pandoc

```bash
./scripts/build.sh presentations/university-demo
```

## Project Structure

```
beamer-collection-template/
├── presentations/                 # Beamer presentations
│   ├── common/styles/            # Shared Beamer packages
│   ├── themes/
│   │   ├── university/           # University of Twin Stars theme
│   │   └── corporate/            # ACME Corp theme
│   ├── university-demo/          # Example presentation (Twin Stars)
│   ├── corporate-demo/           # Example presentation (Corporate)
│   └── your-project/             # Create your own here!
│
├── documents/                     # Non-Beamer documents (articles, reports)
│   ├── common/styles/            # Shared document packages
│   ├── themes/
│   │   ├── university/           # University document style
│   │   └── corporate/            # Corporate document style
│   ├── university-demo/          # Example document (Twin Stars)
│   ├── corporate-demo/           # Example document (Corporate)
│   └── your-document/            # Create your own here!
│
├── common/
│   ├── styles/                   # Shared across all (listings, colors)
│   ├── images/                   # Shared images
│   └── references/               # Shared bibliography
│
├── scripts/                       # Build automation
│   ├── build.sh                  # Build one project
│   ├── build-all.sh              # Build all projects
│   ├── copy.sh                   # Copy PDFs to dropbox/
│   └── pdf-to-pptx.sh            # Convert PDF to PowerPoint
│
├── dropbox/                       # Distribution folder (git-tracked)
│   └── *.pdf                     # Final PDFs for sharing
│
├── .devcontainer/                # Docker + Codespaces config
├── .vscode/                      # VS Code settings + extensions
├── .github/
│   └── copilot-instructions.md   # Guidelines for AI chat bots
└── .gitignore                    # Ignore LaTeX artifacts, Python cache, etc.
```

## How To...

### Create a New Presentation

1. **Copy a demo folder**
   ```bash
   cp -r presentations/university-demo presentations/my-awesome-slides
   cd presentations/my-awesome-slides
   ```

2. **Edit `main.tex`**
   - Change `\newcommand{\texTitle}{...}`, `\newcommand{\texSubTitle}{...}`, etc.
   - Adjust `\usepackage{../../themes/...}` to pick your theme (or create a custom one)

3. **Add content**
   - Edit `00-title.tex`, `10-introduction.tex`, `20-content.tex`
   - Add numbered sections: `30-results.tex`, `40-conclusion.tex`

4. **Build it**
   ```bash
   ./scripts/build.sh presentations/my-awesome-slides
   ```

5. **Generate plots (Python)**
   - Create scripts in `code/` folder
   - Generate images to `images/` via:
     ```python
     plt.savefig("../images/my-plot.pdf", format="pdf", dpi=300)
     ```
   - Include in slides: `\includegraphics{images/my-plot.pdf}`

### Create a New Document

1. **Copy a demo folder**
   ```bash
   cp -r documents/university-demo documents/my-report
   cd documents/my-report
   ```

2. **Edit `main.tex`**
   - Set `\newcommand{\texTitle}{...}`, `\newcommand{\texAuthor}{...}`
   - Pick theme: `university` or `corporate`

3. **Build it**
   ```bash
   ./scripts/build.sh documents/my-report
   ```

### Add Support for a New Programming Language

1. Edit `common/styles/shared-listings.sty`
2. Add `\lstdefinelanguage{MyLanguage}{...}` block
3. Define a style: `\lstdefinestyle{mylanguagestyle}{...}`
4. Use in slides/docs: `\begin{lstlisting}[style=mylanguagestyle]...\end{lstlisting}`

See the end of `shared-listings.sty` for a template.

### Convert PDF to PowerPoint

```bash
./scripts/pdf-to-pptx.sh presentations/my-project/out/main.pdf
# Output: presentations/my-project/out/main.pptx

# Or specify custom output:
./scripts/pdf-to-pptx.sh presentations/my-project/out/main.pdf out/my-presentation.pptx
```

Requires: `pandoc` and/or `libreoffice` (included in devcontainer)

## Scripts Reference

### `./scripts/build.sh <project-path> [--texfile FILENAME.tex]`

Build a single presentation or document.

**Examples:**
```bash
./scripts/build.sh presentations/university-demo
./scripts/build.sh presentations/my-project --texfile lecture.tex
./scripts/build.sh documents/my-report --texfile handout.tex
```

**Output:** `<project-path>/out/main.pdf` (or `<texfile-without-extension>.pdf`)

### `./scripts/build-all.sh [--texfiles FILE1.tex,FILE2.tex,...]`

Build all presentations and documents in the workspace.

**Examples:**
```bash
./scripts/build-all.sh                           # Build all main.tex files
./scripts/build-all.sh --texfiles lecture.tex,handout.tex  # Build lecture and handout variants
```

### `./scripts/copy.sh`

Copy compiled PDFs from `presentations/*/out/` and `documents/*/out/` to `dropbox/` for distribution.

**Behavior:**
- Copies `presentations/my-project/out/main.pdf` → `dropbox/my-project-main.pdf`
- Skips if destination file is identical (preserves timestamps)
- Creates `dropbox/` if it doesn't exist

**Usage:**
```bash
./scripts/copy.sh
```

### `./scripts/pdf-to-pptx.sh <pdf-file> [output-file.pptx]`

Convert PDF presentation to PowerPoint.

**Examples:**
```bash
./scripts/pdf-to-pptx.sh presentations/my-project/out/main.pdf
./scripts/pdf-to-pptx.sh presentations/my-project/out/main.pdf out/my-presentation.pptx
```

**How it works:**
1. Tries `pandoc` first (fastest)
2. Falls back to `libreoffice` if pandoc unavailable
3. Outputs `.pptx` with reasonable defaults (1 PDF page = 1 slide)

**Note:** Conversion quality depends on PDF complexity. Slide layout may need adjustment in PowerPoint.

## Customization

### Customize copilot-instructions.md

The `.github/copilot-instructions.md` file guides AI chat bots on your project's conventions.

**Edit it to add:**
- Your name/organization
- Custom color schemes
- Domain-specific LaTeX macros (e.g., `\expectation{X}` for probability)
- Special build requirements
- Naming conventions for your slides
- Links to your brand guidelines

### Create Custom Themes

1. **For Presentations:** Create a new `.sty` file in `presentations/themes/my-theme/`
   - Import `shared-colors.sty` for consistency
   - Define `\setbeamercolor{}`, `\setbeamertemplate{}`, etc.
   - See `beamerthemeUniversity.sty` as a template

2. **For Documents:** Create a new `.sty` file in `documents/themes/my-theme/`
   - Import `shared-colors.sty`
   - Use `fancyhdr` for headers/footers
   - See `documentstyleUniversity.sty` as a template

### Adjust Colors

Edit `common/styles/shared-colors.sty` to change RGB values for:
- `TwinStarsBlue`, `TwinStarsCrimson`, `TwinStarsGold`, `TwinStarsSilver`
- `AcmeCharcoal`, `AcmeRed`, `AcmeGray`, `AcmeOffWhite`

Then all themes automatically use the new palette.

## Python + Automation

### Installing Packages

The devcontainer includes `uv` for fast package installation:

```bash
uv pip install requests pandas plotly
```

Or use `pip` directly (slower):
```bash
pip install numpy scipy matplotlib seaborn
```

Installed packages are automatically available in `code/` scripts.

### Generating Plots Programmatically

Example in `code/generate_plots.py`:

```python
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

def generate_sine_plot(output_path: str) -> None:
    x = np.linspace(0, 2*np.pi, 100)
    y = np.sin(x)
    plt.figure(figsize=(8, 6))
    plt.plot(x, y, linewidth=2)
    plt.savefig(output_path, format="pdf", dpi=300, bbox_inches="tight")
    plt.close()

if __name__ == "__main__":
    Path("../images").mkdir(exist_ok=True)
    generate_sine_plot("../images/sine.pdf")
```

Run before building slides:
```bash
cd presentations/my-project/code
python3 generate_plots.py
```

### Using with AI Chat Bots (e.g., Claude, ChatGPT)

In `.github/copilot-instructions.md`, the template includes:
- LaTeX naming conventions
- Python style guide (PEP 8, type hints)
- Code organization expectations
- Image generation patterns

**Example prompt to Claude:**

> I'm using the beamer-collection-template repo. Create a Python script that generates a bar chart comparing Q1-Q4 revenue for the corporate demo. Output should go to `presentations/corporate-demo/images/revenue-chart.pdf`.

Claude will follow your project's conventions and generate code ready to use!

## Troubleshooting

### Build fails with "Package not found" error

**Solution:** Some `.sty` files may be missing or paths incorrect.

1. Check relative paths in your `main.tex`
2. Ensure you're using the correct theme path: `../../themes/university/` (for presentations) or `../../themes/corporate/` (for documents)
3. Verify file exists: `ls presentations/themes/university/beamerthemeUniversity.sty`

### PDF viewer doesn't open in VS Code

**Solution:** LaTeX Workshop may need a manual build trigger.

1. Press `Ctrl+Alt+B` (or `Cmd+Option+B` on Mac)
2. Or click the "Build" button in the LaTeX Workshop sidebar

### Pandoc conversion produces ugly slides

**Solution:** Pandoc's PDF→PPTX conversion has limitations (no backgrounds, formatting loss).

1. Use for text-heavy slides (acceptable quality)
2. For visual-heavy presentations, consider:
   - Exporting from Beamer as PNG+reassembling in PowerPoint
   - Rewriting the final version directly in PowerPoint
   - Using `beamer-to-pptx` converter tools

### Python script can't find modules

**Solution:** Install packages in the active environment.

```bash
# In devcontainer terminal
pip install numpy matplotlib pandas
# Or:
uv pip install numpy matplotlib pandas
```

## Contributing

Found a bug or have ideas?

1. Open an issue describing the problem
2. Fork, make changes, test locally
3. Submit a pull request with clear description

## License

This template is provided as-is for educational and professional use.

Themes are based on:
- **University theme:** JHSPH Theme by Jacob Fiksel (Feb 2017), University of Tennessee theme by Enda Hargaden
- **Corporate theme:** Custom modern design

Feel free to customize for your organization!

## Getting Help

- **LaTeX questions:** [TeX Stack Exchange](https://tex.stackexchange.com)
- **Beamer docs:** [Official Beamer Manual](https://ctan.org/pkg/beamer)
- **Python help:** [Python Docs](https://docs.python.org/3/), [Stack Overflow](https://stackoverflow.com)
- **VS Code:** Press `F1` and search for help on any command

---

**Made with ❤️ for beautiful LaTeX presentations, Docker, and AI-assisted content creation.**

Last updated: April 19, 2026
