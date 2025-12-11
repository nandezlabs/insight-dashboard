"""
Tests for utility functions
"""

import pytest
import json
from pathlib import Path
from project_name.utils import (
    load_config,
    save_config,
    format_size,
    validate_path,
)


def test_format_size():
    """Test size formatting"""
    assert format_size(100) == "100.00 B"
    assert format_size(1024) == "1.00 KB"
    assert format_size(1024 * 1024) == "1.00 MB"
    assert format_size(1024 * 1024 * 1024) == "1.00 GB"


def test_save_and_load_config(tmp_path):
    """Test configuration save and load"""
    config_file = tmp_path / "config.json"
    test_config = {"key": "value", "number": 42}

    save_config(test_config, config_file)
    assert config_file.exists()

    loaded_config = load_config(config_file)
    assert loaded_config == test_config


def test_load_config_missing_file(tmp_path):
    """Test loading non-existent config file"""
    with pytest.raises(FileNotFoundError):
        load_config(tmp_path / "missing.json")


def test_validate_path_existing(tmp_path):
    """Test path validation with existing path"""
    test_file = tmp_path / "test.txt"
    test_file.touch()

    validated = validate_path(test_file, must_exist=True)
    assert validated.exists()


def test_validate_path_missing():
    """Test path validation with missing path"""
    with pytest.raises(ValueError):
        validate_path(Path("/nonexistent/path"), must_exist=True)
