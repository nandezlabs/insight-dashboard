"""
Analytics tracking service for form events.
"""

from datetime import datetime
from typing import Optional, Dict, Any
from uuid import uuid4

from services.supabase_client import supabase


class AnalyticsService:
    """Service for tracking user analytics events."""

    @staticmethod
    async def track_event(
        event_type: str,
        form_id: str,
        session_id: Optional[str] = None,
        user_id: Optional[str] = None,
        metadata: Optional[Dict[str, Any]] = None,
    ) -> Dict[str, Any]:
        """
        Track an analytics event.
        
        Args:
            event_type: Type of event (view, start, complete, abandon)
            form_id: ID of the form
            session_id: Optional session identifier
            user_id: Optional user identifier
            metadata: Optional additional data
            
        Returns:
            The created event record
        """
        event_data = {
            "id": str(uuid4()),
            "event_type": event_type,
            "form_id": form_id,
            "session_id": session_id or str(uuid4()),
            "user_id": user_id,
            "metadata": metadata or {},
            "timestamp": datetime.utcnow().isoformat(),
        }

        response = supabase.table("analytics_events").insert(event_data).execute()
        return response.data[0] if response.data else event_data

    @staticmethod
    async def get_form_stats(form_id: str) -> Dict[str, Any]:
        """
        Get analytics statistics for a specific form.
        
        Returns:
            Dictionary with views, starts, completions, and completion rate
        """
        # Get event counts
        views = (
            supabase.table("analytics_events")
            .select("id", count="exact")
            .eq("form_id", form_id)
            .eq("event_type", "view")
            .execute()
        )

        starts = (
            supabase.table("analytics_events")
            .select("id", count="exact")
            .eq("form_id", form_id)
            .eq("event_type", "start")
            .execute()
        )

        completions = (
            supabase.table("analytics_events")
            .select("id", count="exact")
            .eq("form_id", form_id)
            .eq("event_type", "complete")
            .execute()
        )

        views_count = views.count or 0
        starts_count = starts.count or 0
        completions_count = completions.count or 0

        # Calculate rates
        start_rate = (starts_count / views_count * 100) if views_count > 0 else 0
        completion_rate = (completions_count / starts_count * 100) if starts_count > 0 else 0

        return {
            "form_id": form_id,
            "views": views_count,
            "starts": starts_count,
            "completions": completions_count,
            "start_rate": round(start_rate, 2),
            "completion_rate": round(completion_rate, 2),
        }

    @staticmethod
    async def get_session_events(session_id: str) -> list:
        """
        Get all events for a specific session.
        
        Returns:
            List of events ordered by timestamp
        """
        response = (
            supabase.table("analytics_events")
            .select("*")
            .eq("session_id", session_id)
            .order("timestamp", desc=False)
            .execute()
        )

        return response.data or []

    @staticmethod
    async def calculate_completion_time(session_id: str) -> Optional[float]:
        """
        Calculate time taken to complete a form (in seconds).
        
        Returns:
            Time in seconds between start and complete events, or None
        """
        events = await AnalyticsService.get_session_events(session_id)

        start_event = next((e for e in events if e["event_type"] == "start"), None)
        complete_event = next((e for e in events if e["event_type"] == "complete"), None)

        if not start_event or not complete_event:
            return None

        start_time = datetime.fromisoformat(start_event["timestamp"].replace("Z", "+00:00"))
        complete_time = datetime.fromisoformat(complete_event["timestamp"].replace("Z", "+00:00"))

        return (complete_time - start_time).total_seconds()

    @staticmethod
    async def get_average_completion_time(form_id: str) -> Optional[float]:
        """
        Get average completion time for a form in minutes.
        
        Returns:
            Average time in minutes, or None if no data
        """
        # Get all completion events for the form
        completions = (
            supabase.table("analytics_events")
            .select("session_id")
            .eq("form_id", form_id)
            .eq("event_type", "complete")
            .execute()
        )

        if not completions.data:
            return None

        # Calculate completion time for each session
        times = []
        for event in completions.data:
            session_id = event["session_id"]
            time = await AnalyticsService.calculate_completion_time(session_id)
            if time:
                times.append(time)

        if not times:
            return None

        # Return average in minutes
        avg_seconds = sum(times) / len(times)
        return round(avg_seconds / 60, 1)

    @staticmethod
    async def detect_abandoned_sessions(hours: int = 24) -> list:
        """
        Detect sessions that started but didn't complete within X hours.
        
        Args:
            hours: Hours to consider as abandoned threshold
            
        Returns:
            List of abandoned session IDs with form info
        """
        # Get all start events
        cutoff_time = datetime.utcnow().timestamp() - (hours * 3600)
        cutoff_iso = datetime.fromtimestamp(cutoff_time).isoformat()

        starts = (
            supabase.table("analytics_events")
            .select("session_id, form_id, timestamp")
            .eq("event_type", "start")
            .lt("timestamp", cutoff_iso)
            .execute()
        )

        if not starts.data:
            return []

        # Check each session for completion
        abandoned = []
        for start_event in starts.data:
            session_id = start_event["session_id"]

            # Check if session has a complete event
            complete = (
                supabase.table("analytics_events")
                .select("id")
                .eq("session_id", session_id)
                .eq("event_type", "complete")
                .limit(1)
                .execute()
            )

            if not complete.data:
                abandoned.append({
                    "session_id": session_id,
                    "form_id": start_event["form_id"],
                    "started_at": start_event["timestamp"],
                })

        return abandoned
