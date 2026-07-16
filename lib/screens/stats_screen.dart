// lib/screens/stats_screen.dart

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:habittrack/db/database_helper.dart';
import 'package:habittrack/models/habit.dart';
import 'package:habittrack/logic/streak_calculator.dart';
import 'package:habittrack/logic/stats_calculator.dart';

class StatsScreen extends StatefulWidget {
  final Habit habit;
  const StatsScreen({super.key, required this.habit});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  bool isLoading = true;
  ({int current, int longest}) streaks = (current: 0, longest: 0);
  List<double> weeklyRates = [];
  int urgeCount = 0;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    final checkIns =
    await DatabaseHelper.instance.getCheckInsForHabit(widget.habit.id!);
    final urges =
    await DatabaseHelper.instance.getUrgesForHabit(widget.habit.id!);

    setState(() {
      streaks = calculateStreaks(checkIns);
      weeklyRates = weeklySuccessRates(checkIns);
      urgeCount = urges.length;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stats — ${widget.habit.name}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                      label: 'Current',
                      value: '${streaks.current}',
                      color: const Color(0xFF2E7D6B)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                      label: 'Longest',
                      value: '${streaks.longest}',
                      color: const Color(0xFF8A6D3B)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                      label: 'Urges',
                      value: '$urgeCount',
                      color: const Color(0xFF5B7B9A)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Weekly success rate (last 8 weeks)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  minY: 0,
                  maxY: 1,
                  barGroups: List.generate(weeklyRates.length, (i) {
                    return BarChartGroupData(x: i, barRods: [
                      BarChartRodData(
                        toY: weeklyRates[i],
                        color: const Color(0xFF2E7D6B),
                        width: 14,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 1,
                          color: const Color(0xFFE8F0EC),
                        ),
                      ),
                    ]);
                  }),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) => Text(
                          '${(value * 100).toInt()}%',
                          style: const TextStyle(fontSize: 10, color: Color(0xFF2E4D42)),
                        ),
                      ),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: const Color(0xFFE0DDD5),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}
