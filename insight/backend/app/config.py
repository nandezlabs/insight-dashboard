"""Application configuration."""

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

    # File Upload
    MAX_UPLOAD_SIZE: int = 10485760  # 10MB
    UPLOAD_DIR: str = "/app/uploads"

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


settings = Settings()
