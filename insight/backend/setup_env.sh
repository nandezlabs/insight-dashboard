#!/bin/bash
# Supabase Environment Setup Helper
# Run this script to configure your .env file

echo "🚀 Insight Dashboard - Supabase Setup"
echo "======================================"
echo ""
echo "📍 Step 1: Go to your Supabase Dashboard"
echo "   https://app.supabase.com/project/bsycanduonujppxajhwi/settings/api"
echo ""
echo "📝 Step 2: Copy your credentials:"
echo "   - Project URL (looks like: https://xxx.supabase.co)"
echo "   - service_role key (long JWT token starting with eyJ...)"
echo ""
echo "⚙️  Step 3: Enter your credentials below"
echo ""

# Prompt for Supabase URL
read -p "Enter your Supabase Project URL: " SUPABASE_URL

# Prompt for Service Role Key
read -sp "Enter your Supabase service_role key: " SERVICE_KEY
echo ""

# Validate inputs
if [ -z "$SUPABASE_URL" ] || [ -z "$SERVICE_KEY" ]; then
    echo "❌ Error: Both URL and key are required!"
    exit 1
fi

# Update .env file
cat > .env << EOF
# Supabase Configuration
NEXT_PUBLIC_SUPABASE_URL=$SUPABASE_URL
SUPABASE_SERVICE_ROLE_KEY=$SERVICE_KEY

# Application Settings
PYTHON_ENV=development
APP_URL=http://localhost:3000

# Email Configuration (Optional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASSWORD=your-app-password
SMTP_FROM=noreply@yourdomain.com

# SendGrid (Alternative to SMTP)
SENDGRID_API_KEY=your-sendgrid-api-key

# Monitoring (Optional)
SENTRY_DSN=your-sentry-dsn
EOF

echo ""
echo "✅ Environment file updated successfully!"
echo ""
echo "📋 Next steps:"
echo "   1. Run the database schema in Supabase SQL Editor"
echo "   2. Test the backend: cd backend && source venv/bin/activate && uvicorn main:app --reload"
echo "   3. Visit http://localhost:8000/docs to test the API"
echo ""
