import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;
  const LockScreen({super.key, required this.onUnlocked});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool isAuthenticating = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    tryAuthenticate();
  }

  Future<void> tryAuthenticate() async {
    setState(() {
      isAuthenticating = true;
      errorMessage = null;
    });

    bool authenticated = false;
    try {
      final canCheck =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (!canCheck) {
        authenticated = true; // no biometrics on this device — let them in
      } else {
        authenticated = await auth.authenticate(
          localizedReason: 'Unlock your habit tracker',
          biometricOnly: true,
          persistAcrossBackgrounding: true,
        );
      }
    } catch (e) {
      authenticated = false;
      errorMessage = 'Authentication failed. Try again.';
    }

    if (!mounted) return;

    if (authenticated) {
      widget.onUnlocked();
    } else {
      setState(() => isAuthenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fingerprint, size: 72, color: Color(0xFF2E7D6B)),
            const SizedBox(height: 16),
            const Text(
              'Habit Tracker',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E4D42),
              ),
            ),
            const SizedBox(height: 24),
            if (errorMessage != null) ...[
              Text(errorMessage!, style: const TextStyle(color: Colors.redAccent)),
              const SizedBox(height: 16),
            ],
            isAuthenticating
                ? const CircularProgressIndicator(color: Color(0xFF2E7D6B))
                : ElevatedButton.icon(
              onPressed: tryAuthenticate,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Unlock'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D6B),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}