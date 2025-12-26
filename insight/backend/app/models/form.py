"""Form and field models."""

import enum
from datetime import date, time

from sqlalchemy import (
    Column,
    String,
    Text,
    Boolean,
    Integer,
    Date,
    Time,
    Enum,
    ForeignKey,
    ARRAY,
)
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.orm import relationship

from app.models.base import BaseModel


class FormScheduleType(str, enum.Enum):
    """Form schedule types."""

    TAG_BASED = "tag_based"
    CUSTOM = "custom"
    MANUAL = "manual"


class FormStatus(str, enum.Enum):
    """Form statuses."""

    ACTIVE = "active"
    ARCHIVED = "archived"
    DRAFT = "draft"


class FieldType(str, enum.Enum):
    """Field types."""

    SHORT_TEXT = "short_text"
    LONG_TEXT = "long_text"
    EMAIL = "email"
    PHONE = "phone"
    DROPDOWN = "dropdown"
    RADIO = "radio"
    CHECKBOX = "checkbox"
    NUMBER = "number"
    DATE = "date"
    TIME = "time"
    FILE = "file"


class Form(BaseModel):
    """Form model."""

    __tablename__ = "forms"

    title = Column(String, nullable=False)
    description = Column(Text)
    tags = Column(ARRAY(String), default=[])
    is_template = Column(Boolean, default=False)
    schedule_type = Column(Enum(FormScheduleType), default=FormScheduleType.TAG_BASED)
    custom_start_date = Column(Date)
    custom_end_date = Column(Date)
    custom_time = Column(Time)
    max_submissions = Column(Integer)
    status = Column(Enum(FormStatus), default=FormStatus.DRAFT)
    created_by = Column(UUID(as_uuid=True), ForeignKey("team.id"))

    # Relationships
    sections = relationship(
        "FormSection", back_populates="form", cascade="all, delete-orphan"
    )
    fields = relationship("Field", back_populates="form", cascade="all, delete-orphan")
    submissions = relationship("Submission", back_populates="form")


class FormSection(BaseModel):
    """Form section model."""

    __tablename__ = "form_sections"

    form_id = Column(
        UUID(as_uuid=True), ForeignKey("forms.id", ondelete="CASCADE"), nullable=False
    )
    title = Column(String, nullable=False)
    description = Column(Text)
    order = Column(Integer, nullable=False)

    # Relationships
    form = relationship("Form", back_populates="sections")
    fields = relationship("Field", back_populates="section")


class FieldTemplate(BaseModel):
    """Field template model."""

    __tablename__ = "field_templates"

    name = Column(String, nullable=False)
    field_type = Column(Enum(FieldType), nullable=False)
    label = Column(String, nullable=False)
    placeholder = Column(String)
    help_text = Column(Text)
    is_required = Column(Boolean, default=False)
    validation_rules = Column(JSONB)
    default_value = Column(String)
    created_by = Column(UUID(as_uuid=True), ForeignKey("team.id"))


class Field(BaseModel):
    """Field model."""

    __tablename__ = "fields"

    form_id = Column(UUID(as_uuid=True), ForeignKey("forms.id", ondelete="CASCADE"))
    section_id = Column(
        UUID(as_uuid=True), ForeignKey("form_sections.id", ondelete="CASCADE")
    )
    field_type = Column(Enum(FieldType), nullable=False)
    label = Column(String, nullable=False)
    placeholder = Column(String)
    help_text = Column(Text)
    is_required = Column(Boolean, default=False)
    order = Column(Integer, nullable=False)
    validation_rules = Column(JSONB)
    default_value = Column(String)
    conditional_logic = Column(JSONB)
    template_id = Column(UUID(as_uuid=True), ForeignKey("field_templates.id"))

    # Relationships
    form = relationship("Form", back_populates="fields")
    section = relationship("FormSection", back_populates="fields")
    options = relationship(
        "DropdownOption", back_populates="field", cascade="all, delete-orphan"
    )


class DropdownOption(BaseModel):
    """Dropdown option model."""

    __tablename__ = "dropdown_options"

    field_id = Column(
        UUID(as_uuid=True), ForeignKey("fields.id", ondelete="CASCADE"), nullable=False
    )
    label = Column(String, nullable=False)
    value = Column(String, nullable=False)
    order = Column(Integer, nullable=False)

    # Relationships
    field = relationship("Field", back_populates="options")


class FormAssignment(BaseModel):
    """Form assignment model."""

    __tablename__ = "form_assignments"

    form_id = Column(
        UUID(as_uuid=True), ForeignKey("forms.id", ondelete="CASCADE"), nullable=False
    )
    assigned_to = Column(UUID(as_uuid=True), ForeignKey("team.id"))
    field_id = Column(UUID(as_uuid=True), ForeignKey("fields.id"))
