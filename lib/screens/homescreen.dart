// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:habittrack/db/database_helper.dart';
import 'package:habittrack/models/habit.dart';
import 'package:habittrack/logic/streak_calculator.dart';
import 'package:habittrack/logic/scripture_provider.dart';

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
              margin: const EdgeInsets.all(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  getTodaysScripture(),
                  style: const TextStyle(fontStyle: FontStyle.italic),
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
                      subtitle: Text(
                          'Current streak: ${streak.current} days   •   Longest: ${streak.longest} days'),
                      onTap: () {
                        // TODO: navigate to habit detail screen
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: navigate to add-habit screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}