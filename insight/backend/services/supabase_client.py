"""
Supabase client configuration and utilities
"""
import os
from typing import Optional
from supabase import create_client, Client
from dotenv import load_dotenv
import logging

load_dotenv()
logger = logging.getLogger(__name__)

# Supabase configuration
SUPABASE_URL = os.getenv("NEXT_PUBLIC_SUPABASE_URL")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

if not SUPABASE_URL or not SUPABASE_SERVICE_KEY:
    raise ValueError("Missing Supabase environment variables")

# Create Supabase client
supabase: Client = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

async def check_connection() -> bool:
    """Check if Supabase connection is working"""
    try:
        response = supabase.table('form_templates').select("id").limit(1).execute()
        return True
    except Exception as e:
        logger.error(f"Supabase connection error: {str(e)}")
        return False

def get_supabase_client() -> Client:
    """Get Supabase client instance"""
    return supabase
