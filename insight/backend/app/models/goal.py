"""Goal and KPI models."""

import enum
from datetime import date

from sqlalchemy import Column, String, Numeric, Date, Enum, CheckConstraint
from sqlalchemy.dialects.postgresql import UUID

from app.models.base import BaseModel


class GoalType(str, enum.Enum):
    """Goal types."""

    SALES_WEEK = "sales_week"
    SALES_PERIOD = "sales_period"
    GEM_PERIOD = "gem_period"
    LABOR_PERCENTAGE = "labor_percentage"


class Goal(BaseModel):
    """Goal model."""

    __tablename__ = "goals"

    goal_type = Column(
        Enum(GoalType),
        nullable=False,
        index=True,
    )
    target_value = Column(Numeric(10, 2), nullable=False)
    period_date = Column(Date, nullable=False, index=True)

    __table_args__ = (
        CheckConstraint(
            "goal_type IN ('sales_week', 'sales_period', 'gem_period', 'labor_percentage')",
            name="goal_type_check",
        ),
    )


class KpiData(BaseModel):
    """KPI data model."""

    __tablename__ = "kpi_data"

    data_date = Column(Date, nullable=False, unique=True, index=True)
    gem_score = Column(Numeric(5, 2), nullable=True)
    hours_scheduled = Column(Numeric(10, 2), nullable=True)
    hours_recommended = Column(Numeric(10, 2), nullable=True)
    labor_used_percentage = Column(Numeric(5, 2), nullable=True)
    sales_actual = Column(Numeric(10, 2), nullable=True)
