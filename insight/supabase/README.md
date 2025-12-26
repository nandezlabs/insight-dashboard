# Supabase Setup Instructions

## 1. Create Your Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Click **New Project**
3. Fill in:
   - **Name**: `insight` (or your preferred name)
   - **Database Password**: Generate a strong password (save it!)
   - **Region**: Choose closest to your location
4. Click **Create new project**
5. Wait ~2 minutes for provisioning

## 2. Run the Database Schema

### Option A: Using VS Code Supabase Extension

1. Open Command Palette (`Cmd+Shift+P`)
2. Type "Supabase: Run SQL"
3. Select the `schema.sql` file
4. Execute

### Option B: Using Supabase Dashboard

1. Go to your project dashboard
2. Click **SQL Editor** in the left sidebar
3. Click **New query**
4. Copy the entire contents of `supabase/schema.sql`
5. Paste into the editor
6. Click **Run**

You should see: `Schema installed successfully!`

## 3. Get Your API Credentials

1. Go to **Project Settings** (gear icon in left sidebar)
2. Click **API** tab
3. Copy these values:

```
Project URL: https://xxxxx.supabase.co
anon public key: eyJhbGc...
```

## 4. Create Environment Files

You'll need these values when we create the apps next!

### For Store Manager App:

```env
SUPABASE_URL=your_project_url
SUPABASE_ANON_KEY=your_anon_key
WEATHER_API_KEY=your_openweather_api_key
```

### For Store App:

```env
SUPABASE_URL=your_project_url
SUPABASE_ANON_KEY=your_anon_key
WEATHER_API_KEY=your_openweather_api_key
```

## 5. Optional: Get Weather API Key

1. Go to [openweathermap.org](https://openweathermap.org/api)
2. Sign up for free account
3. Get your API key
4. Free tier allows 1000 calls/day (plenty for your use case)

## What's Created

The schema includes:

✅ **16 tables** for all app functionality
✅ **Indexes** for performance
✅ **Triggers** for auto-updating timestamps
✅ **Row Level Security** (RLS) enabled
✅ **Storage bucket** for file uploads
✅ **Seed data** (default calendar, timeframes, manager user)

## Verify Installation

After running the schema, you can verify in Supabase Dashboard:

1. Go to **Table Editor**
2. You should see all tables listed
3. Check `team` table - should have 1 manager user
4. Check `timeframe` table - should have 3 default timeframes
5. Check `business_calendar` table - should have 1 row

## Security Note

Since this is a single-user app with geofencing:

- No authentication system needed
- RLS policies allow all access (secured by geofencing in app)
- Data is encrypted in transit (HTTPS)
- Sensitive fields will be encrypted by the app

---

**Ready?** Once schema is installed, let me know and we'll create the Flutter apps!
