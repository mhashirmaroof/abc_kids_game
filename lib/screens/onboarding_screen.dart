import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.yellow),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo placeholder
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(AppColors.blue),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Center(
                  child: Text('ABC', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              )
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut),

              const SizedBox(height: 24),

              Text(
                AppStrings.appName,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(delay: 400.ms),

              const SizedBox(height: 48),

              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(AppColors.green),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(260, 80),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                child: const Text('Tap to Start! 🎉'),
              )
              .animate()
              .fadeIn(delay: 700.ms)
              .slideY(begin: 0.3),
            ],
          ),
        ),
      ),
    );
  }
}
