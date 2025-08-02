# Top Risks & Mitigations

1. Realtime buffering hiccups on flaky networks — mitigate with local cache + retry queue
2. iOS web push deliverability — consider Twilio SMS fallback in v1.2
3. Supabase usage cost spike — partition tables, enable PG-Bouncer pooler
