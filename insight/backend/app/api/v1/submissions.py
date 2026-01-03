"""Submission endpoints."""

from typing import List, Optional
from uuid import UUID
from datetime import datetime

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.api.deps import get_database
from app.models.submission import Submission, SubmissionAnswer, SubmissionStatus
from app.schemas import (
    SubmissionCreate,
    SubmissionUpdate,
    SubmissionResponse,
    SubmissionAnswerCreate,
    SubmissionAnswerUpdate,
    SubmissionAnswerResponse,
)

router = APIRouter(prefix="/submissions", tags=["submissions"])


@router.get("/", response_model=List[SubmissionResponse])
async def list_submissions(
    skip: int = 0,
    limit: int = 100,
    status: Optional[SubmissionStatus] = None,
    db: Session = Depends(get_database),
):
    """Get all submissions."""
    query = db.query(Submission)

    if status:
        query = query.filter(Submission.status == status)

    return query.offset(skip).limit(limit).all()


@router.get("/{submission_id}", response_model=SubmissionResponse)
async def get_submission(submission_id: UUID, db: Session = Depends(get_database)):
    """Get a specific submission."""
    submission = db.query(Submission).filter(Submission.id == submission_id).first()
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")
    return submission


@router.get("/form/{form_id}", response_model=List[SubmissionResponse])
async def list_form_submissions(
    form_id: UUID,
    status: Optional[SubmissionStatus] = None,
    db: Session = Depends(get_database),
):
    """Get all submissions for a specific form."""
    query = db.query(Submission).filter(Submission.form_id == form_id)

    if status:
        query = query.filter(Submission.status == status)

    return query.all()


@router.get("/date-range/", response_model=List[SubmissionResponse])
async def list_submissions_by_date_range(
    start_date: str,
    end_date: str,
    db: Session = Depends(get_database),
):
    """Get submissions within a date range."""
    try:
        start = datetime.fromisoformat(start_date).date()
        end = datetime.fromisoformat(end_date).date()
    except ValueError:
        raise HTTPException(
            status_code=400, detail="Invalid date format. Use ISO format (YYYY-MM-DD)"
        )

    return (
        db.query(Submission)
        .filter(Submission.submission_date >= start, Submission.submission_date <= end)
        .all()
    )


@router.post("/", response_model=SubmissionResponse)
async def create_submission(
    submission: SubmissionCreate,
    db: Session = Depends(get_database),
):
    """Create a new submission."""
    db_submission = Submission(**submission.model_dump())
    db.add(db_submission)
    db.commit()
    db.refresh(db_submission)
    return db_submission


@router.put("/{submission_id}", response_model=SubmissionResponse)
async def update_submission(
    submission_id: UUID,
    submission: SubmissionUpdate,
    db: Session = Depends(get_database),
):
    """Update a submission."""
    db_submission = db.query(Submission).filter(Submission.id == submission_id).first()
    if not db_submission:
        raise HTTPException(status_code=404, detail="Submission not found")

    update_data = submission.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_submission, key, value)

    db.commit()
    db.refresh(db_submission)
    return db_submission


@router.delete("/{submission_id}")
async def delete_submission(submission_id: UUID, db: Session = Depends(get_database)):
    """Delete a submission."""
    db_submission = db.query(Submission).filter(Submission.id == submission_id).first()
    if not db_submission:
        raise HTTPException(status_code=404, detail="Submission not found")

    db.delete(db_submission)
    db.commit()
    return {"success": True, "message": "Submission deleted"}


# Answer endpoints
@router.get("/{submission_id}/answers", response_model=List[SubmissionAnswerResponse])
async def list_submission_answers(
    submission_id: UUID,
    db: Session = Depends(get_database),
):
    """Get all answers for a submission."""
    submission = db.query(Submission).filter(Submission.id == submission_id).first()
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")

    return (
        db.query(SubmissionAnswer)
        .filter(SubmissionAnswer.submission_id == submission_id)
        .all()
    )


@router.post("/{submission_id}/answers", response_model=SubmissionAnswerResponse)
async def save_answer(
    submission_id: UUID,
    answer: SubmissionAnswerCreate,
    db: Session = Depends(get_database),
):
    """Save or update an answer for a submission."""
    submission = db.query(Submission).filter(Submission.id == submission_id).first()
    if not submission:
        raise HTTPException(status_code=404, detail="Submission not found")

    # Check if answer already exists
    existing_answer = (
        db.query(SubmissionAnswer)
        .filter(
            SubmissionAnswer.submission_id == submission_id,
            SubmissionAnswer.field_id == answer.field_id,
        )
        .first()
    )

    if existing_answer:
        # Update existing answer
        for key, value in answer.model_dump(exclude_unset=True).items():
            setattr(existing_answer, key, value)
        existing_answer.answered_at = datetime.now()
        db.commit()
        db.refresh(existing_answer)
        return existing_answer
    else:
        # Create new answer
        db_answer = SubmissionAnswer(submission_id=submission_id, **answer.model_dump())
        db.add(db_answer)
        db.commit()
        db.refresh(db_answer)
        return db_answer
