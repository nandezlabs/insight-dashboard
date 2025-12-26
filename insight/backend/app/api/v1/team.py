"""Team endpoints."""

from typing import List
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.api.deps import get_database
from app.models import Team
from app.schemas import TeamMember, TeamMemberCreate, TeamMemberUpdate

router = APIRouter(prefix="/team", tags=["team"])


@router.get("/", response_model=List[TeamMember])
async def list_team_members(db: Session = Depends(get_database)):
    """Get all team members."""
    return db.query(Team).all()


@router.get("/{member_id}", response_model=TeamMember)
async def get_team_member(member_id: UUID, db: Session = Depends(get_database)):
    """Get a specific team member."""
    member = db.query(Team).filter(Team.id == member_id).first()
    if not member:
        raise HTTPException(status_code=404, detail="Team member not found")
    return member


@router.post("/", response_model=TeamMember)
async def create_team_member(
    member: TeamMemberCreate,
    db: Session = Depends(get_database),
):
    """Create a new team member."""
    db_member = Team(**member.model_dump())
    db.add(db_member)
    db.commit()
    db.refresh(db_member)
    return db_member


@router.put("/{member_id}", response_model=TeamMember)
async def update_team_member(
    member_id: UUID,
    member: TeamMemberUpdate,
    db: Session = Depends(get_database),
):
    """Update a team member."""
    db_member = db.query(Team).filter(Team.id == member_id).first()
    if not db_member:
        raise HTTPException(status_code=404, detail="Team member not found")

    update_data = member.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_member, key, value)

    db.commit()
    db.refresh(db_member)
    return db_member


@router.delete("/{member_id}")
async def delete_team_member(member_id: UUID, db: Session = Depends(get_database)):
    """Delete a team member."""
    db_member = db.query(Team).filter(Team.id == member_id).first()
    if not db_member:
        raise HTTPException(status_code=404, detail="Team member not found")

    db.delete(db_member)
    db.commit()
    return {"success": True, "message": "Team member deleted"}
