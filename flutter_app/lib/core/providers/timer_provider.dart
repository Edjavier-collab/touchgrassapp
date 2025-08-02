import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timer_session.dart';
import '../services/timer_service.dart';

// Provider for TimerService
final timerServiceProvider = Provider<TimerService>((ref) {
  return TimerService();
});

// StateNotifier for timer state management
class TimerNotifier extends StateNotifier<AsyncValue<TimerSession?>> {
  TimerNotifier(this._timerService) : super(const AsyncValue.loading()) {
    _initialize();
  }

  final TimerService _timerService;

  Future<void> _initialize() async {
    try {
      await _timerService.initialize();
      state = AsyncValue.data(_timerService.currentSession);
      
      // Listen to timer service updates
      _timerService.sessionStream.listen((session) {
        state = AsyncValue.data(session);
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Create a new timer
  Future<void> createTimer({
    required String name,
    required Duration targetDuration,
    String? woopId,
  }) async {
    try {
      await _timerService.createTimer(
        name: name,
        targetDuration: targetDuration,
        woopId: woopId,
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Start the timer
  Future<void> startTimer() async {
    try {
      await _timerService.startTimer();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Pause the timer
  Future<void> pauseTimer() async {
    try {
      await _timerService.pauseTimer();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Stop the timer
  Future<void> stopTimer() async {
    try {
      await _timerService.stopTimer();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Reset the timer
  Future<void> resetTimer() async {
    try {
      await _timerService.resetTimer();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Main timer provider
final timerProvider = StateNotifierProvider<TimerNotifier, AsyncValue<TimerSession?>>((ref) {
  final timerService = ref.watch(timerServiceProvider);
  return TimerNotifier(timerService);
});

// Provider for timer history
final timerHistoryProvider = FutureProvider<List<TimerSession>>((ref) async {
  final timerService = ref.watch(timerServiceProvider);
  await timerService.initialize();
  return timerService.getAllSessions();
});

// Provider for today's sessions
final todayTimerSessionsProvider = FutureProvider<List<TimerSession>>((ref) async {
  final timerService = ref.watch(timerServiceProvider);
  await timerService.initialize();
  return timerService.getTodaySessions();
});

// Provider for timer statistics
final timerStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final timerService = ref.watch(timerServiceProvider);
  await timerService.initialize();
  return timerService.getStatistics();
});

// Provider for timer tick stream
final timerTickProvider = StreamProvider<Duration>((ref) {
  final timerService = ref.watch(timerServiceProvider);
  return timerService.tickStream;
});

// Timer form state for creating new timers
class TimerFormNotifier extends StateNotifier<TimerFormState> {
  TimerFormNotifier() : super(TimerFormState.initial());

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateDuration(Duration duration) {
    state = state.copyWith(targetDuration: duration);
  }

  void updateWoopId(String? woopId) {
    state = state.copyWith(woopId: woopId);
  }

  void clear() {
    state = TimerFormState.initial();
  }

  bool get isValid {
    return state.name.trim().isNotEmpty && 
           state.targetDuration.inSeconds > 0;
  }
}

class TimerFormState {
  final String name;
  final Duration targetDuration;
  final String? woopId;

  TimerFormState({
    required this.name,
    required this.targetDuration,
    this.woopId,
  });

  factory TimerFormState.initial() {
    return TimerFormState(
      name: '',
      targetDuration: const Duration(minutes: 25), // Default Pomodoro
    );
  }

  TimerFormState copyWith({
    String? name,
    Duration? targetDuration,
    String? woopId,
  }) {
    return TimerFormState(
      name: name ?? this.name,
      targetDuration: targetDuration ?? this.targetDuration,
      woopId: woopId ?? this.woopId,
    );
  }
}

final timerFormProvider = StateNotifierProvider<TimerFormNotifier, TimerFormState>((ref) {
  return TimerFormNotifier();
});

// Quick timer presets
final timerPresetsProvider = Provider<List<TimerPreset>>((ref) {
  return [
    TimerPreset(name: 'Focus Session', duration: const Duration(minutes: 25), description: 'Pomodoro technique'),
    TimerPreset(name: 'Short Break', duration: const Duration(minutes: 5), description: 'Quick rest'),
    TimerPreset(name: 'Long Break', duration: const Duration(minutes: 15), description: 'Extended rest'),
    TimerPreset(name: 'Deep Work', duration: const Duration(minutes: 50), description: 'Intense focus'),
    TimerPreset(name: 'Exercise', duration: const Duration(minutes: 30), description: 'Workout time'),
    TimerPreset(name: 'Meditation', duration: const Duration(minutes: 10), description: 'Mindfulness'),
  ];
});

class TimerPreset {
  final String name;
  final Duration duration;
  final String description;

  TimerPreset({
    required this.name,
    required this.duration,
    required this.description,
  });
}