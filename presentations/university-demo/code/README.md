# Presentation Scripts

This folder contains Python code and data generation scripts for presentations.

Place scripts here that:
- Generate plots and visualizations with matplotlib, seaborn, plotly, etc.
- Create data tables or analysis results
- Automate slide content generation

## Example Workflow

1. Create a script: `generate_charts.py`
2. Run it: `python3 generate_charts.py`
3. Include output in your presentation: `\includegraphics{images/chart.pdf}`

## Best Practices

- Use relative paths (e.g., `../images/output.pdf`)
- Include docstrings and type hints (PEP 8)
- Keep scripts self-contained with clear inputs/outputs
- Generate PDFs via matplotlib (vector format, scales perfectly)
