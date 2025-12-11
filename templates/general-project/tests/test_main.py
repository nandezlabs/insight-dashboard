"""
Tests for main module
"""

import pytest
from pathlib import Path
from project_name.main import run_application


def test_run_application(tmp_path):
    """Test basic application run"""
    config = {"test": "value"}
    output_dir = tmp_path / "output"

    result = run_application(config, output_dir)

    assert result is True
    assert output_dir.exists()


def test_run_application_creates_output_dir(tmp_path):
    """Test that output directory is created"""
    output_dir = tmp_path / "test_output"
    assert not output_dir.exists()

    run_application({}, output_dir)

    assert output_dir.exists()
    assert output_dir.is_dir()
