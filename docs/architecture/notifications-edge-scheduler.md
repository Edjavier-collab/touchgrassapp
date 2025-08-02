# Notifications & Edge Scheduler

| Job           | Trigger                    | Schedule              | Payload                                   |
| ------------- | -------------------------- | --------------------- | ----------------------------------------- |
| 24-h Congrats | streak duration = 86 400 s | Every minute cron job | “24 hours! You’re tougher than cravings.” |
| Slip Nudge    | /timer/stop < 300 s        | Immediate             | Gentle reminder + WOOP recap              |

Expo tokens stored in user_settings; batch size 100 to stay under Expo limits.
