import '../../domain/models/tracker_model.dart';

abstract class TrackerRepository {
  Future<TrackerData> getTrackerData();
  Future<void> logSlip();
  Future<void> logMood(DateTime date, int moodLevel);
  Future<void> resetData();
}

class MockTrackerRepository implements TrackerRepository {
  @override
  Future<TrackerData> getTrackerData() async {
    // Mock implementation for demonstration
    final startDate = DateTime.now().subtract(const Duration(days: 42));
    final dayRecords = List.generate(
      42,
      (index) {
        final date = startDate.add(Duration(days: index));
        final hasSlipped = index % 9 == 0;
        final moodLevel = hasSlipped ? 0 : ((index % 11) ~/ 2);

        return DayData(
          date: date,
          moodLevel: moodLevel,
          hasSlipped: hasSlipped,
        );
      },
    );

    return TrackerData(
      startDate: startDate,
      dayRecords: dayRecords,
    );
  }

  @override
  Future<void> logSlip() async {
    // In a real implementation, this would record a slip in the database
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> logMood(DateTime date, int moodLevel) async {
    // In a real implementation, this would save the mood level for the given date
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> resetData() async {
    // In a real implementation, this would reset the user's data
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
