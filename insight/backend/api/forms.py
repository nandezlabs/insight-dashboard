"""
Form Templates API endpoints
Handles CRUD operations for form templates
"""
from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel, Field
from typing import Optional, List
from services.supabase_client import supabase
import logging
from datetime import datetime

router = APIRouter()
logger = logging.getLogger(__name__)


class FormTemplateCreate(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    schema: dict = Field(..., description="FormIO.js schema JSON")
    status: str = Field(default="draft", pattern="^(draft|active|archived)$")


class FormTemplateUpdate(BaseModel):
    name: Optional[str] = Field(None, min_length=1, max_length=255)
    schema: Optional[dict] = None
    status: Optional[str] = Field(None, pattern="^(draft|active|archived)$")


@router.get("/forms")
async def list_forms(
    status: Optional[str] = Query(None, regex="^(draft|active|archived)$"),
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0)
):
    """
    List all form templates with optional filtering
    """
    try:
        query = supabase.table('form_templates').select('*')
        
        if status:
            query = query.eq('status', status)
        
        query = query.order('created_at', desc=True).range(offset, offset + limit - 1)
        
        response = query.execute()
        
        return {
            "forms": response.data,
            "count": len(response.data)
        }
    
    except Exception as e:
        logger.error(f"Error fetching forms: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to fetch forms")


@router.get("/forms/{form_id}")
async def get_form(form_id: str):
    """
    Get a specific form template by ID
    """
    try:
        response = supabase.table('form_templates').select('*').eq('id', form_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=404, detail="Form not found")
        
        return response.data[0]
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching form {form_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to fetch form")


@router.post("/forms", status_code=201)
async def create_form(form: FormTemplateCreate):
    """
    Create a new form template
    """
    try:
        data = {
            "name": form.name,
            "schema": form.schema,
            "status": form.status,
            "version": 1
        }
        
        response = supabase.table('form_templates').insert(data).execute()
        
        if not response.data:
            raise HTTPException(status_code=500, detail="Failed to create form")
        
        return response.data[0]
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating form: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to create form")


@router.put("/forms/{form_id}")
async def update_form(form_id: str, form: FormTemplateUpdate):
    """
    Update an existing form template
    Increments version if schema is changed
    """
    try:
        # Get current form
        current = supabase.table('form_templates').select('*').eq('id', form_id).execute()
        
        if not current.data:
            raise HTTPException(status_code=404, detail="Form not found")
        
        current_form = current.data[0]
        
        # Prepare update data
        update_data = {}
        if form.name is not None:
            update_data['name'] = form.name
        if form.status is not None:
            update_data['status'] = form.status
        if form.schema is not None:
            update_data['schema'] = form.schema
            # Increment version when schema changes
            update_data['version'] = current_form['version'] + 1
        
        if not update_data:
            raise HTTPException(status_code=400, detail="No fields to update")
        
        update_data['updated_at'] = datetime.utcnow().isoformat()
        
        response = supabase.table('form_templates').update(update_data).eq('id', form_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=500, detail="Failed to update form")
        
        return response.data[0]
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error updating form {form_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to update form")


@router.delete("/forms/{form_id}")
async def delete_form(form_id: str):
    """
    Delete a form template (soft delete by setting status to archived)
    """
    try:
        # Soft delete by archiving
        response = supabase.table('form_templates').update({
            'status': 'archived',
            'updated_at': datetime.utcnow().isoformat()
        }).eq('id', form_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=404, detail="Form not found")
        
        return {"message": "Form archived successfully", "id": form_id}
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error deleting form {form_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to delete form")


@router.get("/forms/{form_id}/stats")
async def get_form_stats(form_id: str):
    """
    Get statistics for a specific form
    """
    try:
        # Get submission count
        submissions = supabase.table('submissions').select('id', count='exact').eq('form_id', form_id).execute()
        
        # Get analytics events
        events = supabase.table('analytics_events').select('event_type', count='exact').eq('form_id', form_id).execute()
        
        # Calculate completion rate
        views = supabase.table('analytics_events').select('session_id', count='exact').eq('form_id', form_id).eq('event_type', 'view').execute()
        completions = supabase.table('analytics_events').select('session_id', count='exact').eq('form_id', form_id).eq('event_type', 'complete').execute()
        
        completion_rate = 0
        if views.count > 0:
            completion_rate = round((completions.count / views.count) * 100, 2)
        
        return {
            "form_id": form_id,
            "total_submissions": submissions.count,
            "total_views": views.count,
            "total_completions": completions.count,
            "completion_rate": completion_rate
        }
    
    except Exception as e:
        logger.error(f"Error fetching stats for form {form_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to fetch form statistics")
