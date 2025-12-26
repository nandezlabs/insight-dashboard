"""Pydantic schemas for API requests/responses."""

from datetime import datetime
from typing import Optional
from uuid import UUID

from pydantic import BaseModel, ConfigDict


class BaseSchema(BaseModel):
    """Base schema with common configuration."""

    model_config = ConfigDict(from_attributes=True)


class TeamMemberBase(BaseSchema):
    """Team member base schema."""

    name: str
    role: str


class TeamMemberCreate(TeamMemberBase):
    """Team member creation schema."""

    pass


class TeamMemberUpdate(BaseSchema):
    """Team member update schema."""

    name: Optional[str] = None
    role: Optional[str] = None


class TeamMember(TeamMemberBase):
    """Team member response schema."""

    id: UUID
    created_at: datetime


class SyncPullRequest(BaseSchema):
    """Sync pull request schema."""

    device_id: str
    last_sync_timestamp: Optional[datetime] = None
    tables: list[str]  # List of table names to sync


class SyncPushRequest(BaseSchema):
    """Sync push request schema."""

    device_id: str
    changes: dict  # Dictionary of table_name -> list of changes
    timestamp: datetime


class SyncResponse(BaseSchema):
    """Sync response schema."""

    success: bool
    timestamp: datetime
    changes: dict  # Dictionary of table_name -> list of records
    conflicts: Optional[list] = None


class HealthResponse(BaseSchema):
    """Health check response."""

    status: str
    database: str
    version: str
