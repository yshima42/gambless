import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/tracker_model.dart';
import '../repositories/tracker_repository.dart';

part 'tracker_provider.g.dart';

// Repository provider
@riverpod
TrackerRepository trackerRepository(Ref ref) {
  return MockTrackerRepository();
}

// State notifier for tracker data
@riverpod
class Tracker extends _$Tracker {
  @override
  AsyncValue<TrackerData?> build() {
    loadTrackerData();
    return const AsyncValue.loading();
  }

  Future<void> loadTrackerData() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.watch(trackerRepositoryProvider);
      final data = await repository.getTrackerData();
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> logSlip() async {
    try {
      final repository = ref.watch(trackerRepositoryProvider);
      await repository.logSlip();
      await loadTrackerData(); // Reload data after logging slip
    } catch (error) {
      // Handle error
    }
  }

  Future<void> logMood(DateTime date, int moodLevel) async {
    try {
      final repository = ref.watch(trackerRepositoryProvider);
      await repository.logMood(date, moodLevel);
      await loadTrackerData(); // Reload data after logging mood
    } catch (error) {
      // Handle error
    }
  }

  Future<void> resetData() async {
    try {
      final repository = ref.watch(trackerRepositoryProvider);
      await repository.resetData();
      await loadTrackerData(); // Reload data after reset
    } catch (error) {
      // Handle error
    }
  }
}

// Convenience providers for commonly used data
@riverpod
int daysClean(Ref ref) {
  final trackerDataAsync = ref.watch(trackerProvider);
  return trackerDataAsync.when(
    data: (data) => data?.daysClean ?? 0,
    loading: () => 0,
    error: (_, __) => 0,
  );
}

@riverpod
List<int> milestones(Ref ref) {
  return [1, 7, 30, 90, 180, 365];
}

@riverpod
List<DayData> weeklyData(Ref ref, int weeksBack) {
  final trackerDataAsync = ref.watch(trackerProvider);
  return trackerDataAsync.when(
    data: (data) => data?.getWeeklyData(weeksBack) ?? [],
    loading: () => [],
    error: (_, __) => [],
  );
}
