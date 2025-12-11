# Python CLI Template

Python Command-Line Interface starter with Click.

## Quick Start

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python cli.py --help
```

## Stack

- Click (CLI framework)
- Rich (beautiful terminal output)
- Pytest
- Black (formatter)

## Structure

```
src/
├── commands/
├── utils/
└── cli.py

tests/
└── test_cli.py
```

## Usage

```bash
python cli.py command --option value
```
