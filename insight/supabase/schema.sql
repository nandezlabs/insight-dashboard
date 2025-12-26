-- Insight Database Schema for Supabase
-- Version 1.0.0
-- Run this in Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- ENUMS
-- ============================================

CREATE TYPE team_role AS ENUM ('manager', 'employee');
CREATE TYPE form_schedule_type AS ENUM ('tag_based', 'custom', 'manual');
CREATE TYPE form_status AS ENUM ('active', 'archived', 'draft');
CREATE TYPE field_type AS ENUM (
    'short_text', 'long_text', 'email', 'phone',
    'dropdown', 'radio', 'checkbox',
    'number', 'date', 'time', 'file'
);
CREATE TYPE submission_status AS ENUM ('in_progress', 'completed', 'auto_submitted');
CREATE TYPE goal_type AS ENUM ('sales_week', 'sales_period', 'gem_period', 'labor_percentage');
CREATE TYPE note_type AS ENUM ('callout', 'reminder', 'general');

-- ============================================
-- TABLES
-- ============================================

-- Team (no authentication, just roster)
CREATE TABLE team (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    role team_role NOT NULL DEFAULT 'employee',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Business Calendar
CREATE TABLE business_calendar (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    start_date DATE NOT NULL,
    current_week INTEGER NOT NULL CHECK (current_week BETWEEN 1 AND 4),
    current_period INTEGER NOT NULL CHECK (current_period BETWEEN 1 AND 13),
    current_quarter INTEGER NOT NULL CHECK (current_quarter BETWEEN 1 AND 4),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Timeframe (replaces business_hours)
CREATE TABLE timeframe (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tag TEXT NOT NULL UNIQUE,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    auto_submit_time TIME NOT NULL,
    is_default BOOLEAN DEFAULT FALSE
);

-- Geofence Settings
CREATE TABLE geofence_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    radius_meters INTEGER DEFAULT 100,
    enabled BOOLEAN DEFAULT TRUE,
    test_mode BOOLEAN DEFAULT FALSE
);

-- Forms
CREATE TABLE forms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    tags TEXT[] DEFAULT '{}',
    is_template BOOLEAN DEFAULT FALSE,
    schedule_type form_schedule_type DEFAULT 'tag_based',
    custom_start_date DATE,
    custom_end_date DATE,
    custom_time TIME,
    max_submissions INTEGER,
    status form_status DEFAULT 'draft',
    created_by UUID REFERENCES team(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Form Sections
CREATE TABLE form_sections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    form_id UUID NOT NULL REFERENCES forms(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    "order" INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Field Templates
CREATE TABLE field_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    field_type field_type NOT NULL,
    label TEXT NOT NULL,
    placeholder TEXT,
    help_text TEXT,
    is_required BOOLEAN DEFAULT FALSE,
    validation_rules JSONB,
    default_value TEXT,
    created_by UUID REFERENCES team(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Fields
CREATE TABLE fields (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    form_id UUID REFERENCES forms(id) ON DELETE CASCADE,
    section_id UUID REFERENCES form_sections(id) ON DELETE CASCADE,
    field_type field_type NOT NULL,
    label TEXT NOT NULL,
    placeholder TEXT,
    help_text TEXT,
    is_required BOOLEAN DEFAULT FALSE,
    "order" INTEGER NOT NULL,
    validation_rules JSONB,
    default_value TEXT,
    conditional_logic JSONB,
    template_id UUID REFERENCES field_templates(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Dropdown Options
CREATE TABLE dropdown_options (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    field_id UUID NOT NULL REFERENCES fields(id) ON DELETE CASCADE,
    label TEXT NOT NULL,
    value TEXT NOT NULL,
    "order" INTEGER NOT NULL
);

-- Form Assignments
CREATE TABLE form_assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    form_id UUID NOT NULL REFERENCES forms(id) ON DELETE CASCADE,
    assigned_to UUID REFERENCES team(id),
    field_id UUID REFERENCES fields(id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Submissions
CREATE TABLE submissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    form_id UUID NOT NULL REFERENCES forms(id),
    submitted_by UUID NOT NULL REFERENCES team(id),
    submission_date DATE NOT NULL DEFAULT CURRENT_DATE,
    submission_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    status submission_status DEFAULT 'in_progress',
    completion_percentage DECIMAL(5, 2) DEFAULT 0.0,
    is_auto_submitted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Submission Answers
CREATE TABLE submission_answers (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    submission_id UUID NOT NULL REFERENCES submissions(id) ON DELETE CASCADE,
    field_id UUID NOT NULL REFERENCES fields(id),
    answer_value TEXT,
    file_url TEXT,
    answered_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(submission_id, field_id)
);

-- Goals
CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    goal_type goal_type NOT NULL,
    target_value DECIMAL(12, 2) NOT NULL,
    period_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- KPI Data
CREATE TABLE kpi_data (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    data_date DATE NOT NULL UNIQUE,
    gem_score DECIMAL(5, 2),
    hours_scheduled DECIMAL(8, 2),
    hours_recommended DECIMAL(8, 2),
    labor_used_percentage DECIMAL(5, 2),
    sales_actual DECIMAL(12, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Team Schedule
CREATE TABLE team_schedule (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    schedule_date DATE NOT NULL,
    employee_name TEXT NOT NULL,
    shift_start TIME NOT NULL,
    shift_end TIME NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Manager Notes
CREATE TABLE manager_notes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    note_date DATE NOT NULL,
    note_type note_type DEFAULT 'general',
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================
-- INDEXES
-- ============================================

CREATE INDEX idx_forms_created_by ON forms(created_by);
CREATE INDEX idx_forms_status ON forms(status);
CREATE INDEX idx_forms_tags ON forms USING GIN(tags);
CREATE INDEX idx_fields_form_id ON fields(form_id);
CREATE INDEX idx_fields_section_id ON fields(section_id);
CREATE INDEX idx_submissions_form_id ON submissions(form_id);
CREATE INDEX idx_submissions_submitted_by ON submissions(submitted_by);
CREATE INDEX idx_submissions_date ON submissions(submission_date);
CREATE INDEX idx_submission_answers_submission_id ON submission_answers(submission_id);
CREATE INDEX idx_kpi_data_date ON kpi_data(data_date);
CREATE INDEX idx_team_schedule_date ON team_schedule(schedule_date);
CREATE INDEX idx_manager_notes_date ON manager_notes(note_date);

-- ============================================
-- FUNCTIONS & TRIGGERS
-- ============================================

-- Update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_forms_updated_at
    BEFORE UPDATE ON forms
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_submissions_updated_at
    BEFORE UPDATE ON submissions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_kpi_data_updated_at
    BEFORE UPDATE ON kpi_data
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_business_calendar_updated_at
    BEFORE UPDATE ON business_calendar
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- ============================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================

-- Enable RLS on all tables
ALTER TABLE team ENABLE ROW LEVEL SECURITY;
ALTER TABLE business_calendar ENABLE ROW LEVEL SECURITY;
ALTER TABLE timeframe ENABLE ROW LEVEL SECURITY;
ALTER TABLE geofence_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE forms ENABLE ROW LEVEL SECURITY;
ALTER TABLE form_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE field_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE fields ENABLE ROW LEVEL SECURITY;
ALTER TABLE dropdown_options ENABLE ROW LEVEL SECURITY;
ALTER TABLE form_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE submission_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE kpi_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_schedule ENABLE ROW LEVEL SECURITY;
ALTER TABLE manager_notes ENABLE ROW LEVEL SECURITY;

-- Create policies to allow access (since no authentication, allow all)
-- Note: In production, you might want to add API key validation or other security

CREATE POLICY "Allow all access" ON team FOR ALL USING (true);
CREATE POLICY "Allow all access" ON business_calendar FOR ALL USING (true);
CREATE POLICY "Allow all access" ON timeframe FOR ALL USING (true);
CREATE POLICY "Allow all access" ON geofence_settings FOR ALL USING (true);
CREATE POLICY "Allow all access" ON forms FOR ALL USING (true);
CREATE POLICY "Allow all access" ON form_sections FOR ALL USING (true);
CREATE POLICY "Allow all access" ON field_templates FOR ALL USING (true);
CREATE POLICY "Allow all access" ON fields FOR ALL USING (true);
CREATE POLICY "Allow all access" ON dropdown_options FOR ALL USING (true);
CREATE POLICY "Allow all access" ON form_assignments FOR ALL USING (true);
CREATE POLICY "Allow all access" ON submissions FOR ALL USING (true);
CREATE POLICY "Allow all access" ON submission_answers FOR ALL USING (true);
CREATE POLICY "Allow all access" ON goals FOR ALL USING (true);
CREATE POLICY "Allow all access" ON kpi_data FOR ALL USING (true);
CREATE POLICY "Allow all access" ON team_schedule FOR ALL USING (true);
CREATE POLICY "Allow all access" ON manager_notes FOR ALL USING (true);

-- ============================================
-- SEED DATA
-- ============================================

-- Insert default business calendar (starts today)
INSERT INTO business_calendar (start_date, current_week, current_period, current_quarter)
VALUES (CURRENT_DATE, 1, 1, 1);

-- Insert default timeframes
INSERT INTO timeframe (tag, start_time, end_time, auto_submit_time, is_default) VALUES
('daily', '08:00', '22:00', '22:00', true),
('weekly', '08:00', '22:00', '22:00', false),
('period', '08:00', '22:00', '22:00', false);

-- Insert default geofence settings (disabled by default, test mode on)
INSERT INTO geofence_settings (address, latitude, longitude, radius_meters, enabled, test_mode)
VALUES ('Your Business Address', 0.0, 0.0, 100, false, true);

-- Insert manager team member
INSERT INTO team (name, role)
VALUES ('Manager', 'manager');

-- ============================================
-- STORAGE BUCKETS (for file uploads)
-- ============================================

-- Note: Run this in Supabase Dashboard under Storage, or via SQL
-- This creates a bucket for form file uploads
INSERT INTO storage.buckets (id, name, public)
VALUES ('form-uploads', 'form-uploads', false)
ON CONFLICT (id) DO NOTHING;

-- Create policy for file uploads
CREATE POLICY "Allow all uploads" ON storage.objects
FOR ALL USING (bucket_id = 'form-uploads');

-- ============================================
-- COMPLETE!
-- ============================================

-- Verify installation
SELECT 'Schema installed successfully!' AS status;
SELECT COUNT(*) AS table_count FROM information_schema.tables WHERE table_schema = 'public';
