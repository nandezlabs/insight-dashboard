"""
Health check API endpoint
"""
from fastapi import APIRouter, HTTPException
from services.supabase_client import check_connection, supabase
import os
import logging

router = APIRouter()
logger = logging.getLogger(__name__)


@router.get("/health")
async def health_check():
    """
    Comprehensive health check endpoint
    Returns system status and Supabase connection status
    """
    try:
        # Check Supabase connection
        supabase_connected = await check_connection()
        
        # Get table counts for verification
        table_counts = {}
        if supabase_connected:
            try:
                tables = ['form_templates', 'submissions', 'form_drafts', 'alerts']
                for table in tables:
                    result = supabase.table(table).select('id', count='exact').limit(0).execute()
                    table_counts[table] = result.count
            except Exception as e:
                logger.warning(f"Could not fetch table counts: {str(e)}")
        
        # Overall health status
        status = "healthy" if supabase_connected else "degraded"
        
        return {
            "status": status,
            "environment": os.getenv("PYTHON_ENV", "development"),
            "supabase": {
                "connected": supabase_connected,
                "tables": table_counts if table_counts else "unavailable"
            },
            "api_version": "1.0.0"
        }
    
    except Exception as e:
        logger.error(f"Health check failed: {str(e)}")
        raise HTTPException(status_code=503, detail="Service unhealthy")
