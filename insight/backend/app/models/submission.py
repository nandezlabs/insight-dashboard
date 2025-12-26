"""Submission models."""

import enum
from datetime import date, datetime

from sqlalchemy import (
    Column,
    String,
    Text,
    Boolean,
    Date,
    DateTime,
    Numeric,
    Enum,
    ForeignKey,
    UniqueConstraint,
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship

from app.models.base import BaseModel


class SubmissionStatus(str, enum.Enum):
    """Submission statuses."""

    IN_PROGRESS = "in_progress"
    COMPLETED = "completed"
    AUTO_SUBMITTED = "auto_submitted"


class Submission(BaseModel):
    """Submission model."""

    __tablename__ = "submissions"

    form_id = Column(UUID(as_uuid=True), ForeignKey("forms.id"), nullable=False)
    submitted_by = Column(UUID(as_uuid=True), ForeignKey("team.id"), nullable=False)
    submission_date = Column(Date, nullable=False, default=date.today)
    submission_time = Column(DateTime(timezone=True), default=datetime.now)
    status = Column(Enum(SubmissionStatus), default=SubmissionStatus.IN_PROGRESS)
    completion_percentage = Column(Numeric(5, 2), default=0.0)
    is_auto_submitted = Column(Boolean, default=False)

    # Relationships
    form = relationship("Form", back_populates="submissions")
    answers = relationship(
        "SubmissionAnswer", back_populates="submission", cascade="all, delete-orphan"
    )


class SubmissionAnswer(BaseModel):
    """Submission answer model."""

    __tablename__ = "submission_answers"
    __table_args__ = (UniqueConstraint("submission_id", "field_id"),)

    submission_id = Column(
        UUID(as_uuid=True),
        ForeignKey("submissions.id", ondelete="CASCADE"),
        nullable=False,
    )
    field_id = Column(UUID(as_uuid=True), ForeignKey("fields.id"), nullable=False)
    answer_value = Column(Text)
    file_url = Column(String)
    answered_at = Column(DateTime(timezone=True), default=datetime.now)

    # Relationships
    submission = relationship("Submission", back_populates="answers")
