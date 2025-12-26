"""Sync endpoints for bidirectional data synchronization."""

from datetime import datetime
from typing import List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.api.deps import get_database
from app.schemas import SyncPullRequest, SyncPushRequest, SyncResponse
from app.services.sync_service import SyncService

router = APIRouter(prefix="/sync", tags=["sync"])


@router.post("/pull", response_model=SyncResponse)
async def sync_pull(
    request: SyncPullRequest,
    db: Session = Depends(get_database),
):
    """
    Pull changes from server.

    Client sends:
    - device_id: Unique device identifier
    - last_sync_timestamp: Last successful sync time
    - tables: List of table names to sync

    Server responds with:
    - All records modified since last_sync_timestamp
    - Full snapshot if last_sync_timestamp is None
    """
    try:
        sync_service = SyncService(db)
        changes = sync_service.get_changes_since(
            last_sync=request.last_sync_timestamp,
            tables=request.tables,
        )

        return SyncResponse(
            success=True,
            timestamp=datetime.now(),
            changes=changes,
            conflicts=None,
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.post("/push", response_model=SyncResponse)
async def sync_push(
    request: SyncPushRequest,
    db: Session = Depends(get_database),
):
    """
    Push changes to server.

    Client sends:
    - device_id: Unique device identifier
    - changes: Dictionary of table_name -> list of records
    - timestamp: Client's current timestamp

    Server responds with:
    - Success status
    - Any conflicts that need resolution
    """
    try:
        sync_service = SyncService(db)
        result = sync_service.apply_changes(
            device_id=request.device_id,
            changes=request.changes,
            client_timestamp=request.timestamp,
        )

        return SyncResponse(
            success=result["success"],
            timestamp=datetime.now(),
            changes=result.get("applied", {}),
            conflicts=result.get("conflicts"),
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@router.get("/status")
async def sync_status(db: Session = Depends(get_database)):
    """Get sync status and server information."""
    sync_service = SyncService(db)
    return {
        "status": "online",
        "timestamp": datetime.now(),
        "version": "1.0.0",
        "tables": sync_service.get_syncable_tables(),
    }
