// lib/presentation/pages/splash/splash_page.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../core/services/preference_service.dart';
import 'package:flutter/foundation.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    try {
      if (kDebugMode) {
        print('Starting splash screen initialization...');
      }

      // Add a minimum splash screen duration
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) {
        if (kDebugMode) {
          print('Widget not mounted after delay');
        }
        return;
      }

      final preferencesService = GetIt.I<PreferencesService>();

      if (kDebugMode) {
        print('Checking onboarding status...');
      }

      final isOnboardingCompleted =
          await preferencesService.isOnboardingCompleted();

      if (!mounted) {
        if (kDebugMode) {
          print('Widget not mounted after preferences check');
        }
        return;
      }

      if (kDebugMode) {
        print('Onboarding completed: $isOnboardingCompleted');
      }

      if (isOnboardingCompleted) {
        if (kDebugMode) {
          print('Navigating to home page...');
        }
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        if (kDebugMode) {
          print('Navigating to onboarding page...');
        }
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error during initialization: $e');
        print('Stack trace: $stackTrace');
      }

      if (!mounted) return;

      // Show an error dialog to the user
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/onboarding');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
