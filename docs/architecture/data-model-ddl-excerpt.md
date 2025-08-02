# Data Model (DDL Excerpt)

TABLE users   id UUID PK, device_id TEXT UNIQUE NOT NULL, created_at TIMESTAMPTZ DEFAULT NOW()
TABLE woop_entries   id UUID PK, user_id FK→users, wish/outcome/obstacle/plan TEXT(≤280), created_at
TABLE streaks   id UUID PK, user_id FK→users, woop_id FK→woop_entries, duration_seconds INT, ended_at, completed BOOL
TABLE mood_logs   id UUID PK, streak_id FK→streaks, mood ENUM 😄🙂😐😕😢, trigger, location, note, created_at

Row-Level Security enabled on every table (policy: auth.uid() = user_id).
