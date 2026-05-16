# Environment Variables Reference

This document describes all environment variables used by the Insight Dashboard.

## 🔐 Critical Security Note

**NEVER commit `.env` files to version control!** Always use `.env.example` as a template and keep actual credentials in `.env` files that are gitignored.

## Required Variables

### Supabase Configuration

#### `NEXT_PUBLIC_SUPABASE_URL`

- **Type**: String (URL)
- **Required**: Yes
- **Example**: `https://xyzcompany.supabase.co`
- **Description**: Your Supabase project URL. Find this in Supabase project settings under "API".
- **Used By**: Frontend, Backend

#### `NEXT_PUBLIC_SUPABASE_ANON_KEY`

- **Type**: String (JWT)
- **Required**: Yes
- **Example**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
- **Description**: Supabase anonymous key for client-side requests. Safe to expose in frontend.
- **Used By**: Frontend

#### `SUPABASE_SERVICE_ROLE_KEY`

- **Type**: String (JWT)
- **Required**: Yes
- **Example**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
- **Description**: Supabase service role key with admin privileges. **Keep this secret!** Used for backend operations that bypass RLS.
- **Used By**: Backend only
- **Security**: Never expose to frontend or commit to git

### Email Configuration

Choose **one** email provider:

#### Option 1: Gmail SMTP

##### `SMTP_HOST`

- **Type**: String
- **Required**: If using Gmail
- **Example**: `smtp.gmail.com`
- **Description**: Gmail SMTP server hostname

##### `SMTP_PORT`

- **Type**: Integer
- **Required**: If using Gmail
- **Example**: `587`
- **Description**: Gmail SMTP port (use 587 for TLS)

##### `SMTP_USER`

- **Type**: String (email)
- **Required**: If using Gmail
- **Example**: `yourstore@gmail.com`
- **Description**: Your Gmail address

##### `SMTP_PASSWORD`

- **Type**: String
- **Required**: If using Gmail
- **Example**: `abcd efgh ijkl mnop`
- **Description**: Gmail App Password (NOT your regular password). Generate at: https://myaccount.google.com/apppasswords

##### `SMTP_FROM`

- **Type**: String (email)
- **Required**: If using Gmail
- **Example**: `yourstore@gmail.com`
- **Description**: Email address shown in "From" field

#### Option 2: SendGrid

##### `SENDGRID_API_KEY`

- **Type**: String
- **Required**: If using SendGrid
- **Example**: `SG.xxx-yyy-zzz`
- **Description**: SendGrid API key. Get from: https://app.sendgrid.com/settings/api_keys

##### `SENDGRID_FROM_EMAIL`

- **Type**: String (email)
- **Required**: If using SendGrid
- **Example**: `noreply@yourdomain.com`
- **Description**: Verified sender email in SendGrid

### Sentry Error Tracking

#### `NEXT_PUBLIC_SENTRY_DSN`

- **Type**: String (URL)
- **Required**: Recommended
- **Example**: `https://abc123@o123456.ingest.sentry.io/7890123`
- **Description**: Sentry Data Source Name for error tracking. Get from: Sentry project settings
- **Used By**: Frontend, Backend

#### `SENTRY_AUTH_TOKEN`

- **Type**: String
- **Required**: For CI/CD source maps
- **Example**: `sntrys_abc123def456`
- **Description**: Sentry authentication token for uploading source maps during build

## Optional Variables

### Application Configuration

#### `APP_NAME`

- **Type**: String
- **Required**: No
- **Default**: `Insight`
- **Example**: `MyStore Dashboard`
- **Description**: Application name shown in UI and emails

#### `APP_URL`

- **Type**: String (URL)
- **Required**: No (but recommended for production)
- **Default**: `http://localhost:3000`
- **Example**: `https://dashboard.mystore.com`
- **Description**: Public URL of your application. Used for email links and PWA manifest.

#### `NODE_ENV`

- **Type**: String enum
- **Required**: No
- **Default**: `development`
- **Options**: `development`, `production`, `test`
- **Description**: Node.js environment mode

### Backend Configuration

#### `PYTHON_API_PORT`

- **Type**: Integer
- **Required**: No
- **Default**: `8000`
- **Example**: `8001`
- **Description**: Port for Python FastAPI server

#### `PYTHON_ENV`

- **Type**: String enum
- **Required**: No
- **Default**: `development`
- **Options**: `development`, `production`, `staging`
- **Description**: Python environment mode

### Cache Configuration

#### `ENABLE_SQLITE_CACHE`

- **Type**: Boolean
- **Required**: No
- **Default**: `true`
- **Options**: `true`, `false`
- **Description**: Enable optional SQLite cache for offline capability and faster reads

#### `CACHE_RETENTION_DAYS`

- **Type**: Integer
- **Required**: No
- **Default**: `7`
- **Example**: `14`
- **Description**: Number of days to retain cached data before auto-cleanup

### Monitoring & Alerts

#### `ALERT_EMAIL`

- **Type**: String (email)
- **Required**: No
- **Default**: Same as `SMTP_FROM`
- **Example**: `admin@mystore.com`
- **Description**: Email address to receive system alerts and summaries

#### `WEEKLY_SUMMARY_EMAIL`

- **Type**: Boolean
- **Required**: No
- **Default**: `true`
- **Options**: `true`, `false`
- **Description**: Send weekly summary emails with form stats and system health

### Basic Authentication (Production)

#### `BASIC_AUTH_USER`

- **Type**: String
- **Required**: For production
- **Example**: `admin`
- **Description**: Username for Nginx basic authentication

#### `BASIC_AUTH_PASSWORD`

- **Type**: String
- **Required**: For production
- **Example**: `SuperSecure123!`
- **Description**: Password for Nginx basic authentication. Use strong password generator!

## Environment-Specific Configurations

### Development (.env.local)

```env
NODE_ENV=development
PYTHON_ENV=development
APP_URL=http://localhost:3000
ENABLE_SQLITE_CACHE=true
WEEKLY_SUMMARY_EMAIL=false
```

### Staging (.env.staging)

```env
NODE_ENV=production
PYTHON_ENV=staging
APP_URL=https://staging.yourdomain.com
ENABLE_SQLITE_CACHE=true
WEEKLY_SUMMARY_EMAIL=true
```

### Production (.env.production)

```env
NODE_ENV=production
PYTHON_ENV=production
APP_URL=https://yourdomain.com
ENABLE_SQLITE_CACHE=true
WEEKLY_SUMMARY_EMAIL=true
BASIC_AUTH_USER=admin
BASIC_AUTH_PASSWORD=<strong-password>
```

## Security Best Practices

1. **Rotate Credentials**: Change passwords and API keys every 90 days
2. **Least Privilege**: Use service role key only in backend, never frontend
3. **Strong Passwords**: Generate with password manager (20+ characters)
4. **Monitor Access**: Review Supabase logs monthly for suspicious activity
5. **Backup .env**: Store encrypted backup of production .env in secure location (1Password, LastPass, etc.)

## Getting Credentials

### Supabase

1. Go to https://supabase.com/dashboard
2. Select your project
3. Navigate to Settings → API
4. Copy `URL`, `anon public`, and `service_role` keys

### Gmail App Password

1. Enable 2FA on your Google account
2. Visit https://myaccount.google.com/apppasswords
3. Generate new app password for "Mail"
4. Copy 16-character password (format: `xxxx xxxx xxxx xxxx`)

### SendGrid

1. Sign up at https://sendgrid.com (100 emails/day free)
2. Verify sender email
3. Navigate to Settings → API Keys
4. Create new API key with "Mail Send" permissions

### Sentry

1. Sign up at https://sentry.io (5k errors/month free)
2. Create new project → Select "Next.js" and "Python"
3. Copy DSN from project settings
4. Generate auth token in User Settings → Auth Tokens

## Troubleshooting

### Supabase Connection Errors

- Verify URL and keys match Supabase dashboard
- Check if project is paused (free tier pauses after 7 days inactivity)
- Ensure Row Level Security policies allow access

### Email Not Sending

- **Gmail**: Verify App Password is correct (not regular password)
- **Gmail**: Check "Less secure app access" is enabled (if using old method)
- **SendGrid**: Verify sender email is verified
- **Both**: Check spam folder

### Sentry Not Logging

- Verify DSN is correct
- Check Sentry project is active
- Ensure error rate hasn't exceeded free tier (5k/month)

## Next Steps

After setting up environment variables:

1. ✅ Create `.env` file from `.env.example`
2. ✅ Fill in all required credentials
3. ✅ Test connections: `npm run test:env` (coming soon)
4. ✅ Deploy to VPS following [SETUP.md](SETUP.md)
