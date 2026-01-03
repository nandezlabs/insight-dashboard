"""Pydantic schemas for API requests/responses."""

from datetime import datetime, date, time
from typing import Optional, List, Any
from uuid import UUID

from pydantic import BaseModel, ConfigDict


class BaseSchema(BaseModel):
    """Base schema with common configuration."""

    model_config = ConfigDict(from_attributes=True)


# Goal and KPI schemas
from app.schemas.goal import (
    GoalType,
    GoalBase,
    GoalCreate,
    GoalUpdate,
    Goal,
    KpiDataBase,
    KpiDataCreate,
    KpiData,
)


# Team schemas
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


# Form schemas
class FormBase(BaseSchema):
    """Form base schema."""

    title: str
    description: Optional[str] = None
    tags: List[str] = []
    is_template: bool = False
    schedule_type: str = "tag_based"
    custom_start_date: Optional[date] = None
    custom_end_date: Optional[date] = None
    custom_time: Optional[time] = None
    max_submissions: Optional[int] = None
    status: str = "draft"


class FormCreate(FormBase):
    """Form creation schema."""

    created_by: Optional[UUID] = None


class FormUpdate(BaseSchema):
    """Form update schema."""

    title: Optional[str] = None
    description: Optional[str] = None
    tags: Optional[List[str]] = None
    is_template: Optional[bool] = None
    schedule_type: Optional[str] = None
    custom_start_date: Optional[date] = None
    custom_end_date: Optional[date] = None
    custom_time: Optional[time] = None
    max_submissions: Optional[int] = None
    status: Optional[str] = None


class FormResponse(FormBase):
    """Form response schema."""

    id: UUID
    created_by: Optional[UUID] = None
    created_at: datetime


# Field schemas
class FieldBase(BaseSchema):
    """Field base schema."""

    field_type: str
    label: str
    placeholder: Optional[str] = None
    help_text: Optional[str] = None
    is_required: bool = False
    order: int
    validation_rules: Optional[dict] = None
    default_value: Optional[str] = None


class FieldCreate(FieldBase):
    """Field creation schema."""

    section_id: Optional[UUID] = None


class FieldUpdate(BaseSchema):
    """Field update schema."""

    field_type: Optional[str] = None
    label: Optional[str] = None
    placeholder: Optional[str] = None
    help_text: Optional[str] = None
    is_required: Optional[bool] = None
    order: Optional[int] = None
    validation_rules: Optional[dict] = None
    default_value: Optional[str] = None


class FieldResponse(FieldBase):
    """Field response schema."""

    id: UUID
    form_id: UUID
    section_id: Optional[UUID] = None
    created_at: datetime


# Submission schemas
class SubmissionBase(BaseSchema):
    """Submission base schema."""

    form_id: UUID
    submitted_by: UUID
    submission_date: date
    status: str = "in_progress"
    completion_percentage: float = 0.0
    is_auto_submitted: bool = False


class SubmissionCreate(SubmissionBase):
    """Submission creation schema."""

    pass


class SubmissionUpdate(BaseSchema):
    """Submission update schema."""

    status: Optional[str] = None
    completion_percentage: Optional[float] = None
    is_auto_submitted: Optional[bool] = None


class SubmissionResponse(SubmissionBase):
    """Submission response schema."""

    id: UUID
    submission_time: datetime
    created_at: datetime


# Submission Answer schemas
class SubmissionAnswerBase(BaseSchema):
    """Submission answer base schema."""

    field_id: UUID
    answer_value: Optional[str] = None
    file_url: Optional[str] = None


class SubmissionAnswerCreate(SubmissionAnswerBase):
    """Submission answer creation schema."""

    pass


class SubmissionAnswerUpdate(BaseSchema):
    """Submission answer update schema."""

    answer_value: Optional[str] = None
    file_url: Optional[str] = None


class SubmissionAnswerResponse(SubmissionAnswerBase):
    """Submission answer response schema."""

    id: UUID
    submission_id: UUID
    answered_at: datetime


# User/Auth schemas
class UserBase(BaseSchema):
    """User base schema."""

    email: str
    full_name: str


class UserCreate(UserBase):
    """User creation schema."""

    password: str


class UserLogin(BaseSchema):
    """User login schema."""

    email: str
    password: str


class UserResponse(UserBase):
    """User response schema."""

    id: UUID
    is_active: bool
    is_superuser: bool
    team_member_id: Optional[UUID] = None
    created_at: datetime


class Token(BaseSchema):
    """Token response schema."""

    access_token: str
    token_type: str
    user: UserResponse


class TokenData(BaseSchema):
    """Token data schema."""

    email: str


# Sync schemas
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
