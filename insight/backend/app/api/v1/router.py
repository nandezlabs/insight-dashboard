"""API v1 router."""

from fastapi import APIRouter

from app.api.v1 import sync, team, forms, submissions, auth, files, goals

api_router = APIRouter()

# Include sub-routers
api_router.include_router(auth.router)
api_router.include_router(sync.router)
api_router.include_router(team.router)
api_router.include_router(forms.router)
api_router.include_router(submissions.router)
api_router.include_router(files.router, prefix="/files", tags=["files"])
api_router.include_router(goals.router)
api_router.include_router(goals.kpi_router)
