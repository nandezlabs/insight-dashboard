"""Business calendar, goals, and KPI models."""

import enum
from datetime import date

from sqlalchemy import Column, Integer, Date, Numeric, Enum, UniqueConstraint
from sqlalchemy.dialects.postgresql import UUID

from app.models.base import BaseModel


class BusinessCalendar(BaseModel):
    """Business calendar model."""

    __tablename__ = "business_calendar"

    start_date = Column(Date, nullable=False)
    current_week = Column(Integer, nullable=False)
    current_period = Column(Integer, nullable=False)
    current_quarter = Column(Integer, nullable=False)


class GoalType(str, enum.Enum):
    """Goal types."""

    SALES_WEEK = "sales_week"
    SALES_PERIOD = "sales_period"
    GEM_PERIOD = "gem_period"
    LABOR_PERCENTAGE = "labor_percentage"


class Goal(BaseModel):
    """Goal model."""

    __tablename__ = "goals"

    goal_type = Column(Enum(GoalType), nullable=False)
    target_value = Column(Numeric(12, 2), nullable=False)
    period_date = Column(Date, nullable=False)


class KPIData(BaseModel):
    """KPI data model."""

    __tablename__ = "kpi_data"
    __table_args__ = (UniqueConstraint("data_date"),)

    data_date = Column(Date, nullable=False, unique=True)
    gem_score = Column(Numeric(5, 2))
    hours_scheduled = Column(Numeric(8, 2))
    hours_recommended = Column(Numeric(8, 2))
    labor_used_percentage = Column(Numeric(5, 2))
    sales_actual = Column(Numeric(12, 2))


class TeamSchedule(BaseModel):
    """Team schedule model."""

    __tablename__ = "team_schedule"

    schedule_date = Column(Date, nullable=False)
    employee_name = Column(Integer, nullable=False)
    shift_start = Column(Integer, nullable=False)
    shift_end = Column(Integer, nullable=False)
