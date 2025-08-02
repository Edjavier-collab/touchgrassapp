# Epics & User Stories

| Epic | Description | Key User Stories & Acceptance Criteria |
|------|-------------|----------------------------------------|
| **E1 Onboarding** | Anonymous, device-bound auth | **US-1 Device Registration** – App assigns a unique ID tied to the device.<br>✅ ID stored locally & in Supabase.<br>✅ Data persists after refresh.<br><br>**US-2 Reset / Export** – User can export or delete data, or migrate to registered account later. |
| **E2 WOOP Flow** | Create & manage WOOP entries | **US-3 Create WOOP** – Enter Wish, Outcome, Obstacle, Plan (≤ 280 chars each).<br>✅ All fields required, autosave every 5 s.<br><br>**US-4 Edit WOOP** – Edit draft before starting timer. |
| **E3 Timer & Streaks** | 24-h craving timer | **US-5 Start Timer** – One active timer counts up to 24 h.<br>✅ Pauses on page unload, resumes on load.<br><br>**US-6 Stop / Slip** – Auto-stop at 24 h or when user taps *I slipped*.<br>✅ Duration logged in seconds, linked to WOOP ID. |
| **E4 Analytics** | Visualize progress | **US-7 Graphs** – Show daily line, cumulative best bar, rolling 7-day average trend.<br>✅ Tooltip reveals date, duration, WOOP wish.<br>✅ Empty state if < 3 data points. |
| **E5 Notifications** | Nudges & rewards | **US-8 24-h Congrats** – Push/email within 1 min of success.<br>**US-9 Slip Alert** – Gentle nudge on early slip.<br>✅ Opt-out toggle present. |
| **E6 Security & Compliance** | HIPAA-aligned | **US-10 Encrypt Data** – AES-256 at rest, TLS 1.3 in transit.<br>**US-11 Audit Log** – CRUD events logged; quarterly review passes. |
| **E7 Internationalization** | Spanish UI | **US-12 Spanish Locale** – All strings externalized; language toggle persists. |
| **E8 Celebration & Motivation** | Fun feedback | **US-13 Instant Celebration** – Confetti + random phrase (“Craving is tough, but you’re tougher!”).<br>**US-14 Sound FX** – Upbeat chime; respects mute.<br>**US-15 Emoji Rain** – Optional overlay; respects “reduce motion.”<br>**US-16 Gen-Z Easter Eggs** – Hidden jokes unlock at milestones. |
