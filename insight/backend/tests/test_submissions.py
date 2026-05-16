"""
Tests for submissions API endpoints.
"""

import pytest
from unittest.mock import Mock


def test_list_submissions(client, mock_supabase, sample_submission):
    """Test GET /api/submissions returns paginated response."""
    mock_result = Mock()
    mock_result.data = [sample_submission]
    mock_result.count = 1
    mock_supabase.table.return_value.select.return_value.order.return_value.limit.return_value.range.return_value.execute.return_value = mock_result
    
    response = client.get("/api/submissions")
    
    assert response.status_code == 200
    data = response.json()
    assert "submissions" in data
    assert "count" in data


def test_get_submission_by_id(client, mock_supabase, sample_submission):
    """Test GET /api/submissions/{id} returns specific submission."""
    mock_result = Mock()
    mock_result.data = [sample_submission]  # API expects list
    mock_supabase.table.return_value.select.return_value.eq.return_value.execute.return_value = mock_result
    
    response = client.get(f"/api/submissions/{sample_submission['id']}")
    
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == sample_submission["id"]


def test_create_submission(client, mock_supabase, sample_form):
    """Test POST /api/submissions creates a new submission."""
    submission_data = {
        "form_id": sample_form["id"],
        "data": {
            "name": "Test User",
            "email": "test@example.com",
        },
    }
    
    # Mock form lookup to get version (must be active)
    active_form = {**sample_form, "status": "active"}
    mock_form_result = Mock()
    mock_form_result.data = [active_form]
    
    # Mock submission creation
    mock_submission = {
        **submission_data,
        "id": "new-submission-id",
        "form_version": 1,
        "created_at": "2026-05-16T12:00:00Z",
    }
    mock_submission_result = Mock()
    mock_submission_result.data = [mock_submission]
    
    # Mock draft deletion
    mock_delete_result = Mock()
    mock_delete_result.data = []
    
    # Setup the mock chain
    mock_supabase.table.return_value.select.return_value.eq.return_value.execute.return_value = mock_form_result
    mock_supabase.table.return_value.insert.return_value.execute.return_value = mock_submission_result
    mock_supabase.table.return_value.delete.return_value.eq.return_value.execute.return_value = mock_delete_result
    
    response = client.post("/api/submissions", json=submission_data)
    
    assert response.status_code == 200
    data = response.json()
    assert data["form_id"] == sample_form["id"]


def test_save_draft(client, mock_supabase):
    """Test POST /api/drafts saves a draft."""
    draft_data = {
        "form_id": "test-form-123",
        "data": {
            "name": "Draft Name",
        },
    }
    
    mock_draft = {
        **draft_data,
        "id": "draft-id",
        "updated_at": "2026-05-16T11:30:00Z",
    }
    
    mock_result = Mock()
    mock_result.data = [mock_draft]
    mock_supabase.table.return_value.upsert.return_value.execute.return_value = mock_result
    
    response = client.post("/api/drafts", json=draft_data)
    
    assert response.status_code == 201
    data = response.json()
    assert data["form_id"] == draft_data["form_id"]


def test_get_draft(client, mock_supabase, sample_draft):
    """Test GET /api/drafts/{form_id} returns draft."""
    mock_result = Mock()
    mock_result.data = [sample_draft]
    mock_supabase.table.return_value.select.return_value.eq.return_value.order.return_value.limit.return_value.execute.return_value = mock_result
    
    response = client.get(f"/api/drafts/{sample_draft['form_id']}")
    
    assert response.status_code == 200
    data = response.json()
    assert data["form_id"] == sample_draft["form_id"]


def test_delete_draft(client, mock_supabase):
    """Test DELETE /api/drafts/{form_id} deletes draft."""
    form_id = "test-form-123"
    
    mock_supabase.table.return_value.delete.return_value.eq.return_value.execute.return_value = Mock(
        data=[]
    )
    
    response = client.delete(f"/api/drafts/{form_id}")
    
    assert response.status_code == 200
    data = response.json()
    assert data["message"] == "Draft deleted successfully"
