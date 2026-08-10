import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'models/vaccination.dart';

class AddVaccinationScreen extends StatefulWidget {
  const AddVaccinationScreen({super.key});

  @override
  State<AddVaccinationScreen> createState() => _AddVaccinationScreenState();
}

class _AddVaccinationScreenState extends State<AddVaccinationScreen> {
  final nameController = TextEditingController();
  final veterinarianController = TextEditingController();
  final notesController = TextEditingController();

  DateTime vaccinationDate = DateTime.now();
  DateTime? nextDoseDate;

  bool completed = true;

  @override
  void dispose() {
    nameController.dispose();
    veterinarianController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> selectVaccinationDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: vaccinationDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        vaccinationDate = date;
      });
    }
  }

  Future<void> selectNextDoseDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          nextDoseDate ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        nextDoseDate = date;
      });
    }
  }

  void saveVaccination() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter vaccine name.')),
      );
      return;
    }

    final vaccination = Vaccination(
      name: nameController.text.trim(),
      vaccinationDate: vaccinationDate,
      nextDoseDate: nextDoseDate,
      veterinarian: veterinarianController.text.trim().isEmpty
          ? null
          : veterinarianController.text.trim(),
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
      completed: completed,
    );

    Navigator.pop(context, vaccination);
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Add Vaccination',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Vaccine Name',
                prefixIcon: Icon(Icons.vaccines_outlined),
              ),
            ),

            const SizedBox(height: 18),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Vaccination Date'),
              subtitle: Text(formatDate(vaccinationDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: selectVaccinationDate,
            ),

            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.notifications_active_outlined,
                color: AppColors.primary,
              ),
              title: const Text('Next Dose Date'),
              subtitle: Text(
                nextDoseDate == null
                    ? 'Not selected'
                    : formatDate(nextDoseDate!),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: selectNextDoseDate,
            ),

            const SizedBox(height: 18),

            TextField(
              controller: veterinarianController,
              decoration: const InputDecoration(
                labelText: 'Veterinarian',
                prefixIcon: Icon(Icons.local_hospital_outlined),
              ),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes',
                prefixIcon: Icon(Icons.notes_outlined),
              ),
            ),

            const SizedBox(height: 16),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Vaccination completed'),
              value: completed,
              activeThumbColor: AppColors.primary,
              onChanged: (value) {
                setState(() {
                  completed = value;
                });
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: saveVaccination,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Save Vaccination',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
