-- Insight Dashboard Database Schema
-- Run this in Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Form Templates Table
CREATE TABLE IF NOT EXISTS form_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    version INTEGER DEFAULT 1 NOT NULL,
    schema JSONB NOT NULL,
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'archived')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index on status for filtering
CREATE INDEX idx_form_templates_status ON form_templates(status);
CREATE INDEX idx_form_templates_name ON form_templates(name);

-- Submissions Table
CREATE TABLE IF NOT EXISTS submissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    form_id UUID NOT NULL REFERENCES form_templates(id) ON DELETE CASCADE,
    form_version INTEGER NOT NULL,
    data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for submissions
CREATE INDEX idx_submissions_form_id ON submissions(form_id);
CREATE INDEX idx_submissions_created_at ON submissions(created_at DESC);
CREATE INDEX idx_submissions_data ON submissions USING GIN (data);

-- Form Drafts Table (auto-save)
CREATE TABLE IF NOT EXISTS form_drafts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    form_id UUID NOT NULL REFERENCES form_templates(id) ON DELETE CASCADE,
    data JSONB NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index on form_id for quick lookups
CREATE INDEX idx_form_drafts_form_id ON form_drafts(form_id);

-- Files Table
CREATE TABLE IF NOT EXISTS files (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    filename VARCHAR(255) NOT NULL,
    bucket_path TEXT NOT NULL,
    size BIGINT NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    submission_id UUID REFERENCES submissions(id) ON DELETE SET NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index on submission_id
CREATE INDEX idx_files_submission_id ON files(submission_id);

-- Analytics Events Table
CREATE TABLE IF NOT EXISTS analytics_events (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    form_id UUID NOT NULL REFERENCES form_templates(id) ON DELETE CASCADE,
    event_type VARCHAR(20) NOT NULL CHECK (event_type IN ('view', 'start', 'complete', 'abandon')),
    session_id VARCHAR(255) NOT NULL,
    field_name VARCHAR(255),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for analytics queries
CREATE INDEX idx_analytics_form_id ON analytics_events(form_id);
CREATE INDEX idx_analytics_event_type ON analytics_events(event_type);
CREATE INDEX idx_analytics_timestamp ON analytics_events(timestamp DESC);
CREATE INDEX idx_analytics_session_id ON analytics_events(session_id);

-- Alerts Table
CREATE TABLE IF NOT EXISTS alerts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    type VARCHAR(20) NOT NULL CHECK (type IN ('info', 'warning', 'error', 'success')),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE
);

-- Indexes for alerts
CREATE INDEX idx_alerts_is_read ON alerts(is_read);
CREATE INDEX idx_alerts_created_at ON alerts(created_at DESC);
CREATE INDEX idx_alerts_priority ON alerts(priority);

-- Error Logs Table
CREATE TABLE IF NOT EXISTS error_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    level VARCHAR(20) NOT NULL CHECK (level IN ('debug', 'info', 'warning', 'error', 'critical')),
    category VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    context JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for error logs
CREATE INDEX idx_error_logs_level ON error_logs(level);
CREATE INDEX idx_error_logs_category ON error_logs(category);
CREATE INDEX idx_error_logs_created_at ON error_logs(created_at DESC);

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_form_templates_updated_at
    BEFORE UPDATE ON form_templates
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_submissions_updated_at
    BEFORE UPDATE ON submissions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_form_drafts_updated_at
    BEFORE UPDATE ON form_drafts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS) Policies
-- For development, we'll create permissive policies
-- In production, you should restrict these based on authentication

ALTER TABLE form_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE form_drafts ENABLE ROW LEVEL SECURITY;
ALTER TABLE files ENABLE ROW LEVEL SECURITY;
ALTER TABLE analytics_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE error_logs ENABLE ROW LEVEL SECURITY;

-- Permissive policies for development (allow all operations)
-- Replace these with proper authentication-based policies in production

CREATE POLICY "Allow all operations on form_templates" ON form_templates FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on submissions" ON submissions FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on form_drafts" ON form_drafts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on files" ON files FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on analytics_events" ON analytics_events FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on alerts" ON alerts FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on error_logs" ON error_logs FOR ALL USING (true) WITH CHECK (true);

-- Insert sample form template for testing
INSERT INTO form_templates (name, version, schema, status)
VALUES (
    'Sample Inventory Form',
    1,
    '{"components": [{"type": "textfield", "key": "productName", "label": "Product Name", "placeholder": "Enter product name", "input": true, "validate": {"required": true}}, {"type": "number", "key": "quantity", "label": "Quantity", "placeholder": "Enter quantity", "input": true, "validate": {"required": true, "min": 0}}, {"type": "textarea", "key": "description", "label": "Description", "placeholder": "Enter description", "input": true}]}'::jsonb,
    'active'
) ON CONFLICT DO NOTHING;

-- Create a view for form completion statistics
CREATE OR REPLACE VIEW form_completion_stats AS
SELECT 
    f.id AS form_id,
    f.name AS form_name,
    COUNT(DISTINCT CASE WHEN ae.event_type = 'view' THEN ae.session_id END) AS views,
    COUNT(DISTINCT CASE WHEN ae.event_type = 'start' THEN ae.session_id END) AS starts,
    COUNT(DISTINCT CASE WHEN ae.event_type = 'complete' THEN ae.session_id END) AS completions,
    CASE 
        WHEN COUNT(DISTINCT CASE WHEN ae.event_type = 'start' THEN ae.session_id END) > 0
        THEN ROUND(
            (COUNT(DISTINCT CASE WHEN ae.event_type = 'complete' THEN ae.session_id END)::NUMERIC / 
             COUNT(DISTINCT CASE WHEN ae.event_type = 'start' THEN ae.session_id END)::NUMERIC) * 100, 
            2
        )
        ELSE 0
    END AS completion_rate
FROM form_templates f
LEFT JOIN analytics_events ae ON f.id = ae.form_id
WHERE f.status = 'active'
GROUP BY f.id, f.name;

COMMENT ON VIEW form_completion_stats IS 'Aggregated form completion statistics for analytics dashboard';

-- Grant permissions
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres, anon, authenticated, service_role;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public TO postgres, anon, authenticated, service_role;
