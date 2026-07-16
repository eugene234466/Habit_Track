// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:habittrack/db/database_helper.dart';
import 'package:habittrack/models/habit.dart';
import 'package:habittrack/logic/streak_calculator.dart';
import 'package:habittrack/logic/scripture_provider.dart';
import 'package:habittrack/screens/add_habit_screen.dart';
import 'package:habittrack/screens/check_in_screen.dart';
import 'package:habittrack/screens/log_urge.dart';
import 'package:habittrack/screens/stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> habits = [];
  Map<int, ({int current, int longest})> streaksByHabitId = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });

    final loadedHabits = await DatabaseHelper.instance.getHabits();
    final Map<int, ({int current, int longest})> streaks = {};

    for (final habit in loadedHabits) {
      final checkIns =
      await DatabaseHelper.instance.getCheckInsForHabit(habit.id!);
      streaks[habit.id!] = calculateStreaks(checkIns);
    }

    setState(() {
      habits = loadedHabits;
      streaksByHabitId = streaks;
      isLoading = false;
    });
  }

  Future<void> confirmDelete(Habit habit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete habit?'),
        content: Text(
          'This will permanently delete "${habit.name}" and all its check-ins and urge logs. This can\'t be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteHabit(habit.id!);
      loadData();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Habit Tracker')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: loadData,
        child: Column(
          children: [
            Card(
              color: const Color(0xFFE8F0EC), // soft sage tint
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  getTodaysScripture(),
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF2E4D42),
                  ),
                ),
              ),
            ),
            Expanded(
              child: habits.isEmpty
                  ? const Center(child: Text('No habits yet — add one'))
                  : ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  final habit = habits[index];
                  final streak = streaksByHabitId[habit.id] ??
                      (current: 0, longest: 0);
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(habit.name),
                        subtitle: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${streak.current} day streak',
                                style: const TextStyle(
                                  color: Color(0xFF2E7D6B),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '   •   Longest: ${streak.longest} days'),
                            ],
                          ),
                        ),
                        onTap: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => CheckInScreen(habit: habit)),
                          );
                          if (updated == true) loadData();
                        },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.bolt,
                                color: Colors.orange),
                            tooltip: 'Log urge',
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        LogUrgeScreen(
                                            habit: habit)),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.bar_chart,
                                color: Colors.blue),
                            tooltip: 'Stats',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        StatsScreen(
                                            habit: habit)),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            tooltip: 'Delete habit',
                            onPressed: () => confirmDelete(habit),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
          if (added == true) loadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}