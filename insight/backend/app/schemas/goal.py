"""Goal and KPI schemas."""

from datetime import date, datetime
from typing import Optional
from uuid import UUID
from pydantic import BaseModel, Field
from enum import Enum


class GoalType(str, Enum):
    """Goal types enum."""

    SALES_WEEK = "sales_week"
    SALES_PERIOD = "sales_period"
    GEM_PERIOD = "gem_period"
    LABOR_PERCENTAGE = "labor_percentage"


class GoalBase(BaseModel):
    """Base goal schema."""

    goal_type: GoalType
    target_value: float = Field(..., gt=0)
    period_date: date


class GoalCreate(GoalBase):
    """Goal creation schema."""

    pass


class GoalUpdate(BaseModel):
    """Goal update schema."""

    goal_type: Optional[GoalType] = None
    target_value: Optional[float] = Field(None, gt=0)
    period_date: Optional[date] = None


class Goal(GoalBase):
    """Goal response schema."""

    id: UUID
    created_at: datetime

    class Config:
        from_attributes = True


class KpiDataBase(BaseModel):
    """Base KPI data schema."""

    data_date: date
    gem_score: Optional[float] = Field(None, ge=0, le=100)
    hours_scheduled: Optional[float] = Field(None, ge=0)
    hours_recommended: Optional[float] = Field(None, ge=0)
    labor_used_percentage: Optional[float] = Field(None, ge=0, le=200)
    sales_actual: Optional[float] = Field(None, ge=0)


class KpiDataCreate(KpiDataBase):
    """KPI data creation schema."""

    pass


class KpiData(KpiDataBase):
    """KPI data response schema."""

    id: UUID
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
