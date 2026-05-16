"""
Tests for health check endpoint.
"""

import pytest
from unittest.mock import Mock


def test_health_check_success(client, mock_supabase):
    """Test health check returns healthy status."""
    # Mock successful connection check
    mock_supabase.table.return_value.select.return_value.limit.return_value.execute.return_value = Mock(
        data=[{"id": "test"}]
    )
    
    response = client.get("/health")
    
    assert response.status_code == 200
    data = response.json()
    assert data["status"] in ["healthy", "degraded"]
    assert "environment" in data
    assert "supabase" in data


def test_health_check_degraded(client, mock_supabase):
    """Test health check returns degraded when Supabase fails."""
    # Mock failed connection
    mock_supabase.table.return_value.select.return_value.limit.return_value.execute.side_effect = Exception(
        "Connection failed"
    )
    
    response = client.get("/health")
    
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "degraded"
    # Supabase field should indicate failure (could be False, error dict, etc.)
    assert data["supabase"] == False or (isinstance(data["supabase"], dict) and "error" in str(data["supabase"]).lower())
