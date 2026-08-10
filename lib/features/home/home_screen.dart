import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onAddPet;

  const HomeScreen({
    super.key,
    this.onAddPet,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // APP BAR
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'VetBuddy',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Notification screen will be added later.
            },
            icon: const Icon(
              Icons.notifications_outlined,
            ),
          ),
        ],
      ),

      // BODY
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Hello 👋',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'How is your pet today?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 28),

          // PET CARD
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.pets,
                  color: Colors.white,
                  size: 34,
                ),

                SizedBox(height: 18),

                Text(
                  'Add your first pet',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Create a profile to track health, weight and reminders.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // QUICK ACTIONS
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              // ADD PET
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.add,
                  title: 'Add Pet',
                  onTap: onAddPet ?? () {},
                ),
              ),

              const SizedBox(width: 14),

              // AI
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.smart_toy_outlined,
                  title: 'Ask AI',
                  onTap: () {
                    // AI navigation will be added later.
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}