export interface User {
  id: string
  device_id: string
  created_at: string
}

export interface WoopEntry {
  id: string
  user_id: string
  wish: string
  outcome: string
  obstacle: string
  plan: string
  created_at: string
  updated_at: string
}

export interface Streak {
  id: string
  user_id: string
  woop_id: string
  started_at: string
  ended_at: string | null
  duration_seconds: number | null
  completed: boolean
}

export interface MoodLog {
  id: string
  streak_id: string
  mood: string | null
  trigger: string | null
  location: string | null
  note: string | null
  created_at: string
}

export interface Settings {
  user_id: string
  mute: boolean
  reduce_motion: boolean
  language: string
  notifications_enabled: boolean
  created_at: string
  updated_at: string
}