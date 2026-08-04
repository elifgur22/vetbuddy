import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const VetBuddyApp());
}

class VetBuddyApp extends StatelessWidget {
  const VetBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VetBuddy',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}