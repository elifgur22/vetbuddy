import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../pets/models/pet.dart';
import '../pets/services/pet_api_service.dart';

import '../medications/models/medication_log.dart';
import '../medications/services/medication_log_api_service.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onAddPet;

  const HomeScreen({super.key, this.onAddPet});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedMood;

  final List<Map<String, dynamic>> moods = [
    {'label': 'Great', 'icon': Icons.sentiment_very_satisfied_rounded},
    {'label': 'Okay', 'icon': Icons.sentiment_neutral_rounded},
    {'label': 'Tired', 'icon': Icons.bedtime_outlined},
    {'label': 'Sick', 'icon': Icons.sick_outlined},
  ];

  final PetApiService petApiService = PetApiService();
  final MedicationLogApiService medicationLogApiService =
      MedicationLogApiService();

  Pet? selectedPet;
  List<MedicationLog> todayLogs = [];

  bool isCareLoading = true;

  @override
  void initState() {
    super.initState();
    loadTodayCare();
  }

  Future<void> loadTodayCare() async {
    try {
      final pets = await petApiService.getPets();

      if (pets.isEmpty) {
        if (!mounted) {
          return;
        }

        setState(() {
          isCareLoading = false;
        });

        return;
      }

      final pet = pets.first;

      await medicationLogApiService.createDailyLogs(pet.id!, DateTime.now());

      final logs = await medicationLogApiService.getDailyLogs(
        pet.id!,
        DateTime.now(),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        selectedPet = pet;
        todayLogs = logs;
        isCareLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isCareLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Couldn't load today's care: $e")));
    }
  }

  String formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'VetBuddy',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Notifications screen later.
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Hello',
            style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
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

          // DAILY CHECK-IN
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Color(0xFFE6FFFB),
                      child: Icon(
                        Icons.pets,
                        color: AppColors.primary,
                        size: 29,
                      ),
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Check-in',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'How is your pet feeling today?',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: moods.map((mood) {
                    final label = mood['label'] as String;
                    final icon = mood['icon'] as IconData;
                    final selected = selectedMood == label;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedMood = label;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary.withValues(alpha: 0.15)
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : const Color(0xFFE2E8F0),
                                width: selected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  icon,
                                  size: 28,
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                if (selectedMood != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    '$selectedMood check-in saved for today ✨',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 28),

          // TODAY'S CARE
          const Text(
            "Today's Care",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          if (isCareLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (selectedPet == null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Text(
                'Add a pet to start your daily care plan.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          else if (todayLogs.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Text(
                '${selectedPet!.name} has no medication scheduled today ✨',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: List.generate(todayLogs.length, (index) {
                  final log = todayLogs[index];

                  return Column(
                    children: [
                      _CareItem(
                        icon: Icons.medication_outlined,
                        title: log.medicationName,
                        subtitle:
                            '${formatTime(log.scheduledAt)} • ${log.dose}',
                        status: log.status,
                        onGiven: () async {
                          await medicationLogApiService.markGiven(log.id);

                          await loadTodayCare();
                        },
                        onMissed: () async {
                          await medicationLogApiService.markMissed(log.id);

                          await loadTodayCare();
                        },
                      ),

                      if (index != todayLogs.length - 1)
                        const Divider(height: 28),
                    ],
                  );
                }),
              ),
            ),
          const SizedBox(height: 24),

          // CARE STREAK
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Text('🔥', style: TextStyle(fontSize: 36)),

                SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Care Streak',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Keep taking great care of your buddy!',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                Text(
                  '3 days',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
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
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.add,
                  title: 'Add Pet',
                  onTap: widget.onAddPet ?? () {},
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: _QuickActionCard(
                  icon: Icons.smart_toy_outlined,
                  title: 'Ask AI',
                  onTap: () {
                    // AI navigation later.
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

class _CareItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String status;
  final VoidCallback? onGiven;
  final VoidCallback? onMissed;

  const _CareItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.status,
    this.onGiven,
    this.onMissed,
  });

  @override
  Widget build(BuildContext context) {
    final isGiven = status == 'GIVEN';
    final isMissed = status == 'MISSED';

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  decoration: isGiven ? TextDecoration.lineThrough : null,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        if (isGiven)
          const Icon(Icons.check_circle, color: AppColors.primary)
        else if (isMissed)
          const Icon(Icons.cancel_outlined, color: Colors.redAccent)
        else
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'given') {
                onGiven?.call();
              }

              if (value == 'missed') {
                onMissed?.call();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'given', child: Text('Given ✓')),
              PopupMenuItem(value: 'missed', child: Text('Missed')),
            ],
            icon: const Icon(Icons.more_horiz),
          ),
      ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
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
