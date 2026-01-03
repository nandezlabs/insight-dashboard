"""Application configuration."""

import os
from typing import List

from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings."""

    # API
    API_VERSION: str = "v1"
    DEBUG: bool = False
    LOG_LEVEL: str = "INFO"
    SECRET_KEY: str

    # Database
    DATABASE_URL: str

    # CORS
    CORS_ORIGINS: str = "*"

    # Authentication
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days

    # File Upload
    MAX_UPLOAD_SIZE: int = 10485760  # 10MB
    UPLOAD_DIR: str = "/app/uploads"

    # Deployment Environment
    ENVIRONMENT: str = "development"  # development, staging, production

    class Config:
        """Pydantic config."""

        env_file = ".env"
        case_sensitive = True

    @property
    def cors_origins_list(self) -> List[str]:
        """Parse CORS origins from string to list."""
        if self.CORS_ORIGINS == "*":
            return ["*"]
        return [origin.strip() for origin in self.CORS_ORIGINS.split(",")]

    @property
    def is_production(self) -> bool:
        """Check if running in production."""
        return self.ENVIRONMENT == "production"

    @property
    def is_development(self) -> bool:
        """Check if running in development."""
        return self.ENVIRONMENT == "development"


# Initialize settings
settings = Settings()

# Production security checks
if settings.is_production:
    # Ensure DEBUG is false in production
    if settings.DEBUG:
        raise ValueError("DEBUG must be False in production environment")
    
    # Ensure CORS is not wildcard in production
    if settings.CORS_ORIGINS == "*":
        raise ValueError("CORS_ORIGINS must not be '*' in production environment")
    
    # Ensure SECRET_KEY is strong enough
    if len(settings.SECRET_KEY) < 32:
        raise ValueError("SECRET_KEY must be at least 32 characters in production")
