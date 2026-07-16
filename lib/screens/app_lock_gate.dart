import 'package:flutter/material.dart';
import 'package:habittrack/screens/lock_screen.dart';
import 'package:habittrack/screens/homescreen.dart';

class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key});

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate>
    with WidgetsBindingObserver {
  bool isLocked = true; // locked on first launch

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      setState(() => isLocked = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLocked
        ? LockScreen(onUnlocked: () => setState(() => isLocked = false))
        : const HomeScreen();
  }
}