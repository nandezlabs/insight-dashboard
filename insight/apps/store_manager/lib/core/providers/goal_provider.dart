import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_core/insight_core.dart';

// Repository providers
final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository();
});

final kpiCalculationServiceProvider = Provider<KpiCalculationService>((ref) {
  return KpiCalculationService(
    submissionRepository: ref.watch(submissionRepositoryProvider),
    goalRepository: ref.watch(goalRepositoryProvider),
  );
});

// State providers for goals
final goalsProvider = FutureProvider<List<Goal>>((ref) async {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getGoals();
});

final goalsByTypeProvider = FutureProvider.family<List<Goal>, GoalType?>((ref, type) async {
  final repository = ref.watch(goalRepositoryProvider);
  
  if (type == null) {
    return repository.getGoals();
  }
  
  return repository.getGoalsByType(type);
});

final latestKpiDataProvider = FutureProvider<KpiData?>((ref) async {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getLatestKpiData();
});

final kpiDataByDateProvider = FutureProvider.family<KpiData?, DateTime>((ref, date) async {
  final repository = ref.watch(goalRepositoryProvider);
  return repository.getKpiDataByDate(date);
});

// State notifier for goal management
class GoalNotifier extends StateNotifier<AsyncValue<List<Goal>>> {
  final GoalRepository _repository;

  GoalNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadGoals();
  }

  Future<void> loadGoals() async {
    state = const AsyncValue.loading();
    try {
      final goals = await _repository.getGoals();
      state = AsyncValue.data(goals);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> createGoal({
    required GoalType goalType,
    required double targetValue,
    required DateTime periodDate,
  }) async {
    try {
      await _repository.createGoal(
        goalType: goalType,
        targetValue: targetValue,
        periodDate: periodDate,
      );
      await loadGoals();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateGoal(
    String id, {
    GoalType? goalType,
    double? targetValue,
    DateTime? periodDate,
  }) async {
    try {
      await _repository.updateGoal(
        id,
        goalType: goalType,
        targetValue: targetValue,
        periodDate: periodDate,
      );
      await loadGoals();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteGoal(String id) async {
    try {
      await _repository.deleteGoal(id);
      await loadGoals();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> filterByType(GoalType? type) async {
    state = const AsyncValue.loading();
    try {
      final goals = type == null
          ? await _repository.getGoals()
          : await _repository.getGoalsByType(type);
      state = AsyncValue.data(goals);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final goalNotifierProvider = StateNotifierProvider<GoalNotifier, AsyncValue<List<Goal>>>((ref) {
  final repository = ref.watch(goalRepositoryProvider);
  return GoalNotifier(repository);
});

// Submission repository provider (if not already defined)
final submissionRepositoryProvider = Provider<SubmissionRepository>((ref) {
  return SubmissionRepository();
});
