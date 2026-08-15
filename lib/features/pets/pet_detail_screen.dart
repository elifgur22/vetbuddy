import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'models/pet.dart';

import '../vaccinations/vaccination_list_screen.dart';
import '../medications/medication_list_screen.dart';

class PetDetailScreen extends StatelessWidget {
  final Pet pet;

  const PetDetailScreen({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          pet.name,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: CircleAvatar(
              radius: 55,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: const Icon(Icons.pets, size: 52, color: AppColors.primary),
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              pet.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              pet.breed.isEmpty ? pet.type : '${pet.type} • ${pet.breed}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),

          const SizedBox(height: 32),

          _InfoCard(
            title: 'Gender',
            value: pet.gender,
            icon: Icons.wc_outlined,
          ),

          _InfoCard(
            title: 'Weight',
            value: pet.weight == null ? 'Not added' : '${pet.weight} kg',
            icon: Icons.monitor_weight_outlined,
          ),

          _InfoCard(
            title: 'Neutered',
            value: pet.isNeutered ? 'Yes' : 'No',
            icon: Icons.health_and_safety_outlined,
          ),
          const SizedBox(height: 20),

          const SizedBox(height: 24),

          const Text(
            'Health',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(height: 14),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VaccinationListScreen(),
                ),
              );
            },
            icon: const Icon(Icons.vaccines_outlined),
            label: const Text('Vaccinations'),
          ),

          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MedicationListScreen(),
                ),
              );
            },
            icon: const Icon(Icons.medication_outlined),
            label: const Text('Medications'),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
