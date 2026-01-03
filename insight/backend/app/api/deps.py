"""API dependencies."""

from typing import Generator

from fastapi import Depends
from sqlalchemy.orm import Session

from app.database import get_db


def get_database() -> Generator[Session, None, None]:
    """Get database session dependency."""
    yield from get_db()
