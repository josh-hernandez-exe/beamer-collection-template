# Development Container Configuration

This directory contains the configuration for the Beamer Collection Template development container, optimized for LaTeX presentation development with Python support.

## Features

### Python (via Microsoft Official Feature)
- **Version**: 3.12
- **Install Tools**: pip, venv, poetry pre-installed
- **Performance**: Uses pre-built binaries (no compilation overhead)

### LaTeX (via Community Feature)
- Uses `prulloac/devcontainer-features/latex:1` for TeX Live installation
- Includes: texlive-full, biber, chktex
- Optimized for Beamer presentations and professional documents

### Additional Tools
- **pandoc**: For PDF to PowerPoint conversion
- **LibreOffice**: LibreOffice Impress for PPTX generation

## Build Configuration

### Base Image
- `mcr.microsoft.com/devcontainers/base:ubuntu-24.04` — Microsoft's official Ubuntu 24.04 base with git, curl, wget, build-essential pre-installed

### Setup Script
- `setup.sh`: Post-creation hook that installs Python dependencies from `requirements.txt` and the `uv` package manager for faster dependency resolution

### Extensions
- **latex-workshop**: LaTeX editing and compilation
- **python**: Python language support
- **ruff**: Fast Python linter/formatter
- **pylint**: Python code analysis
- **gitlens**: Git integration
- **even-better-toml**: TOML syntax highlighting
- **jupyter**: Jupyter notebook support
- **vscode-jupyter-cell-delimiters**: Jupyter cell delimiters

## LaTeX Workshop Configuration

Two build recipes configured:

1. **latexmk** — Standard latexmk-based build (pdflatex, bibliography, cross-references)
2. **latexmk (minted)** — Includes `-shell-escape` for syntax highlighting with minted package

Both recipes use:
- `-pdf`: Generate PDF output
- `-cd`: Change to document directory before building
- `-quiet`: Suppress verbose output

## Performance Notes

- **Python Installation**: Removed `"optimize": true` to use pre-built binaries instead of compiling from source (~2 min vs ~15+ min)
- **LaTeX**: Uses community feature instead of manual apt-get installation for better maintenance
- **Build Time**: Total container build should now complete in 5-10 minutes depending on system

## Customization

To modify this configuration:

1. **Add Python packages**: Update `requirements.txt` in workspace root
2. **Add VS Code extensions**: Add to `devcontainer.json` under `customizations.vscode.extensions`
3. **Change Python version**: Update `features.python.version` in `devcontainer.json`
4. **Modify LaTeX tools**: Update `latex-workshop.latex.tools` in `devcontainer.json`

## Troubleshooting

### LaTeX build fails
- Ensure all `.tex` files in your project directory are readable
- Check `shared-colors.sty` and theme paths are correct (see copilot-instructions.md)

### Python packages won't install
- Rebuild the container: `devcontainer rebuild`
- Check `requirements.txt` syntax and package availability

### Build taking too long
- If you see "Compiling Python from source", ensure `"optimize": false` in devcontainer.json
