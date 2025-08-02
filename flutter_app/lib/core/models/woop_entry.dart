import 'package:uuid/uuid.dart';

class WoopEntry {
  final String id;
  final String wish;
  final String outcome;
  final String obstacle;
  final String plan;
  final DateTime createdAt;
  final DateTime? completedAt;
  final bool isCompleted;

  WoopEntry({
    String? id,
    required this.wish,
    required this.outcome,
    required this.obstacle,
    required this.plan,
    DateTime? createdAt,
    this.completedAt,
    this.isCompleted = false,
  }) : 
    id = id ?? const Uuid().v4(),
    createdAt = createdAt ?? DateTime.now();

  // Convert to JSON for local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wish': wish,
      'outcome': outcome,
      'obstacle': obstacle,
      'plan': plan,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  // Create from JSON
  factory WoopEntry.fromJson(Map<String, dynamic> json) {
    return WoopEntry(
      id: json['id'],
      wish: json['wish'],
      outcome: json['outcome'],
      obstacle: json['obstacle'],
      plan: json['plan'],
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  // Create a copy with updated fields
  WoopEntry copyWith({
    String? id,
    String? wish,
    String? outcome,
    String? obstacle,
    String? plan,
    DateTime? createdAt,
    DateTime? completedAt,
    bool? isCompleted,
  }) {
    return WoopEntry(
      id: id ?? this.id,
      wish: wish ?? this.wish,
      outcome: outcome ?? this.outcome,
      obstacle: obstacle ?? this.obstacle,
      plan: plan ?? this.plan,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'WoopEntry(id: $id, wish: $wish, outcome: $outcome, obstacle: $obstacle, plan: $plan, createdAt: $createdAt, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WoopEntry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}