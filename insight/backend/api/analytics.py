"""
Analytics API endpoints for tracking and retrieving form analytics.
"""

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from typing import Optional, Dict, Any

from services.analytics import AnalyticsService

router = APIRouter(prefix="/api/analytics", tags=["analytics"])


class EventTrack(BaseModel):
    event_type: str  # view, start, complete, abandon
    form_id: str
    session_id: Optional[str] = None
    user_id: Optional[str] = None
    metadata: Optional[Dict[str, Any]] = None


@router.post("/track")
async def track_event(event: EventTrack):
    """
    Track an analytics event.
    
    Event types:
    - view: User viewed the form page
    - start: User started filling the form (first field interaction)
    - complete: User successfully submitted the form
    - abandon: User left without completing (tracked client-side)
    """
    try:
        result = await AnalyticsService.track_event(
            event_type=event.event_type,
            form_id=event.form_id,
            session_id=event.session_id,
            user_id=event.user_id,
            metadata=event.metadata,
        )

        return {
            "success": True,
            "event": result,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to track event: {str(e)}")


@router.get("/forms/{form_id}/stats")
async def get_form_stats(form_id: str):
    """
    Get analytics statistics for a specific form.
    
    Returns views, starts, completions, and conversion rates.
    """
    try:
        stats = await AnalyticsService.get_form_stats(form_id)

        # Get average completion time
        avg_time = await AnalyticsService.get_average_completion_time(form_id)
        stats["avg_completion_time_minutes"] = avg_time

        return stats

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to get stats: {str(e)}")


@router.get("/sessions/{session_id}")
async def get_session_events(session_id: str):
    """
    Get all events for a specific session.
    
    Useful for debugging and understanding user behavior.
    """
    try:
        events = await AnalyticsService.get_session_events(session_id)

        # Calculate completion time if completed
        completion_time = await AnalyticsService.calculate_completion_time(session_id)

        return {
            "session_id": session_id,
            "events": events,
            "completion_time_seconds": completion_time,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to get session: {str(e)}")


@router.get("/abandoned")
async def get_abandoned_sessions(hours: int = 24):
    """
    Get sessions that started but didn't complete within X hours.
    
    Useful for identifying drop-off points and following up with users.
    """
    try:
        abandoned = await AnalyticsService.detect_abandoned_sessions(hours=hours)

        return {
            "threshold_hours": hours,
            "abandoned_count": len(abandoned),
            "sessions": abandoned,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to get abandoned sessions: {str(e)}")
