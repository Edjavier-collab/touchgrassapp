const DEVICE_ID_KEY = 'touchgrass_device_id'

export function getDeviceId(): string | null {
  if (typeof window === 'undefined') return null
  
  try {
    return localStorage.getItem(DEVICE_ID_KEY)
  } catch (error) {
    console.error('Error reading device ID from localStorage:', error)
    return null
  }
}

export function setDeviceId(deviceId: string): void {
  if (typeof window === 'undefined') return
  
  try {
    localStorage.setItem(DEVICE_ID_KEY, deviceId)
  } catch (error) {
    console.error('Error saving device ID to localStorage:', error)
  }
}

export function generateDeviceId(): string {
  // Use crypto.randomUUID if available, fallback to custom implementation
  if (typeof crypto !== 'undefined' && crypto.randomUUID) {
    return crypto.randomUUID()
  }
  
  // Fallback implementation
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    const r = Math.random() * 16 | 0
    const v = c === 'x' ? r : (r & 0x3 | 0x8)
    return v.toString(16)
  })
}

export async function ensureDeviceId(): Promise<string> {
  let deviceId = getDeviceId()
  
  if (!deviceId) {
    deviceId = generateDeviceId()
    setDeviceId(deviceId)
  }
  
  return deviceId
}