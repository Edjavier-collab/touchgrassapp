export interface DraftMessage {
  id: string;
  content: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface TimerState {
  isActive: boolean;
  startTime: number | null;
  duration: number;
  remaining: number;
}

export interface CelebrationState {
  isActive: boolean;
  type: 'confetti' | 'emoji' | null;
  emoji?: string;
}

export interface AppSettings {
  soundEnabled: boolean;
  notificationsEnabled: boolean;
  reduceMotion: boolean;
}