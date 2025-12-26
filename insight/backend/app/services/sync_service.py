"""Sync service for bidirectional data synchronization."""

from datetime import datetime
from typing import Dict, List, Optional
from uuid import UUID

from sqlalchemy.orm import Session
from sqlalchemy import inspect

from app.models import (
    Form,
    FormSection,
    Field,
    DropdownOption,
    Submission,
    SubmissionAnswer,
    Team,
    Goal,
    KPIData,
    BusinessCalendar,
)


class SyncService:
    """Service for handling bidirectional sync between apps and server."""

    # Map table names to models
    SYNCABLE_MODELS = {
        "forms": Form,
        "form_sections": FormSection,
        "fields": Field,
        "dropdown_options": DropdownOption,
        "submissions": Submission,
        "submission_answers": SubmissionAnswer,
        "team": Team,
        "goals": Goal,
        "kpi_data": KPIData,
        "business_calendar": BusinessCalendar,
    }

    def __init__(self, db: Session):
        self.db = db

    def get_syncable_tables(self) -> List[str]:
        """Get list of syncable table names."""
        return list(self.SYNCABLE_MODELS.keys())

    def get_changes_since(
        self,
        last_sync: Optional[datetime],
        tables: List[str],
    ) -> Dict[str, List[dict]]:
        """
        Get all changes since last sync timestamp.

        Args:
            last_sync: Last successful sync datetime (None = full sync)
            tables: List of table names to sync

        Returns:
            Dictionary of table_name -> list of records
        """
        changes = {}

        for table_name in tables:
            if table_name not in self.SYNCABLE_MODELS:
                continue

            model = self.SYNCABLE_MODELS[table_name]
            query = self.db.query(model)

            # Filter by updated_at if last_sync provided
            if last_sync and hasattr(model, "updated_at"):
                query = query.filter(model.updated_at > last_sync)

            # Get records and convert to dict
            records = query.all()
            changes[table_name] = [self._model_to_dict(record) for record in records]

        return changes

    def apply_changes(
        self,
        device_id: str,
        changes: Dict[str, List[dict]],
        client_timestamp: datetime,
    ) -> Dict:
        """
        Apply changes from client to server.

        Args:
            device_id: Unique device identifier
            changes: Dictionary of table_name -> list of records
            client_timestamp: Client's timestamp

        Returns:
            Result dictionary with success status and any conflicts
        """
        applied = {}
        conflicts = []

        try:
            for table_name, records in changes.items():
                if table_name not in self.SYNCABLE_MODELS:
                    continue

                model = self.SYNCABLE_MODELS[table_name]
                applied_records = []

                for record_data in records:
                    try:
                        # Check if record exists
                        record_id = record_data.get("id")
                        existing = None

                        if record_id:
                            existing = (
                                self.db.query(model)
                                .filter(model.id == UUID(record_id))
                                .first()
                            )

                        if existing:
                            # Update existing record
                            # Check for conflicts (server version newer than client)
                            if (
                                hasattr(existing, "updated_at")
                                and existing.updated_at > client_timestamp
                            ):
                                conflicts.append(
                                    {
                                        "table": table_name,
                                        "record_id": str(record_id),
                                        "client_data": record_data,
                                        "server_data": self._model_to_dict(existing),
                                    }
                                )
                                continue

                            # Apply update
                            for key, value in record_data.items():
                                if key not in ["id", "created_at", "updated_at"]:
                                    setattr(existing, key, value)

                            applied_records.append(self._model_to_dict(existing))
                        else:
                            # Create new record
                            new_record = model(**record_data)
                            self.db.add(new_record)
                            self.db.flush()
                            applied_records.append(self._model_to_dict(new_record))

                    except Exception as e:
                        conflicts.append(
                            {
                                "table": table_name,
                                "record_id": record_data.get("id"),
                                "error": str(e),
                            }
                        )

                applied[table_name] = applied_records

            # Commit all changes
            self.db.commit()

            return {
                "success": True,
                "applied": applied,
                "conflicts": conflicts if conflicts else None,
            }

        except Exception as e:
            self.db.rollback()
            return {
                "success": False,
                "error": str(e),
                "conflicts": conflicts,
            }

    def _model_to_dict(self, model_instance) -> dict:
        """Convert SQLAlchemy model to dictionary."""
        result = {}
        for column in inspect(model_instance).mapper.column_attrs:
            value = getattr(model_instance, column.key)
            # Convert special types
            if isinstance(value, (datetime, UUID)):
                value = str(value)
            result[column.key] = value
        return result
