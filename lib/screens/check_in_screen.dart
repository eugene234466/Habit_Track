// lib/screens/check_in_screen.dart

import 'package:flutter/material.dart';
import 'package:habittrack/db/database_helper.dart';
import 'package:habittrack/models/habit.dart';
import 'package:habittrack/models/check_in.dart';
import 'package:habittrack/logic/streak_calculator.dart';

class CheckInScreen extends StatefulWidget {
  final Habit habit;
  const CheckInScreen({super.key, required this.habit});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final TextEditingController _noteController = TextEditingController();
  bool isSaving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> logStatus(String status) async {
    setState(() => isSaving = true);

    final checkIn = CheckIn(
      habitId: widget.habit.id!,
      createdAt: DateTime.now(),
      status: status,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );
    await DatabaseHelper.instance.insertCheckIn(checkIn);

    // recalculate streaks fresh, check for a milestone
    final checkIns =
    await DatabaseHelper.instance.getCheckInsForHabit(widget.habit.id!);
    final streaks = calculateStreaks(checkIns);
    final milestone = checkMilestone(streaks.current);

    if (!mounted) return;

    if (milestone != null) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFFF7F5F0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(Icons.emoji_events, color: Color(0xFF2E7D6B), size: 40),
          title: const Text(
            'Milestone!',
            style: TextStyle(color: Color(0xFF2E4D42), fontWeight: FontWeight.bold),
          ),
          content: Text(
            '$milestone day streak — keep going.',
            style: const TextStyle(color: Color(0xFF2E4D42)),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D6B),
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Keep going'),
            ),
          ],
        ),
      );
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.habit.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('How did today go?',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isSaving ? null : () => logStatus('success'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Stayed strong today'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: isSaving ? null : () => logStatus('slip'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF8A6D3B), // muted amber, not red
                side: const BorderSide(color: Color(0xFF8A6D3B)),
              ),
              child: const Text('I slipped'),
            ),
          ],
        ),
      ),
    );
  }
}