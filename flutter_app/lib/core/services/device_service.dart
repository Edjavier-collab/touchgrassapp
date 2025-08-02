import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceService {
  static const _deviceIdKey = 'touchgrass_device_id';
  static late SharedPreferences _prefs;
  static String? _deviceId;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _deviceId = await getOrCreateDeviceId();
  }

  static Future<String> getOrCreateDeviceId() async {
    String? existingId = _prefs.getString(_deviceIdKey);

    if (existingId != null && existingId.isNotEmpty) {
      return existingId;
    }

    // Generate new device ID
    const uuid = Uuid();
    final newDeviceId = 'device_${uuid.v4()}';

    // Store it
    await _prefs.setString(_deviceIdKey, newDeviceId);

    return newDeviceId;
  }

  static String get deviceId {
    if (_deviceId == null) {
      throw StateError(
          'DeviceService not initialized. Call DeviceService.initialize() first.');
    }
    return _deviceId!;
  }

  static Future<bool> clearDeviceId() async {
    final success = await _prefs.remove(_deviceIdKey);
    if (success) {
      _deviceId = null;
    }
    return success;
  }

  static Future<void> refreshDeviceId() async {
    _deviceId = await getOrCreateDeviceId();
  }
}
