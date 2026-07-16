// lib/screens/add_habit_screen.dart

import 'package:flutter/material.dart';
import 'package:habittrack/db/database_helper.dart';
import 'package:habittrack/models/habit.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> saveHabit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => isSaving = true);

    final habit = Habit(name: name, createdAt: DateTime.now());
    await DatabaseHelper.instance.insertHabit(habit);

    if (mounted) {
      Navigator.pop(context, true); // true = "a habit was added"
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Habit')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Habit name',
                hintText: 'e.g. No smoking',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isSaving ? null : saveHabit,
              child: isSaving
                  ? const SizedBox(
                  height: 20, width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}