"""Goal and KPI endpoints."""

from datetime import date, datetime
from typing import List, Optional
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy.exc import IntegrityError

from app.api.deps import get_database
from app.models.calendar import Goal, KPIData, GoalType
from app.schemas.goal import (
    GoalCreate,
    GoalUpdate,
    Goal as GoalResponse,
    KpiDataCreate,
    KpiData as KpiDataResponse,
)

router = APIRouter(prefix="/goals", tags=["goals"])


@router.get("/", response_model=List[GoalResponse])
async def list_goals(
    type: Optional[str] = Query(None, description="Filter by goal type"),
    period_date: Optional[date] = Query(None, description="Filter by period date"),
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_database),
):
    """Get all goals with optional filters."""
    query = db.query(Goal)

    if type:
        try:
            goal_type = GoalType(type)
            query = query.filter(Goal.goal_type == goal_type)
        except ValueError:
            raise HTTPException(status_code=400, detail=f"Invalid goal type: {type}")

    if period_date:
        query = query.filter(Goal.period_date == period_date)

    return query.order_by(Goal.period_date.desc()).offset(skip).limit(limit).all()


@router.get("/{goal_id}", response_model=GoalResponse)
async def get_goal(goal_id: UUID, db: Session = Depends(get_database)):
    """Get a specific goal."""
    goal = db.query(Goal).filter(Goal.id == goal_id).first()
    if not goal:
        raise HTTPException(status_code=404, detail="Goal not found")
    return goal


@router.post("/", response_model=GoalResponse, status_code=201)
async def create_goal(
    goal: GoalCreate,
    db: Session = Depends(get_database),
):
    """Create a new goal."""
    db_goal = Goal(**goal.model_dump())
    db.add(db_goal)
    try:
        db.commit()
        db.refresh(db_goal)
    except IntegrityError as e:
        db.rollback()
        raise HTTPException(status_code=400, detail="Failed to create goal")
    return db_goal


@router.put("/{goal_id}", response_model=GoalResponse)
async def update_goal(
    goal_id: UUID,
    goal_update: GoalUpdate,
    db: Session = Depends(get_database),
):
    """Update a goal."""
    db_goal = db.query(Goal).filter(Goal.id == goal_id).first()
    if not db_goal:
        raise HTTPException(status_code=404, detail="Goal not found")

    # Update only provided fields
    update_data = goal_update.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_goal, field, value)

    try:
        db.commit()
        db.refresh(db_goal)
    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400, detail="Failed to update goal")
    return db_goal


@router.delete("/{goal_id}", status_code=204)
async def delete_goal(goal_id: UUID, db: Session = Depends(get_database)):
    """Delete a goal."""
    db_goal = db.query(Goal).filter(Goal.id == goal_id).first()
    if not db_goal:
        raise HTTPException(status_code=404, detail="Goal not found")

    db.delete(db_goal)
    db.commit()
    return None


# KPI Data endpoints
kpi_router = APIRouter(prefix="/kpi-data", tags=["kpi"])


@kpi_router.get("/latest", response_model=KpiDataResponse)
async def get_latest_kpi_data(db: Session = Depends(get_database)):
    """Get the most recent KPI data."""
    kpi_data = db.query(KPIData).order_by(KPIData.data_date.desc()).first()
    if not kpi_data:
        raise HTTPException(status_code=404, detail="No KPI data found")
    return kpi_data


@kpi_router.get("/", response_model=KpiDataResponse)
async def get_kpi_data_by_date(
    date: date = Query(..., description="Date to fetch KPI data for"),
    db: Session = Depends(get_database),
):
    """Get KPI data for a specific date."""
    kpi_data = db.query(KPIData).filter(KPIData.data_date == date).first()
    if not kpi_data:
        raise HTTPException(status_code=404, detail="KPI data not found for this date")
    return kpi_data


@kpi_router.get("/range", response_model=List[KpiDataResponse])
async def get_kpi_data_range(
    start_date: date = Query(..., description="Start date"),
    end_date: date = Query(..., description="End date"),
    db: Session = Depends(get_database),
):
    """Get KPI data for a date range."""
    if start_date > end_date:
        raise HTTPException(
            status_code=400, detail="Start date must be before end date"
        )

    kpi_data = (
        db.query(KPIData)
        .filter(KPIData.data_date >= start_date)
        .filter(KPIData.data_date <= end_date)
        .order_by(KPIData.data_date)
        .all()
    )
    return kpi_data


@kpi_router.post("/", response_model=KpiDataResponse)
async def upsert_kpi_data(
    kpi_data: KpiDataCreate,
    db: Session = Depends(get_database),
):
    """Create or update KPI data (upsert by data_date)."""
    # Check if KPI data exists for this date
    existing = db.query(KPIData).filter(KPIData.data_date == kpi_data.data_date).first()

    if existing:
        # Update existing record
        update_data = kpi_data.model_dump(exclude_unset=True)
        for field, value in update_data.items():
            if field != "data_date":  # Don't update the unique key
                setattr(existing, field, value)

        existing.updated_at = datetime.utcnow()
        db.commit()
        db.refresh(existing)
        return existing
    else:
        # Create new record
        db_kpi_data = KPIData(**kpi_data.model_dump())
        db.add(db_kpi_data)
        try:
            db.commit()
            db.refresh(db_kpi_data)
        except IntegrityError:
            db.rollback()
            raise HTTPException(status_code=400, detail="Failed to create KPI data")
        return db_kpi_data
