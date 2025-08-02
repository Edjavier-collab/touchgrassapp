import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/timer_session.dart';

class TimerService {
  static const String _timerSessionsKey = 'timer_sessions';
  static const String _activeTimerKey = 'active_timer';
  
  late final SharedPreferences _prefs;
  bool _isInitialized = false;
  
  Timer? _activeTimer;
  TimerSession? _currentSession;
  
  // Stream controllers for reactive updates
  final _sessionController = StreamController<TimerSession?>.broadcast();
  final _tickController = StreamController<Duration>.broadcast();
  
  // Public streams
  Stream<TimerSession?> get sessionStream => _sessionController.stream;
  Stream<Duration> get tickStream => _tickController.stream;
  
  // Current session getter
  TimerSession? get currentSession => _currentSession;
  bool get hasActiveTimer => _currentSession != null && _currentSession!.state == TimerState.running;

  // Initialize the service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _prefs = await SharedPreferences.getInstance();
    await _loadActiveTimer();
    _isInitialized = true;
  }

  // Ensure service is initialized
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('TimerService not initialized. Call initialize() first.');
    }
  }

  // Load active timer from storage
  Future<void> _loadActiveTimer() async {
    final activeTimerJson = _prefs.getString(_activeTimerKey);
    if (activeTimerJson != null && activeTimerJson.isNotEmpty) {
      try {
        final data = json.decode(activeTimerJson);
        _currentSession = TimerSession.fromJson(data);
        _sessionController.add(_currentSession);
        
        // If timer was running when app was closed, pause it
        if (_currentSession!.state == TimerState.running) {
          await _pauseTimer();
        }
      } catch (e) {
        // Clear corrupted data
        await _prefs.remove(_activeTimerKey);
      }
    }
  }

  // Save active timer to storage
  Future<void> _saveActiveTimer() async {
    if (_currentSession != null) {
      final timerJson = json.encode(_currentSession!.toJson());
      await _prefs.setString(_activeTimerKey, timerJson);
    } else {
      await _prefs.remove(_activeTimerKey);
    }
  }

  // Create a new timer session
  Future<TimerSession> createTimer({
    required String name,
    required Duration targetDuration,
    String? woopId,
  }) async {
    _ensureInitialized();
    
    // Stop any existing timer
    if (_currentSession != null) {
      await stopTimer();
    }
    
    _currentSession = TimerSession(
      name: name,
      targetDuration: targetDuration,
      woopId: woopId,
    );
    
    await _saveActiveTimer();
    _sessionController.add(_currentSession);
    
    return _currentSession!;
  }

  // Start the timer
  Future<void> startTimer() async {
    _ensureInitialized();
    
    if (_currentSession == null) {
      throw StateError('No active timer session. Create a timer first.');
    }
    
    if (_currentSession!.state == TimerState.running) {
      return; // Already running
    }
    
    final now = DateTime.now();
    
    // Update session state
    _currentSession = _currentSession!.copyWith(
      state: TimerState.running,
      startedAt: _currentSession!.startedAt ?? now,
    );
    
    // Start the timer tick
    _activeTimer = Timer.periodic(const Duration(seconds: 1), _onTimerTick);
    
    await _saveActiveTimer();
    _sessionController.add(_currentSession);
  }

  // Pause the timer
  Future<void> pauseTimer() async {
    await _pauseTimer();
    await _saveActiveTimer();
  }

  Future<void> _pauseTimer() async {
    if (_currentSession == null || _currentSession!.state != TimerState.running) {
      return;
    }
    
    _activeTimer?.cancel();
    _activeTimer = null;
    
    _currentSession = _currentSession!.copyWith(
      state: TimerState.paused,
      pausedAt: DateTime.now(),
    );
    
    _sessionController.add(_currentSession);
  }

  // Stop and save the timer session
  Future<void> stopTimer() async {
    _ensureInitialized();
    
    if (_currentSession == null) return;
    
    _activeTimer?.cancel();
    _activeTimer = null;
    
    // Save the completed session to history
    await _saveSessionToHistory(_currentSession!);
    
    // Clear active timer
    _currentSession = null;
    await _prefs.remove(_activeTimerKey);
    _sessionController.add(null);
  }

  // Reset the timer to initial state
  Future<void> resetTimer() async {
    _ensureInitialized();
    
    if (_currentSession == null) return;
    
    _activeTimer?.cancel();
    _activeTimer = null;
    
    _currentSession = _currentSession!.copyWith(
      state: TimerState.initial,
      elapsedDuration: Duration.zero,
      startedAt: null,
      pausedAt: null,
      completedAt: null,
      segments: [],
    );
    
    await _saveActiveTimer();
    _sessionController.add(_currentSession);
  }

  // Timer tick handler
  void _onTimerTick(Timer timer) {
    if (_currentSession == null || _currentSession!.state != TimerState.running) {
      timer.cancel();
      return;
    }
    
    final newElapsed = _currentSession!.elapsedDuration + const Duration(seconds: 1);
    
    _currentSession = _currentSession!.copyWith(
      elapsedDuration: newElapsed,
    );
    
    _tickController.add(newElapsed);
    
    // Check if timer is completed
    if (_currentSession!.isCompleted) {
      _completeTimer();
    }
    
    // Auto-save periodically (every 10 seconds)
    if (newElapsed.inSeconds % 10 == 0) {
      _saveActiveTimer();
    }
    
    _sessionController.add(_currentSession);
  }

  // Complete the timer
  void _completeTimer() {
    if (_currentSession == null) return;
    
    _activeTimer?.cancel();
    _activeTimer = null;
    
    _currentSession = _currentSession!.copyWith(
      state: TimerState.completed,
      completedAt: DateTime.now(),
    );
    
    _sessionController.add(_currentSession);
    _saveActiveTimer();
    
    // Could add notification or sound here
  }

  // Save completed session to history
  Future<void> _saveSessionToHistory(TimerSession session) async {
    final sessions = await getAllSessions();
    
    // Remove from current sessions if it exists
    sessions.removeWhere((s) => s.id == session.id);
    
    // Add the completed session
    sessions.add(session);
    
    // Sort by creation date (newest first)
    sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    // Keep only last 100 sessions to avoid storage bloat
    if (sessions.length > 100) {
      sessions.removeRange(100, sessions.length);
    }
    
    await _saveSessionsToStorage(sessions);
  }

  // Get all timer sessions from storage
  Future<List<TimerSession>> getAllSessions() async {
    _ensureInitialized();
    
    final sessionsJson = _prefs.getString(_timerSessionsKey);
    if (sessionsJson == null || sessionsJson.isEmpty) {
      return [];
    }
    
    try {
      final sessionsList = json.decode(sessionsJson) as List<dynamic>;
      return sessionsList
          .map((sessionJson) => TimerSession.fromJson(sessionJson))
          .toList();
    } catch (e) {
      // If there's an error parsing, return empty list and clear storage
      await _prefs.remove(_timerSessionsKey);
      return [];
    }
  }

  // Save sessions to storage
  Future<void> _saveSessionsToStorage(List<TimerSession> sessions) async {
    final sessionsJson = json.encode(
      sessions.map((session) => session.toJson()).toList(),
    );
    await _prefs.setString(_timerSessionsKey, sessionsJson);
  }

  // Get sessions filtered by date range
  Future<List<TimerSession>> getSessionsInDateRange(DateTime start, DateTime end) async {
    final allSessions = await getAllSessions();
    return allSessions.where((session) {
      return session.createdAt.isAfter(start) && session.createdAt.isBefore(end);
    }).toList();
  }

  // Get today's sessions
  Future<List<TimerSession>> getTodaySessions() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getSessionsInDateRange(startOfDay, endOfDay);
  }

  // Get statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final allSessions = await getAllSessions();
    final completedSessions = allSessions.where((s) => s.state == TimerState.completed).toList();
    
    final totalSessions = allSessions.length;
    final completedCount = completedSessions.length;
    final totalTime = completedSessions.fold<Duration>(
      Duration.zero,
      (total, session) => total + session.elapsedDuration,
    );
    
    final today = await getTodaySessions();
    final todayCompleted = today.where((s) => s.state == TimerState.completed).length;
    final todayTime = today.fold<Duration>(
      Duration.zero,
      (total, session) => total + session.elapsedDuration,
    );
    
    return {
      'totalSessions': totalSessions,
      'completedSessions': completedCount,
      'totalTime': totalTime,
      'todaySessions': today.length,
      'todayCompleted': todayCompleted,
      'todayTime': todayTime,
      'completionRate': totalSessions > 0 ? completedCount / totalSessions : 0.0,
    };
  }

  // Clear all data
  Future<void> clearAllData() async {
    _ensureInitialized();
    
    await stopTimer();
    await _prefs.remove(_timerSessionsKey);
    await _prefs.remove(_activeTimerKey);
  }

  // Dispose resources
  void dispose() {
    _activeTimer?.cancel();
    _sessionController.close();
    _tickController.close();
  }
}