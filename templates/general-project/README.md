# 7 Habits Workshop

An interactive workshop and tracking system based on Stephen Covey's "The 7 Habits of Highly Effective People".

## Features

- Track progress on all 7 habits
- Set goals and action items for each habit
- Reflection journal and notes
- Progress tracking and analytics
- Export progress reports

## Installation

```bash
cd templates/general-project
pip install -e .
```

## Quick Start

```bash
# Start the workshop
habits workshop

# Track a habit
habits track "Be Proactive" --action "Responded calmly to criticism"

# View progress
habits progress

# Add reflection
habits reflect "Today I focused on habit 1..."

# Export report
habits export --format markdown
```

See [docs/USAGE.md](docs/USAGE.md) for detailed usage guide.

## Project Structure

```
7-habits-workshop/
├── src/
│   └── seven_habits_workshop/
│       ├── __init__.py
│       ├── main.py       # CLI interface
│       ├── habit.py      # Habit tracking classes
│       └── utils.py      # Utilities
├── tests/
│   ├── __init__.py
│   ├── test_main.py
│   ├── test_habit.py
│   └── test_utils.py
├── docs/
│   ├── QUICKSTART.md
│   └── USAGE.md
├── .gitignore
├── pyproject.toml
├── README.md
└── LICENSE
```

## Development

```bash
# Install development dependencies
pip install -e ".[dev]"

# Run tests
pytest

# Format code
black src/ tests/

# Lint code
flake8 src/ tests/
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - See LICENSE file for details
