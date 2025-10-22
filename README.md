# Python GitHub Actions Demo

This is a simple Python project to demonstrate CI/CD using GitHub Actions.

## Project Structure
- `main.py`: Main script
- `test_main.py`: Unit tests
- `.github/workflows/python-app.yml`: GitHub Actions workflow for CI/CD

## How to Run Locally
```bash
python main.py
python -m unittest test_main.py
```

## How CI/CD Works
- On every push or pull request to `main`, GitHub Actions will:
  - Checkout code
  - Set up Python
  - Install dependencies
  - Run unit tests

See `.github/workflows/python-app.yml` for details.
