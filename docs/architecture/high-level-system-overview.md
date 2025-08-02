# High-Level System Overview

(User ▸ Cloudflare Pages ▸ Flutter Web SPA)
 ↧ Service Worker (offline cache & sync)
 ↧ Supabase Edge Functions (Deno + TypeScript, JWT auth, cron jobs)
 ↧ Supabase Postgres 15 (row-level security, AES-256 at rest)
⇄ Supabase Realtime Channels (WebSockets for live streak/timer pushes)
 ↧ Supabase Storage (encrypted exports, future media)
 ↧ Expo Push + Edge Cron (24-h congrats & early-slip nudges)

| Layer    | Technology                 | Why                                                 |
| -------- | -------------------------- | --------------------------------------------------- |
| Frontend | Flutter Web (Dart 3.x)     | Single codebase, future mobile export via Flutter 2 |
| BFF/Edge | Supabase Edge Functions    | Low-latency logic, per-minute cron, cheap at scale  |
| Data     | Supabase Postgres + RLS    | Managed SQL, HIPAA option, time-series views        |
| Realtime | Supabase Channels (WS)     | Live updates without polling                        |
| Auth     | Anonymous device-bound JWT | Zero-friction entry; upgrade path to email/social   |
| Hosting  | Cloudflare Pages           | Global POP caching, built-in SSL, PWA headers       |
| Push     | Expo Push + Edge Cron      | Vendor-agnostic web/mobile notifications            |
