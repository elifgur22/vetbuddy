import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'add_medication_screen.dart';
import 'medication.dart';

class MedicationListScreen extends StatefulWidget {
  const MedicationListScreen({super.key});

  @override
  State<MedicationListScreen> createState() =>
      _MedicationListScreenState();
}

class _MedicationListScreenState
    extends State<MedicationListScreen> {
  final List<Medication> medications = [];

  Future<void> addMedication() async {
    final medication = await Navigator.push<Medication>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddMedicationScreen(),
      ),
    );

    if (medication != null) {
      setState(() {
        medications.add(medication);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Medications',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: medications.isEmpty
          ? const Center(
              child: Text(
                'No medications added yet.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: medications.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final medication = medications[index];

                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE6FFFB),
                      child: Icon(
                        Icons.medication_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      medication.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    subtitle: Text(
                      '${medication.dose}\n${medication.times.join(', ')}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addMedication,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Medication'),
      ),
    );
  }
}