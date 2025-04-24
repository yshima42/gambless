import 'package:flutter/material.dart';

class DayData {
  final DateTime date;
  final int moodLevel; // 0 to 4 where 0 is bad, 4 is good
  final bool hasSlipped;

  const DayData({
    required this.date,
    required this.moodLevel,
    this.hasSlipped = false,
  });
}

class TrackerData {
  final DateTime startDate;
  final List<DayData> dayRecords;

  const TrackerData({
    required this.startDate,
    required this.dayRecords,
  });

  int get daysClean {
    if (dayRecords.isEmpty) return 0;

    // Get latest slip date
    final latestSlip = dayRecords
        .where((day) => day.hasSlipped)
        .map((day) => day.date)
        .fold<DateTime?>(
            null,
            (latest, date) =>
                latest == null || date.isAfter(latest) ? date : latest);

    // If no slips, calculate from start date
    if (latestSlip == null) {
      return DateTime.now().difference(startDate).inDays;
    }

    // Calculate days since last slip
    return DateTime.now().difference(latestSlip).inDays;
  }

  double getPercentToMilestone(int milestone) {
    final days = daysClean;
    if (days >= milestone) return 1.0;
    return days / milestone;
  }

  List<DayData> getWeeklyData(int weeksBack) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: weeksBack * 7));

    return dayRecords
        .where((day) => day.date.isAfter(weekStart) && day.date.isBefore(now))
        .toList();
  }
}
