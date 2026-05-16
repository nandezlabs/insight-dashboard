"""
Pytest configuration and fixtures for testing.
"""

import os
import sys
from unittest.mock import Mock, MagicMock, patch

# MUST be first: Set environment variables before any imports
os.environ["NEXT_PUBLIC_SUPABASE_URL"] = "https://test.supabase.co"
os.environ["SUPABASE_SERVICE_ROLE_KEY"] = "test-key-123"
os.environ["ENVIRONMENT"] = "test"

# Add backend directory to path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# Create a persistent mock supabase instance that will be used for all tests
global_mock_supabase = MagicMock()

# Mock Supabase create_client before importing anything that uses it
with patch('supabase.create_client', return_value=global_mock_supabase):
    from main import app

import pytest
from fastapi.testclient import TestClient


@pytest.fixture
def client():
    """FastAPI test client."""
    return TestClient(app)


@pytest.fixture
def mock_supabase():
    """Mock Supabase client - returns the global mock and resets it for each test."""
    # Reset the mock for this test
    global_mock_supabase.reset_mock()
    
    # Patch it in the services module where it's used
    with patch("services.supabase_client.supabase", global_mock_supabase):
        yield global_mock_supabase


@pytest.fixture
def sample_form():
    """Sample form template data."""
    return {
        "id": "test-form-123",
        "name": "Test Form",
        "version": 1,
        "schema": {
            "components": [
                {
                    "type": "textfield",
                    "key": "name",
                    "label": "Name",
                    "input": True,
                }
            ]
        },
        "status": "active",
        "created_at": "2026-05-16T10:00:00Z",
        "updated_at": "2026-05-16T10:00:00Z",
    }


@pytest.fixture
def sample_submission():
    """Sample submission data."""
    return {
        "id": "test-submission-123",
        "form_id": "test-form-123",
        "form_version": 1,
        "data": {
            "name": "John Doe",
            "email": "john@example.com",
        },
        "created_at": "2026-05-16T11:00:00Z",
    }


@pytest.fixture
def sample_draft():
    """Sample draft data."""
    return {
        "id": "test-draft-123",
        "form_id": "test-form-123",
        "data": {
            "name": "Jane",
        },
        "updated_at": "2026-05-16T10:30:00Z",
    }
