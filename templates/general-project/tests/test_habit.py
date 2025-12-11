"""
Tests for note management
"""

import json
from datetime import datetime
from pathlib import Path

import pytest

from notes_manager.note import Note, NoteManager


def test_note_creation():
    """Test creating a note"""
    note = Note(title="Test Note", content="Test content", tags=["test", "example"])

    assert note.title == "Test Note"
    assert note.content == "Test content"
    assert "test" in note.tags
    assert note.id is not None


def test_note_to_dict():
    """Test converting note to dictionary"""
    note = Note(title="Test", content="Content")
    data = note.to_dict()

    assert data["title"] == "Test"
    assert data["content"] == "Content"
    assert "id" in data
    assert "created" in data


def test_note_from_dict():
    """Test creating note from dictionary"""
    data = {
        "id": "test123",
        "title": "Test",
        "content": "Content",
        "tags": ["tag1"],
        "category": "Work",
        "created": datetime.now().isoformat(),
        "modified": datetime.now().isoformat(),
    }

    note = Note.from_dict(data)

    assert note.id == "test123"
    assert note.title == "Test"
    assert note.category == "Work"


def test_note_manager_create(tmp_path):
    """Test creating a note with manager"""
    manager = NoteManager(tmp_path)

    note = manager.create_note(
        title="Test Note",
        content="Test content",
        tags=["test"],
        category="Personal",
    )

    assert note.file_path.exists()
    assert note.id is not None


def test_note_manager_get(tmp_path):
    """Test getting a note"""
    manager = NoteManager(tmp_path)

    created_note = manager.create_note(title="Test", content="Content")
    retrieved_note = manager.get_note(created_note.id)

    assert retrieved_note is not None
    assert retrieved_note.title == "Test"
    assert retrieved_note.content == "Content"


def test_note_manager_list(tmp_path):
    """Test listing notes"""
    manager = NoteManager(tmp_path)

    manager.create_note(title="Note 1", category="Work")
    manager.create_note(title="Note 2", category="Personal")
    manager.create_note(title="Note 3", category="Work")

    all_notes = manager.list_notes()
    assert len(all_notes) == 3

    work_notes = manager.list_notes(category="Work")
    assert len(work_notes) == 2


def test_note_manager_search(tmp_path):
    """Test searching notes"""
    manager = NoteManager(tmp_path)

    manager.create_note(title="Python Tutorial", content="Learn Python programming")
    manager.create_note(title="JavaScript Guide", content="Learn JS basics")
    manager.create_note(title="Python Advanced", content="Advanced Python concepts")

    results = manager.search_notes("Python")
    assert len(results) == 2


def test_note_manager_delete(tmp_path):
    """Test deleting a note"""
    manager = NoteManager(tmp_path)

    note = manager.create_note(title="To Delete")
    assert note.file_path.exists()

    success = manager.delete_note(note.id)
    assert success
    assert not note.file_path.exists()


def test_note_manager_export_markdown(tmp_path):
    """Test exporting notes to markdown"""
    manager = NoteManager(tmp_path)

    manager.create_note(title="Note 1", content="Content 1")
    manager.create_note(title="Note 2", content="Content 2")

    output_file = tmp_path / "export.md"
    success = manager.export_notes(output_file, format="markdown")

    assert success
    assert output_file.exists()

    content = output_file.read_text()
    assert "Note 1" in content
    assert "Note 2" in content


def test_note_manager_export_json(tmp_path):
    """Test exporting notes to JSON"""
    manager = NoteManager(tmp_path)

    manager.create_note(title="Note 1")
    manager.create_note(title="Note 2")

    output_file = tmp_path / "export.json"
    success = manager.export_notes(output_file, format="json")

    assert success
    assert output_file.exists()

    with open(output_file) as f:
        data = json.load(f)
    assert len(data) == 2
