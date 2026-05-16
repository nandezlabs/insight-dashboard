"""
Submissions API endpoints
Handles form submissions and drafts
"""
from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any
from services.supabase_client import supabase
import logging
from datetime import datetime

router = APIRouter()
logger = logging.getLogger(__name__)


class SubmissionCreate(BaseModel):
    form_id: str = Field(..., description="Form template ID")
    data: Dict[str, Any] = Field(..., description="Form submission data")


class DraftSave(BaseModel):
    form_id: str = Field(..., description="Form template ID")
    data: Dict[str, Any] = Field(..., description="Form draft data")


@router.get("/submissions")
async def list_submissions(
    form_id: Optional[str] = Query(None),
    limit: int = Query(50, ge=1, le=100),
    offset: int = Query(0, ge=0)
):
    """
    List all submissions with optional filtering by form
    """
    try:
        query = supabase.table('submissions').select('*')
        
        if form_id:
            query = query.eq('form_id', form_id)
        
        query = query.order('created_at', desc=True).range(offset, offset + limit - 1)
        
        response = query.execute()
        
        return {
            "submissions": response.data,
            "count": len(response.data)
        }
    
    except Exception as e:
        logger.error(f"Error fetching submissions: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to fetch submissions")


@router.get("/submissions/{submission_id}")
async def get_submission(submission_id: str):
    """
    Get a specific submission by ID
    """
    try:
        response = supabase.table('submissions').select('*').eq('id', submission_id).execute()
        
        if not response.data:
            raise HTTPException(status_code=404, detail="Submission not found")
        
        return response.data[0]
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching submission {submission_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to fetch submission")


@router.post("/submissions", status_code=201)
async def create_submission(submission: SubmissionCreate):
    """
    Create a new form submission
    """
    try:
        # Get form template to capture version
        form_response = supabase.table('form_templates').select('version, status').eq('id', submission.form_id).execute()
        
        if not form_response.data:
            raise HTTPException(status_code=404, detail="Form template not found")
        
        form = form_response.data[0]
        
        if form['status'] != 'active':
            raise HTTPException(status_code=400, detail="Cannot submit to inactive form")
        
        # Create submission
        data = {
            "form_id": submission.form_id,
            "form_version": form['version'],
            "data": submission.data
        }
        
        response = supabase.table('submissions').insert(data).execute()
        
        if not response.data:
            raise HTTPException(status_code=500, detail="Failed to create submission")
        
        # Delete draft if exists
        try:
            supabase.table('form_drafts').delete().eq('form_id', submission.form_id).execute()
        except:
            pass  # Draft deletion is not critical
        
        return response.data[0]
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error creating submission: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to create submission")


@router.post("/drafts", status_code=201)
async def save_draft(draft: DraftSave):
    """
    Save or update a form draft (auto-save)
    """
    try:
        # Check if draft exists
        existing = supabase.table('form_drafts').select('id').eq('form_id', draft.form_id).execute()
        
        if existing.data:
            # Update existing draft
            response = supabase.table('form_drafts').update({
                'data': draft.data,
                'updated_at': datetime.utcnow().isoformat()
            }).eq('form_id', draft.form_id).execute()
        else:
            # Create new draft
            response = supabase.table('form_drafts').insert({
                'form_id': draft.form_id,
                'data': draft.data
            }).execute()
        
        if not response.data:
            raise HTTPException(status_code=500, detail="Failed to save draft")
        
        return response.data[0]
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error saving draft: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to save draft")


@router.get("/drafts/{form_id}")
async def get_draft(form_id: str):
    """
    Get saved draft for a form
    """
    try:
        response = supabase.table('form_drafts').select('*').eq('form_id', form_id).execute()
        
        if not response.data:
            return {"draft": None, "message": "No draft found"}
        
        return response.data[0]
    
    except Exception as e:
        logger.error(f"Error fetching draft for form {form_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to fetch draft")


@router.delete("/drafts/{form_id}")
async def delete_draft(form_id: str):
    """
    Delete a draft
    """
    try:
        response = supabase.table('form_drafts').delete().eq('form_id', form_id).execute()
        
        return {"message": "Draft deleted successfully", "form_id": form_id}
    
    except Exception as e:
        logger.error(f"Error deleting draft for form {form_id}: {str(e)}")
        raise HTTPException(status_code=500, detail="Failed to delete draft")
