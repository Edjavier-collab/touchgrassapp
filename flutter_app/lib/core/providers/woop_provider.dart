import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/woop_entry.dart';
import '../services/woop_storage_service.dart';

// Provider for WoopStorageService
final woopStorageServiceProvider = Provider<WoopStorageService>((ref) {
  return WoopStorageService();
});

// StateNotifier for managing WOOP entries
class WoopNotifier extends StateNotifier<AsyncValue<List<WoopEntry>>> {
  WoopNotifier(this._storageService) : super(const AsyncValue.loading()) {
    _loadEntries();
  }

  final WoopStorageService _storageService;

  // Load all entries
  Future<void> _loadEntries() async {
    try {
      await _storageService.initialize();
      final entries = await _storageService.getAllWoopEntries();
      state = AsyncValue.data(entries);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Reload entries from storage
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadEntries();
  }

  // Add a new WOOP entry
  Future<void> addEntry(WoopEntry entry) async {
    try {
      await _storageService.saveWoopEntry(entry);
      await _loadEntries(); // Reload to reflect changes
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Update an existing WOOP entry
  Future<void> updateEntry(WoopEntry entry) async {
    try {
      await _storageService.saveWoopEntry(entry);
      await _loadEntries(); // Reload to reflect changes
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Delete a WOOP entry
  Future<void> deleteEntry(String id) async {
    try {
      await _storageService.deleteWoopEntry(id);
      await _loadEntries(); // Reload to reflect changes
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Toggle completion status
  Future<void> toggleCompletion(String id) async {
    try {
      await _storageService.toggleWoopCompletion(id);
      await _loadEntries(); // Reload to reflect changes
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  // Clear all entries
  Future<void> clearAll() async {
    try {
      await _storageService.clearAllEntries();
      await _loadEntries(); // Reload to reflect changes
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Provider for WOOP entries
final woopProvider = StateNotifierProvider<WoopNotifier, AsyncValue<List<WoopEntry>>>((ref) {
  final storageService = ref.watch(woopStorageServiceProvider);
  return WoopNotifier(storageService);
});

// Derived providers for different views
final completedWoopEntriesProvider = Provider<AsyncValue<List<WoopEntry>>>((ref) {
  final woopState = ref.watch(woopProvider);
  return woopState.when(
    data: (entries) => AsyncValue.data(
      entries.where((entry) => entry.isCompleted).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

final pendingWoopEntriesProvider = Provider<AsyncValue<List<WoopEntry>>>((ref) {
  final woopState = ref.watch(woopProvider);
  return woopState.when(
    data: (entries) => AsyncValue.data(
      entries.where((entry) => !entry.isCompleted).toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Provider for entry counts
final woopStatsProvider = Provider<AsyncValue<Map<String, int>>>((ref) {
  final woopState = ref.watch(woopProvider);
  return woopState.when(
    data: (entries) {
      final completed = entries.where((entry) => entry.isCompleted).length;
      final pending = entries.where((entry) => !entry.isCompleted).length;
      return AsyncValue.data({
        'total': entries.length,
        'completed': completed,
        'pending': pending,
      });
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

// Form state provider for WOOP creation/editing
class WoopFormNotifier extends StateNotifier<WoopFormState> {
  WoopFormNotifier() : super(WoopFormState.empty());

  void updateWish(String wish) {
    state = state.copyWith(wish: wish);
  }

  void updateOutcome(String outcome) {
    state = state.copyWith(outcome: outcome);
  }

  void updateObstacle(String obstacle) {
    state = state.copyWith(obstacle: obstacle);
  }

  void updatePlan(String plan) {
    state = state.copyWith(plan: plan);
  }

  void setEntry(WoopEntry? entry) {
    if (entry != null) {
      state = WoopFormState(
        wish: entry.wish,
        outcome: entry.outcome,
        obstacle: entry.obstacle,
        plan: entry.plan,
        editingId: entry.id,
      );
    } else {
      state = WoopFormState.empty();
    }
  }

  void clear() {
    state = WoopFormState.empty();
  }

  WoopEntry toWoopEntry() {
    if (state.editingId != null) {
      return WoopEntry(
        id: state.editingId,
        wish: state.wish,
        outcome: state.outcome,
        obstacle: state.obstacle,
        plan: state.plan,
      );
    } else {
      return WoopEntry(
        wish: state.wish,
        outcome: state.outcome,
        obstacle: state.obstacle,
        plan: state.plan,
      );
    }
  }

  bool get isValid {
    return state.wish.trim().isNotEmpty &&
           state.outcome.trim().isNotEmpty &&
           state.obstacle.trim().isNotEmpty &&
           state.plan.trim().isNotEmpty;
  }

  bool get isEditing => state.editingId != null;
}

class WoopFormState {
  final String wish;
  final String outcome;
  final String obstacle;
  final String plan;
  final String? editingId;

  WoopFormState({
    required this.wish,
    required this.outcome,
    required this.obstacle,
    required this.plan,
    this.editingId,
  });

  factory WoopFormState.empty() {
    return WoopFormState(
      wish: '',
      outcome: '',
      obstacle: '',
      plan: '',
    );
  }

  WoopFormState copyWith({
    String? wish,
    String? outcome,
    String? obstacle,
    String? plan,
    String? editingId,
  }) {
    return WoopFormState(
      wish: wish ?? this.wish,
      outcome: outcome ?? this.outcome,
      obstacle: obstacle ?? this.obstacle,
      plan: plan ?? this.plan,
      editingId: editingId ?? this.editingId,
    );
  }
}

final woopFormProvider = StateNotifierProvider<WoopFormNotifier, WoopFormState>((ref) {
  return WoopFormNotifier();
});