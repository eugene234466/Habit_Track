// lib/screens/log_urge_screen.dart

import 'package:flutter/material.dart';
import 'package:habittrack/db/database_helper.dart';
import 'package:habittrack/models/habit.dart';
import 'package:habittrack/models/urge.dart';

class LogUrgeScreen extends StatefulWidget {
  final Habit habit;
  const LogUrgeScreen({super.key, required this.habit});

  @override
  State<LogUrgeScreen> createState() => _LogUrgeScreenState();
}

class _LogUrgeScreenState extends State<LogUrgeScreen> {
  final TextEditingController _triggerController = TextEditingController();
  int intensity = 3;
  bool isSaving = false;

  @override
  void dispose() {
    _triggerController.dispose();
    super.dispose();
  }

  Future<void> saveUrge() async {
    setState(() => isSaving = true);

    final urge = Urge(
      habitId: widget.habit.id!,
      timestamp: DateTime.now(),
      intensity: intensity,
      triggerNote: _triggerController.text.trim().isEmpty
          ? null
          : _triggerController.text.trim(),
    );
    await DatabaseHelper.instance.insertUrge(urge);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Log Urge — ${widget.habit.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('How strong is it?', style: TextStyle(fontSize: 18)),
            Slider(
              value: intensity.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: intensity.toString(),
              onChanged: (val) => setState(() => intensity = val.round()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _triggerController,
              decoration: const InputDecoration(
                labelText: 'What triggered it? (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving ? null : saveUrge,
              child: const Text('Log Urge'),
            ),
          ],
        ),
      ),
    );
  }
}