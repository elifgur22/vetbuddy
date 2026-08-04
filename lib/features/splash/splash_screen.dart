import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          child: Column(
            children: [
              const Spacer(),

              Image.asset(
                'assets/images/logo.png',
                width: 230,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 24),

              const Text(
                'VetBuddy',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Your AI Pet Health Assistant',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
  ),
  child: const Text(
    'Get Started',
    style: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w600,
    ),
  ),
),
              ),
            ],
          ),
        ),
      ),
    );
  }
}