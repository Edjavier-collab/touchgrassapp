# Client Architecture

• State: Riverpod 2 + hydrated_riverpod → drafts & timer ticks persisted to localStorage
• Offline: Workbox service-worker precaches shell, queues writes for background sync
• Celebrations: confetti 0.7 + custom emoji rain overlay; just_audio FX respect mute/reduce-motion
