import 'package:habittrack/models/check_in.dart';
import 'dart:math';

int daysBetween(DateTime date1, DateTime date2) {
  final d1 = DateTime(date1.year, date1.month, date1.day);
  final d2 = DateTime(date2.year, date2.month, date2.day);
  return d2.difference(d1).inDays;
}

({int current, int longest}) calculateStreaks(List<CheckIn> checkIns) {
  if (checkIns.isEmpty) {
    return (current: 0, longest: 0);
  }

  final sortedCheckIns = List<CheckIn>.from(checkIns)
    ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  int longestStreak = 0;
  int runningStreak = 0;
  DateTime? previousDate;

  for (CheckIn checkIn in sortedCheckIns) {
    if (checkIn.status == 'success') {
      if (previousDate == null) {
        runningStreak = 1;
      } else {
        int gapDays = daysBetween(previousDate, checkIn.createdAt);
        if (gapDays == 1) {
          runningStreak += 1;
        } else {
          runningStreak = 1;
        }
      }
      longestStreak = max(longestStreak, runningStreak);
    } else {
      runningStreak = 0;
    }
    previousDate = checkIn.createdAt;
  }

  final lastCheckIn = sortedCheckIns.last;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final daysSinceLastLog = daysBetween(lastCheckIn.createdAt, today);

  int currentStreak;
  if (lastCheckIn.status == 'slip') {
    currentStreak = 0;
  } else if (daysSinceLastLog > 1) {
    currentStreak = 0;
  } else {
    currentStreak = runningStreak;
  }

  return (current: currentStreak, longest: longestStreak);
}

const List<int> milestoneThresholds = [7, 30, 90, 180, 365];

int? checkMilestone(int currentStreak) {
  if (milestoneThresholds.contains(currentStreak)) {
    return currentStreak;
  }
  return null;
}