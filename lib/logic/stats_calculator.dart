// lib/logic/stats_calculator.dart

import 'package:habittrack/models/check_in.dart';

// Returns success rate (0.0 - 1.0) for each of the last N weeks, oldest first
List<double> weeklySuccessRates(List<CheckIn> checkIns, {int weeks = 8}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final rates = <double>[];

  for (int w = weeks - 1; w >= 0; w--) {
    final weekEnd = today.subtract(Duration(days: w * 7));
    final weekStart = weekEnd.subtract(const Duration(days: 6));

    final weekCheckIns = checkIns.where((c) {
      final d = DateTime(c.createdAt.year, c.createdAt.month, c.createdAt.day);
      return !d.isBefore(weekStart) && !d.isAfter(weekEnd);
    }).toList();

    if (weekCheckIns.isEmpty) {
      rates.add(0);
    } else {
      final successes = weekCheckIns.where((c) => c.status == 'success').length;
      rates.add(successes / weekCheckIns.length);
    }
  }

  return rates;
}