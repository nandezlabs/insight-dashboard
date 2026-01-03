-- Initialize the database with extensions if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create basic tables will be handled by Alembic migrations
-- This file is for any PostgreSQL-specific setup

-- Set timezone
SET timezone = 'UTC';
