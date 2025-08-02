-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table for device-based authentication
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    device_id VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- WOOP entries table
CREATE TABLE woop_entries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    wish TEXT NOT NULL CHECK (char_length(wish) <= 280),
    outcome TEXT NOT NULL CHECK (char_length(outcome) <= 280),
    obstacle TEXT NOT NULL CHECK (char_length(obstacle) <= 280),
    plan TEXT NOT NULL CHECK (char_length(plan) <= 280),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Streaks table (renamed from timers for clarity)
CREATE TABLE streaks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    woop_id UUID NOT NULL REFERENCES woop_entries(id) ON DELETE CASCADE,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP WITH TIME ZONE,
    duration_seconds INTEGER,
    completed BOOLEAN DEFAULT FALSE,
    CONSTRAINT one_active_streak_per_user UNIQUE (user_id, ended_at)
);

-- Mood logs table (optional for future)
CREATE TABLE mood_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    streak_id UUID NOT NULL REFERENCES streaks(id) ON DELETE CASCADE,
    mood VARCHAR(50),
    trigger TEXT,
    location VARCHAR(255),
    note TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Settings table
CREATE TABLE settings (
    user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    mute BOOLEAN DEFAULT FALSE,
    reduce_motion BOOLEAN DEFAULT FALSE,
    language VARCHAR(10) DEFAULT 'en',
    notifications_enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_woop_entries_user_id ON woop_entries(user_id);
CREATE INDEX idx_streaks_user_id ON streaks(user_id);
CREATE INDEX idx_streaks_woop_id ON streaks(woop_id);
CREATE INDEX idx_mood_logs_streak_id ON mood_logs(streak_id);

-- Row Level Security (RLS)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE woop_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE mood_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;

-- RLS Policies (device-based, no auth required)
-- Users can only access their own data based on device_id
CREATE POLICY "Users can view own data" ON users
    FOR SELECT USING (device_id = current_setting('app.device_id', true));

CREATE POLICY "Users can insert own data" ON users
    FOR INSERT WITH CHECK (device_id = current_setting('app.device_id', true));

-- Similar policies for other tables
CREATE POLICY "Users can manage own woops" ON woop_entries
    FOR ALL USING (user_id IN (
        SELECT id FROM users WHERE device_id = current_setting('app.device_id', true)
    ));

CREATE POLICY "Users can manage own streaks" ON streaks
    FOR ALL USING (user_id IN (
        SELECT id FROM users WHERE device_id = current_setting('app.device_id', true)
    ));

CREATE POLICY "Users can manage own mood logs" ON mood_logs
    FOR ALL USING (streak_id IN (
        SELECT id FROM streaks WHERE user_id IN (
            SELECT id FROM users WHERE device_id = current_setting('app.device_id', true)
        )
    ));

CREATE POLICY "Users can manage own settings" ON settings
    FOR ALL USING (user_id IN (
        SELECT id FROM users WHERE device_id = current_setting('app.device_id', true)
    ));