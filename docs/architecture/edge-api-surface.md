# Edge API Surface

| Route        | Verb | Auth     | Purpose                                           |
| ------------ | ---- | -------- | ------------------------------------------------- |
| /timer/start | POST | anon JWT | Create active timer, return realtime channel ID   |
| /timer/stop  | POST | anon JWT | Finalize streak, calculate duration, trigger push |
| /summary     | GET  | anon JWT | Aggregate stats (daily, best, 7-day avg)          |
| /export      | GET  | anon JWT | Encrypted ZIP of user data                        |

Shared middleware: Zod schema validation, 60 req/min rate-limit, structured logging.
