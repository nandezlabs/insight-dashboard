"""Form endpoints."""

from typing import List
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.api.deps import get_database
from app.models.form import Form, Field
from app.schemas import (
    FormCreate,
    FormUpdate,
    FormResponse,
    FieldCreate,
    FieldUpdate,
    FieldResponse,
)

router = APIRouter(prefix="/forms", tags=["forms"])


@router.get("/", response_model=List[FormResponse])
async def list_forms(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_database),
):
    """Get all forms."""
    return db.query(Form).offset(skip).limit(limit).all()


@router.get("/{form_id}", response_model=FormResponse)
async def get_form(form_id: UUID, db: Session = Depends(get_database)):
    """Get a specific form."""
    form = db.query(Form).filter(Form.id == form_id).first()
    if not form:
        raise HTTPException(status_code=404, detail="Form not found")
    return form


@router.post("/", response_model=FormResponse)
async def create_form(
    form: FormCreate,
    db: Session = Depends(get_database),
):
    """Create a new form."""
    db_form = Form(**form.model_dump())
    db.add(db_form)
    db.commit()
    db.refresh(db_form)
    return db_form


@router.put("/{form_id}", response_model=FormResponse)
async def update_form(
    form_id: UUID,
    form: FormUpdate,
    db: Session = Depends(get_database),
):
    """Update a form."""
    db_form = db.query(Form).filter(Form.id == form_id).first()
    if not db_form:
        raise HTTPException(status_code=404, detail="Form not found")

    update_data = form.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_form, key, value)

    db.commit()
    db.refresh(db_form)
    return db_form


@router.delete("/{form_id}")
async def delete_form(form_id: UUID, db: Session = Depends(get_database)):
    """Delete a form."""
    db_form = db.query(Form).filter(Form.id == form_id).first()
    if not db_form:
        raise HTTPException(status_code=404, detail="Form not found")

    db.delete(db_form)
    db.commit()
    return {"success": True, "message": "Form deleted"}


# Field endpoints
@router.get("/{form_id}/fields", response_model=List[FieldResponse])
async def list_form_fields(
    form_id: UUID,
    db: Session = Depends(get_database),
):
    """Get all fields for a form."""
    form = db.query(Form).filter(Form.id == form_id).first()
    if not form:
        raise HTTPException(status_code=404, detail="Form not found")

    return db.query(Field).filter(Field.form_id == form_id).order_by(Field.order).all()


@router.post("/{form_id}/fields", response_model=FieldResponse)
async def create_field(
    form_id: UUID,
    field: FieldCreate,
    db: Session = Depends(get_database),
):
    """Create a new field for a form."""
    form = db.query(Form).filter(Form.id == form_id).first()
    if not form:
        raise HTTPException(status_code=404, detail="Form not found")

    db_field = Field(form_id=form_id, **field.model_dump())
    db.add(db_field)
    db.commit()
    db.refresh(db_field)
    return db_field


@router.put("/fields/{field_id}", response_model=FieldResponse)
async def update_field(
    field_id: UUID,
    field: FieldUpdate,
    db: Session = Depends(get_database),
):
    """Update a field."""
    db_field = db.query(Field).filter(Field.id == field_id).first()
    if not db_field:
        raise HTTPException(status_code=404, detail="Field not found")

    update_data = field.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_field, key, value)

    db.commit()
    db.refresh(db_field)
    return db_field


@router.delete("/fields/{field_id}")
async def delete_field(field_id: UUID, db: Session = Depends(get_database)):
    """Delete a field."""
    db_field = db.query(Field).filter(Field.id == field_id).first()
    if not db_field:
        raise HTTPException(status_code=404, detail="Field not found")

    db.delete(db_field)
    db.commit()
    return {"success": True, "message": "Field deleted"}
