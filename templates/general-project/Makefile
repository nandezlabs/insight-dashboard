.PHONY: help install install-dev test lint format clean build

help:
	@echo "Available commands:"
	@echo "  make install      Install package"
	@echo "  make install-dev  Install with dev dependencies"
	@echo "  make test         Run tests"
	@echo "  make lint         Run linters"
	@echo "  make format       Format code"
	@echo "  make clean        Clean build artifacts"
	@echo "  make build        Build package"

install:
	pip install -e .

install-dev:
	pip install -e ".[dev]"

test:
	pytest -v --cov=src --cov-report=term-missing

lint:
	flake8 src/ tests/
	mypy src/

format:
	black src/ tests/
	isort src/ tests/

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info
	rm -rf .pytest_cache/
	rm -rf .mypy_cache/
	rm -rf htmlcov/
	rm -rf .coverage
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

build: clean
	python -m build
