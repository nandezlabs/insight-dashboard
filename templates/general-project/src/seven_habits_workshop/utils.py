"""
Utility functions and helpers
"""

import json
import logging
from pathlib import Path
from typing import Any, Dict


# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)

logger = logging.getLogger("project_name")


def load_config(config_path: Path) -> Dict[str, Any]:
    """
    Load configuration from JSON file

    Args:
        config_path: Path to configuration file

    Returns:
        Configuration dictionary
    """
    if not config_path.exists():
        raise FileNotFoundError(f"Configuration file not found: {config_path}")

    with open(config_path, "r") as f:
        config = json.load(f)

    logger.debug(f"Loaded configuration from {config_path}")
    return config


def save_config(config: Dict[str, Any], config_path: Path) -> None:
    """
    Save configuration to JSON file

    Args:
        config: Configuration dictionary
        config_path: Path to save configuration
    """
    config_path.parent.mkdir(parents=True, exist_ok=True)

    with open(config_path, "w") as f:
        json.dump(config, f, indent=2)

    logger.debug(f"Saved configuration to {config_path}")


def format_size(bytes_size: int) -> str:
    """
    Format bytes to human-readable size

    Args:
        bytes_size: Size in bytes

    Returns:
        Formatted size string
    """
    for unit in ["B", "KB", "MB", "GB", "TB"]:
        if bytes_size < 1024.0:
            return f"{bytes_size:.2f} {unit}"
        bytes_size /= 1024.0
    return f"{bytes_size:.2f} PB"


def validate_path(path: Path, must_exist: bool = False) -> Path:
    """
    Validate and resolve a path

    Args:
        path: Path to validate
        must_exist: Whether path must exist

    Returns:
        Resolved path

    Raises:
        ValueError: If validation fails
    """
    resolved = path.resolve()

    if must_exist and not resolved.exists():
        raise ValueError(f"Path does not exist: {path}")

    return resolved
