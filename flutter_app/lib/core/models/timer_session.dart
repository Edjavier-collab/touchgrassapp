import 'package:uuid/uuid.dart';

enum TimerState {
  initial,
  running,
  paused,
  completed,
}

class TimerSession {
  final String id;
  final String name;
  final Duration targetDuration;
  final Duration elapsedDuration;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? pausedAt;
  final DateTime? completedAt;
  final TimerState state;
  final String? woopId; // Optional link to a WOOP entry
  final List<TimerSegment> segments;

  TimerSession({
    String? id,
    required this.name,
    required this.targetDuration,
    this.elapsedDuration = Duration.zero,
    DateTime? createdAt,
    this.startedAt,
    this.pausedAt,
    this.completedAt,
    this.state = TimerState.initial,
    this.woopId,
    this.segments = const [],
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  // Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetDuration': targetDuration.inSeconds,
      'elapsedDuration': elapsedDuration.inSeconds,
      'createdAt': createdAt.toIso8601String(),
      'startedAt': startedAt?.toIso8601String(),
      'pausedAt': pausedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'state': state.name,
      'woopId': woopId,
      'segments': segments.map((s) => s.toJson()).toList(),
    };
  }

  // Create from JSON
  factory TimerSession.fromJson(Map<String, dynamic> json) {
    return TimerSession(
      id: json['id'],
      name: json['name'],
      targetDuration: Duration(seconds: json['targetDuration']),
      elapsedDuration: Duration(seconds: json['elapsedDuration'] ?? 0),
      createdAt: DateTime.parse(json['createdAt']),
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      pausedAt: json['pausedAt'] != null ? DateTime.parse(json['pausedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      state: TimerState.values.firstWhere((e) => e.name == json['state']),
      woopId: json['woopId'],
      segments: (json['segments'] as List<dynamic>?)
          ?.map((s) => TimerSegment.fromJson(s))
          .toList() ?? [],
    );
  }

  // Create a copy with updated fields
  TimerSession copyWith({
    String? id,
    String? name,
    Duration? targetDuration,
    Duration? elapsedDuration,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? pausedAt,
    DateTime? completedAt,
    TimerState? state,
    String? woopId,
    List<TimerSegment>? segments,
  }) {
    return TimerSession(
      id: id ?? this.id,
      name: name ?? this.name,
      targetDuration: targetDuration ?? this.targetDuration,
      elapsedDuration: elapsedDuration ?? this.elapsedDuration,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      pausedAt: pausedAt ?? this.pausedAt,
      completedAt: completedAt ?? this.completedAt,
      state: state ?? this.state,
      woopId: woopId ?? this.woopId,
      segments: segments ?? this.segments,
    );
  }

  // Calculate progress percentage
  double get progressPercentage {
    if (targetDuration.inSeconds == 0) return 0.0;
    return (elapsedDuration.inSeconds / targetDuration.inSeconds).clamp(0.0, 1.0);
  }

  // Check if timer is completed
  bool get isCompleted => elapsedDuration >= targetDuration || state == TimerState.completed;

  // Get remaining time
  Duration get remainingDuration {
    final remaining = targetDuration - elapsedDuration;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  // Format duration for display
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String get formattedElapsed => formatDuration(elapsedDuration);
  String get formattedTarget => formatDuration(targetDuration);
  String get formattedRemaining => formatDuration(remainingDuration);

  @override
  String toString() {
    return 'TimerSession(id: $id, name: $name, state: $state, elapsed: $formattedElapsed, target: $formattedTarget)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimerSession && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Represents a continuous time segment when timer was running
class TimerSegment {
  final DateTime startTime;
  final DateTime? endTime;
  final Duration duration;

  TimerSegment({
    required this.startTime,
    this.endTime,
    Duration? duration,
  }) : duration = duration ?? (endTime != null ? endTime.difference(startTime) : Duration.zero);

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration.inSeconds,
    };
  }

  factory TimerSegment.fromJson(Map<String, dynamic> json) {
    return TimerSegment(
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      duration: Duration(seconds: json['duration']),
    );
  }

  TimerSegment copyWith({
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
  }) {
    return TimerSegment(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
    );
  }
}