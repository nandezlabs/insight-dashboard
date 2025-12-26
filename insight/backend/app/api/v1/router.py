"""API v1 router."""

from fastapi import APIRouter

from app.api.v1 import sync, team

api_router = APIRouter()

# Include sub-routers
api_router.include_router(sync.router)
api_router.include_router(team.router)
