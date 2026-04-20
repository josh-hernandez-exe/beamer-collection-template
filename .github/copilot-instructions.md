# Beamer Collection Template - Coding Guidelines

This repository is a template for creating **LaTeX Beamer presentations** and **professional documents** with support for Python automation and image generation. The template is designed for mathematical, scientific, and programming content.

## Repository Purpose

- Create beautiful, reusable LaTeX presentations using Beamer themes
- Generate technical documents with consistent styling
- Use Python scripts to automate presentation generation and create visualizations
- Support for 13+ programming languages with syntax highlighting
- Built for GitHub Codespaces and local Docker development environments

## Development Container Setup

This repository includes a pre-configured development container for GitHub Codespaces and local Docker environments with Python 3.12, TeX Live, LaTeX Workshop, and PDF conversion tools.

For detailed configuration, features, customization, and troubleshooting, see [`.devcontainer/README.md`](.devcontainer/README.md).

## LaTeX Conventions

### Using the Style Files
- **Always** use the shared style files from `common/styles/`, `common/styles/presentations/`, or `common/styles/documents/`
- Load styles in the prescribed order in your `main.tex` to avoid conflicts
- Do **not** modify theme files without explicit intention; instead, customize in your project-specific `main.tex` or create a `.sty` file for your project

### LaTeX Workflow
- Build using `./scripts/build.sh` or VS Code LaTeX Workshop
- Output PDFs go to the `out/` folder (git-ignored)
- Always use vector image formats (.pdf, .svg) when possible; rasterize for output if needed
- Place presentation-specific images in the `images/` subfolder and use relative paths

### Preamble Structure
Each LaTeX file typically follows this pattern:
```latex
\documentclass[aspectratio=169]{beamer}  % or article for documents

\graphicspath{...}  % Define image search paths

\usepackage{../../../../common/styles/shared-listings}      % Shared code highlighting
\usepackage{../../../../common/styles/presentations/common-packages}  % Theme packages

\usepackage{../../themes/university/beamerthemeUniversity}   % Theme

\usepackage{../../../../common/styles/presentations/common-after}      % Final setup

% Your project-specific customization
\newcommand{\texTitle}{My Presentation}
\newcommand{\texSubTitle}{Subtitle Here}
\newcommand{\texShortTitle}{My Pres}
\newcommand{\texAuthor}{Your Name}
```

## Python Conventions

Python is used primarily for:
- Generating images and plots to embed in presentations
- Automating document generation
- Data analysis and visualization

### Code Style
- Follow **PEP 8** for formatting and naming
- Use **Ruff** as your formatter and linter (configured in VS Code)
- Include **type hints** for all functions and variables where possible
- Keep lines to 100 characters or fewer
- Use `UPPER_SNAKE_CASE` for constants
- Single return statement per function (use ternary operators sparingly)
- Add docstrings to all functions (Google style)

### Code Location
- Place Python scripts in the `code/` subfolder of each presentation or document
- Scripts that generate images should output to `code/images/` or `images/` (depending on scope)
- Use relative imports and avoid hardcoded paths; parameterize file locations

### Example Python Script
```python
"""Generate a sample plot for the presentation."""

import matplotlib.pyplot as plt
import numpy as np

def generate_plot(output_path: str) -> None:
    """Generate a simple plot and save to file.

    Args:
        output_path: Path where the plot PDF should be saved.
    """
    x = np.linspace(0, 2 * np.pi, 100)
    y = np.sin(x)

    plt.figure(figsize=(8, 6))
    plt.plot(x, y, label="sin(x)")
    plt.legend()
    plt.savefig(output_path, format="pdf", dpi=300, bbox_inches="tight")
    plt.close()

if __name__ == "__main__":
    generate_plot("../images/sample-plot.pdf")
```

## Support for Code in Slides

Listings are configured for:

### Adding a New Language

- **JSON, YAML** (for configuration and data files)

### Adding a New Language

Edit `common/styles/shared-listings.sty` and add a `\lstdefinelanguage` block:
```latex
\lstdefinelanguage{MyLanguage}{
    keywords={keyword1,keyword2},
    keywordstyle=\ttb\color{deepblue},
    commentstyle=\color{CommentDarkGreen}\ttm,
    stringstyle=\color{deepgreen},
    basicstyle=\ttm,
    ...
}

\lstdefinestyle{myLanguageStyle}{
    language=MyLanguage,
    ...
}
```

Then use in your presentation:
```latex
\begin{lstlisting}[style=myLanguageStyle]
// your code here
\end{lstlisting}
```

## File Organization

Each presentation or document folder follows this structure:
```
presentations/my-project/
├── main.tex                    # Root document
├── 00-title.tex               # First content file
├── 10-section-one.tex         # Numbered files for ordering
├── 20-section-two.tex
├── code/                      # Python scripts, code examples
│   ├── generate-plots.py
│   └── images/               # Generated images from scripts
├── images/                    # Hand-made images, diagrams
│   ├── diagram.pdf
│   └── photo.jpg
└── references/                # Bibliography files
    └── references.bib
```

## Customization for Your Project

**Important:** You should **customize this file** to reflect your project's specific needs!

### Recommended Customizations
1. Add your name and contact information at the top
2. Document your project-specific LaTeX macros and naming conventions
3. Specify any additional Python libraries your project uses
4. Note any special build requirements or scripts
5. Document your color scheme and design choices if different from the templates
6. Add guidelines for contributors if this is a team project

### Example Custom Section
```
## [Your Organization] Specific Guidelines

- We use the **University of Twin Stars** theme for all presentations
- Documents use the corporate template with **blue** and **gold** colors
- All presentations must include a title slide, abstract slide, and references
- Python plots must use matplotlib with our custom color palette: [...]
- All presentations are 16:9 aspect ratio (widescreen)
```

## Building Presentations

### From VS Code
- Open a `.tex` file and use **Ctrl+Alt+B** (or Cmd+Option+B on Mac) to build
- PDF opens in a tab automatically

### From Command Line
```bash
# Build a specific presentation
./scripts/build.sh presentations/my-project

# Build all presentations and documents
./scripts/build-all.sh

# Build a file with a non-standard name
./scripts/build.sh presentations/my-project --texfile lecture.tex

# Copy all PDFs to dropbox/ folder for distribution
./scripts/copy.sh
```

## PDF to PowerPoint Conversion

To convert all presentation PDFs to PPTX in one step (outputs to `dropbox/`):
```bash
./scripts/pdf-to-pptx-all.sh
```

To convert a single PDF:
```bash
./scripts/pdf-to-pptx.sh presentations/my-project/out/main.pdf dropbox/my-project-main.pptx
```

Requires `pdf2image`, `python-pptx`, `pillow` (Python) and `poppler-utils` (system) — installed automatically by the devcontainer.

## Version Control

- **Commit** LaTeX source files (`.tex`), images, and configuration
- **Ignore** compiled PDFs in presentations and documents (`.gitignore` configured)
- **Track** final PDFs only in the `dropbox/` folder for distribution
- Commit frequently with clear messages describing content changes

### Commit Style — Conventional Commits

All commits must follow [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <short description>

[optional body]

[optional footer]
```

#### Types

Stay as close as possible to the standard types. The following are valid:

| Type | When to use |
|------|-------------|
| `feat` | New slide, section, figure, or content added |
| `fix` | Correcting errors in content, layout, or logic |
| `docs` | Changes to README, instructions, or comments only |
| `style` | Formatting, whitespace, theme tweaks — no content change |
| `refactor` | Restructuring slides/files without changing content |
| `chore` | Build scripts, devcontainer config, `.gitignore`, tooling |
| `ci` | GitHub Actions, automation workflows |
| `revert` | Reverting a previous commit |

#### Scopes

Scopes are **optional but encouraged**. Use them to clarify what part of the project changed. Customize these per project — examples for this template:

- `presentations/corporate-demo` or just `corporate-demo`
- `documents/university-demo` or just `university-demo`
- `theme/university`, `theme/corporate`
- `styles` — shared `.sty` files in `common/styles/`
- `devcontainer` — `.devcontainer/` config
- `scripts` — anything in `scripts/`
- `deps` — LaTeX package or Python dependency changes

#### Examples

```
feat(university-demo): add background section on Fourier transforms
fix(corporate-demo): correct author name on title slide
style(styles): adjust heading color in shared-colors.sty
chore(devcontainer): add nicematrix and pgfplots to package list
chore(scripts): output PPTX to dropbox/ with matching filenames
refactor(styles): move documents/common/styles to common/styles/documents
docs: update copilot-instructions with conventional commits guide
```

#### Breaking Changes

If a change affects how others use the template (e.g. renaming a shared macro, moving a style file), note it in the footer:

```
refactor(styles): rename common-after-doc.sty to common-after.sty

BREAKING CHANGE: projects using \usepackage{common-after-doc} must update to \usepackage{common-after}
```

## Getting Help

Refer to the template's README.md for:
- Quick-start instructions
- Folder structure overview
- Command reference
- Link to additional resources (LaTeX, Python, Beamer documentation)

---

**Last Updated:** April 20, 2026
