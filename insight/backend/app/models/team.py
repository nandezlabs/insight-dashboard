"""Team member models."""

import enum

from sqlalchemy import Column, String, Enum

from app.models.base import BaseModel


class TeamRole(str, enum.Enum):
    """Team member roles."""

    MANAGER = "manager"
    EMPLOYEE = "employee"


class Team(BaseModel):
    """Team member model."""

    __tablename__ = "team"

    name = Column(String, nullable=False)
    role = Column(Enum(TeamRole), nullable=False, default=TeamRole.EMPLOYEE)
