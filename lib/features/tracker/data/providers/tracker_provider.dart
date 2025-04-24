import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/tracker_model.dart';
import '../repositories/tracker_repository.dart';

// Repository provider
final trackerRepositoryProvider = Provider<TrackerRepository>((ref) {
  return MockTrackerRepository();
});

// State notifier for tracker data
class TrackerNotifier extends StateNotifier<AsyncValue<TrackerData?>> {
  final TrackerRepository _repository;

  TrackerNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadTrackerData();
  }

  Future<void> loadTrackerData() async {
    state = const AsyncValue.loading();
    try {
      final data = await _repository.getTrackerData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> logSlip() async {
    try {
      await _repository.logSlip();
      await loadTrackerData(); // Reload data after logging slip
    } catch (error) {
      // Handle error
    }
  }

  Future<void> logMood(DateTime date, int moodLevel) async {
    try {
      await _repository.logMood(date, moodLevel);
      await loadTrackerData(); // Reload data after logging mood
    } catch (error) {
      // Handle error
    }
  }

  Future<void> resetData() async {
    try {
      await _repository.resetData();
      await loadTrackerData(); // Reload data after reset
    } catch (error) {
      // Handle error
    }
  }
}

// Provider for tracker state
final trackerProvider =
    StateNotifierProvider<TrackerNotifier, AsyncValue<TrackerData?>>((ref) {
  final repository = ref.watch(trackerRepositoryProvider);
  return TrackerNotifier(repository);
});

// Convenience providers for commonly used data
final daysCleanProvider = Provider<int>((ref) {
  final trackerDataAsync = ref.watch(trackerProvider);
  return trackerDataAsync.when(
    data: (data) => data?.daysClean ?? 0,
    loading: () => 0,
    error: (_, __) => 0,
  );
});

final milestonesProvider = Provider<List<int>>((ref) {
  return [1, 7, 30, 90, 180, 365];
});

final weeklyDataProvider =
    Provider.family<List<DayData>, int>((ref, weeksBack) {
  final trackerDataAsync = ref.watch(trackerProvider);
  return trackerDataAsync.when(
    data: (data) => data?.getWeeklyData(weeksBack) ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
});
