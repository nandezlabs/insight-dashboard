from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import os
from dotenv import load_dotenv
import logging

# Load environment variables
load_dotenv()

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Create FastAPI app
app = FastAPI(
    title="Insight Dashboard API",
    description="Backend API for Insight Dashboard with Supabase integration",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",
        "https://yourdomain.com",
        os.getenv("APP_URL", "http://localhost:3000")
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Import routers
from api import health, forms, submissions, exports, analytics

# Register routers
app.include_router(health.router, tags=["health"])
app.include_router(forms.router, prefix="/api", tags=["forms"])
app.include_router(submissions.router, prefix="/api", tags=["submissions"])
app.include_router(exports.router, tags=["exports"])
app.include_router(analytics.router, tags=["analytics"])

@app.get("/")
async def root():
    """Root endpoint"""
    return {
        "message": "Insight Dashboard API",
        "version": "1.0.0",
        "docs": "/docs",
        "status": "running"
    }

# Health check moved to api/health.py router

@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    """Global HTTP exception handler"""
    logger.error(f"HTTP error: {exc.status_code} - {exc.detail}")
    return JSONResponse(
        status_code=exc.status_code,
        content={"error": exc.detail}
    )

@app.exception_handler(Exception)
async def general_exception_handler(request: Request, exc: Exception):
    """Global exception handler"""
    logger.error(f"Unhandled error: {str(exc)}", exc_info=True)
    return JSONResponse(
        status_code=500,
        content={"error": "Internal server error"}
    )

if __name__ == "__main__":
    import uvicorn
    port = int(os.getenv("PYTHON_API_PORT", 8000))
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=port,
        reload=True if os.getenv("PYTHON_ENV") == "development" else False
    )
