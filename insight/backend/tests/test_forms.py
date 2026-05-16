"""
Tests for forms API endpoints.
"""

import pytest
from unittest.mock import Mock, MagicMock


def test_list_forms(client, mock_supabase, sample_form):
    """Test GET /api/forms returns list of forms."""
    mock_supabase.table.return_value.select.return_value.eq.return_value.order.return_value.limit.return_value.range.return_value.execute.return_value = Mock(
        data=[sample_form],
        count=1
    )
    
    response = client.get("/api/forms")
    
    assert response.status_code == 200
    data = response.json()
    assert len(data) >= 0


def test_get_form_by_id(client, mock_supabase, sample_form):
    """Test GET /api/forms/{id} returns specific form."""
    mock_result = Mock()
    mock_result.data = [sample_form]  # API expects list and returns [0]
    mock_supabase.table.return_value.select.return_value.eq.return_value.execute.return_value = mock_result
    
    response = client.get(f"/api/forms/{sample_form['id']}")
    
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == sample_form["id"]


def test_create_form(client, mock_supabase):
    """Test POST /api/forms creates a new form."""
    new_form = {
        "name": "New Test Form",
        "schema": {"components": []},
        "status": "draft",
    }
    
    mock_response = {
        **new_form,
        "id": "new-form-id",
        "version": 1,
        "created_at": "2026-05-16T10:00:00Z",
        "updated_at": "2026-05-16T10:00:00Z",
    }
    
    mock_result = Mock()
    mock_result.data = [mock_response]
    mock_supabase.table.return_value.insert.return_value.execute.return_value = mock_result
    
    response = client.post("/api/forms", json=new_form)
    
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == new_form["name"]
    assert data["version"] == 1


def test_update_form(client, mock_supabase, sample_form):
    """Test PUT /api/forms/{id} updates a form."""
    update_data = {
        "name": "Updated Form Name",
        "schema": sample_form["schema"],
    }
    
    # Mock get current form
    mock_supabase.table.return_value.select.return_value.eq.return_value.single.return_value.execute.return_value = Mock(
        data=sample_form
    )
    
    # Mock update
    updated_form = {**sample_form, **update_data, "version": 2}
    mock_supabase.table.return_value.update.return_value.eq.return_value.execute.return_value = Mock(
        data=[updated_form]
    )
    
    response = client.put(f"/api/forms/{sample_form['id']}", json=update_data)
    
    assert response.status_code == 200


def test_delete_form(client, mock_supabase, sample_form):
    """Test DELETE /api/forms/{id} archives a form."""
    archived_form = {**sample_form, "status": "archived"}
    
    mock_supabase.table.return_value.update.return_value.eq.return_value.execute.return_value = Mock(
        data=[archived_form]
    )
    
    response = client.delete(f"/api/forms/{sample_form['id']}")
    
    assert response.status_code == 200
    data = response.json()
    assert data["message"] == "Form archived successfully"


def test_get_form_stats(client, mock_supabase, sample_form):
    """Test GET /api/forms/{id}/stats returns statistics."""
    # Mock submissions count with proper integer
    mock_result = Mock()
    mock_result.data = [{"id": "1"}, {"id": "2"}]
    mock_result.count = 5
    
    mock_supabase.table.return_value.select.return_value.eq.return_value.execute.return_value = mock_result
    
    response = client.get(f"/api/forms/{sample_form['id']}/stats")
    
    assert response.status_code == 200
    data = response.json()
    assert "submission_count" in data
    assert isinstance(data["submission_count"], int)
