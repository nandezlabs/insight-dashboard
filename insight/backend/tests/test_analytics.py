"""
Tests for analytics API endpoints.
"""

import pytest
from unittest.mock import Mock, patch


def test_track_event(client, mock_supabase):
    """Test POST /api/analytics/track creates an event."""
    event_data = {
        "event_type": "view",
        "form_id": "test-form-123",
        "session_id": "session-123",
    }
    
    mock_event = {
        **event_data,
        "id": "event-id",
        "timestamp": "2026-05-16T10:00:00Z",
    }
    
    mock_supabase.table.return_value.insert.return_value.execute.return_value = Mock(
        data=[mock_event]
    )
    
    response = client.post("/api/analytics/track", json=event_data)
    
    assert response.status_code == 200
    data = response.json()
    assert data["success"] is True


def test_get_form_stats(client, mock_supabase):
    """Test GET /api/analytics/forms/{id}/stats returns stats."""
    form_id = "test-form-123"
    
    # Mock event counts with proper integer values
    mock_views = Mock()
    mock_views.data = []
    mock_views.count = 10
    
    mock_starts = Mock()
    mock_starts.data = []
    mock_starts.count = 8
    
    mock_completions = Mock()
    mock_completions.data = []
    mock_completions.count = 5
    
    # Setup mock to return different counts for different queries
    def mock_execute_with_count(*args, **kwargs):
        # This will be called for each count query
        return mock_views
    
    mock_chain = mock_supabase.table.return_value.select.return_value.eq.return_value
    mock_chain.execute.side_effect = [mock_views, mock_starts, mock_completions]
    
    response = client.get(f"/api/analytics/forms/{form_id}/stats")
    
    assert response.status_code == 200
    data = response.json()
    assert "views" in data
    assert "starts" in data
    assert "completions" in data
    assert "completion_rate" in data


def test_get_session_events(client, mock_supabase):
    """Test GET /api/analytics/sessions/{id} returns events."""
    session_id = "session-123"
    
    mock_events = [
        {
            "id": "event-1",
            "event_type": "view",
            "timestamp": "2026-05-16T10:00:00Z",
        },
        {
            "id": "event-2",
            "event_type": "start",
            "timestamp": "2026-05-16T10:01:00Z",
        },
    ]
    
    mock_supabase.table.return_value.select.return_value.eq.return_value.order.return_value.execute.return_value = Mock(
        data=mock_events
    )
    
    response = client.get(f"/api/analytics/sessions/{session_id}")
    
    assert response.status_code == 200
    data = response.json()
    assert data["session_id"] == session_id
    assert "events" in data


def test_get_abandoned_sessions(client, mock_supabase):
    """Test GET /api/analytics/abandoned returns abandoned sessions."""
    mock_starts = [
        {
            "session_id": "session-1",
            "form_id": "form-1",
            "timestamp": "2026-05-15T10:00:00Z",
        }
    ]
    
    # Mock start events
    mock_supabase.table.return_value.select.return_value.eq.return_value.lt.return_value.execute.return_value = Mock(
        data=mock_starts
    )
    
    # Mock complete events (none)
    mock_supabase.table.return_value.select.return_value.eq.return_value.limit.return_value.execute.return_value = Mock(
        data=[]
    )
    
    response = client.get("/api/analytics/abandoned?hours=24")
    
    assert response.status_code == 200
    data = response.json()
    assert "abandoned_count" in data
    assert "sessions" in data
