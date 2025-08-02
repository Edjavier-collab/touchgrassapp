# Data Model (Supabase)

| Table | Key Fields |
|-------|------------|
| `users` | `id` (UUID), `device_id`, `created_at` |
| `woop_entries` | `id`, `user_id`, `wish`, `outcome`, `obstacle`, `plan`, `created_at` |
| `streaks` | `id`, `user_id`, `woop_id`, `duration_seconds`, `ended_at`, `completed` (bool) |
| `mood_logs` | `id`, `streak_id`, `mood`, `trigger`, `location`, `note` |
| `settings` | `user_id`, `mute`, `reduce_motion`, `language`, `created_at` |
