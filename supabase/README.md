# Supabase Setup Guide

## Prerequisites

1. Create a Supabase account at https://supabase.com
2. Create a new project
3. Wait for the project to be provisioned

## Configuration Steps

### 1. Get Your Credentials

1. Go to your Supabase project dashboard
2. Navigate to Settings > API
3. Copy the following values:
   - Project URL (looks like: https://xxxxx.supabase.co)
   - Anon Public Key (safe to expose in frontend)

### 2. Set Environment Variables

1. Copy `.env.local.example` to `.env.local`:
   ```bash
   cp .env.local.example .env.local
   ```

2. Edit `.env.local` and add your credentials:
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
   ```

### 3. Run Database Migrations

Option A: Using Supabase Dashboard
1. Go to SQL Editor in your Supabase dashboard
2. Copy the contents of `supabase/migrations/001_initial_schema.sql`
3. Run the SQL

Option B: Using Supabase CLI
1. Install Supabase CLI: https://supabase.com/docs/guides/cli
2. Login to Supabase:
   ```bash
   npx supabase login
   ```
3. Link your project:
   ```bash
   npx supabase link --project-ref your-project-ref
   ```
4. Run migrations:
   ```bash
   npx supabase db push
   ```

## Database Schema

The following tables are created:

- **users**: Device-based user accounts
- **woop_entries**: WOOP (Wish, Outcome, Obstacle, Plan) entries
- **streaks**: Timer/streak tracking
- **mood_logs**: Optional mood tracking (future feature)
- **settings**: User preferences

## Row Level Security (RLS)

RLS is enabled on all tables to ensure users can only access their own data based on their device ID.

## Testing the Connection

Run the development server and check the console for any connection errors:

```bash
npm run dev
```

If you see "Missing Supabase environment variables" error, ensure your `.env.local` file is properly configured.

## Troubleshooting

1. **Connection Refused**: Check that your Supabase project is active and not paused
2. **Invalid API Key**: Verify you copied the correct Anon Public key
3. **RLS Errors**: The RLS policies expect a device_id to be set in the connection context