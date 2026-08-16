import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'add_medication_screen.dart';
import 'models/medication.dart';
import 'services/medication_api_service.dart';

class MedicationListScreen extends StatefulWidget {
  final int petId;

  const MedicationListScreen({super.key, required this.petId});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  final MedicationApiService medicationApiService = MedicationApiService();

  List<Medication> medications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMedications();
  }

  Future<void> loadMedications() async {
    try {
      final result = await medicationApiService.getMedications(widget.petId);

      if (!mounted) {
        return;
      }

      setState(() {
        medications = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load medications: $e')));
    }
  }

  Future<void> addMedication() async {
    final medication = await Navigator.push<Medication>(
      context,
      MaterialPageRoute(builder: (context) => const AddMedicationScreen()),
    );

    if (medication == null) {
      return;
    }

    try {
      await medicationApiService.createMedication(widget.petId, medication);

      await loadMedications();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save medication: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Medications',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : medications.isEmpty
          ? const Center(
              child: Text(
                'No medications added yet.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: medications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                      style: const TextStyle(fontWeight: FontWeight.w700),
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
