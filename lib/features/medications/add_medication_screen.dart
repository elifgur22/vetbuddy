import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'models/medication.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() =>
      _AddMedicationScreenState();
}

class _AddMedicationScreenState
    extends State<AddMedicationScreen> {
  final nameController = TextEditingController();
  final doseController = TextEditingController();
  final notesController = TextEditingController();

  DateTime startDate = DateTime.now();
  DateTime? endDate;

  final List<TimeOfDay> selectedTimes = [];

  @override
  void dispose() {
    nameController.dispose();
    doseController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        startDate = date;
      });
    }
  }

  Future<void> selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate,
      firstDate: startDate,
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        endDate = date;
      });
    }
  }

  Future<void> addTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTimes.add(time);
      });
    }
  }

  void saveMedication() {
    if (nameController.text.trim().isEmpty ||
        doseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter medication name and dose.'),
        ),
      );
      return;
    }

    if (selectedTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one medication time.'),
        ),
      );
      return;
    }

    final medication = Medication(
      name: nameController.text.trim(),
      dose: doseController.text.trim(),
      startDate: startDate,
      endDate: endDate,
      times: selectedTimes
          .map(
            (time) =>
                '${time.hour.toString().padLeft(2, '0')}:'
                '${time.minute.toString().padLeft(2, '0')}',
          )
          .toList(),
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
    );

    Navigator.pop(context, medication);
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
          'Add Medication',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Medication Name',
              prefixIcon: Icon(Icons.medication_outlined),
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            controller: doseController,
            decoration: const InputDecoration(
              labelText: 'Dose',
              hintText: 'For example: 1/4 tablet',
              prefixIcon: Icon(Icons.medical_information_outlined),
            ),
          ),
          const SizedBox(height: 18),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.primary,
            ),
            title: const Text('Start Date'),
            subtitle: Text(formatDate(startDate)),
            trailing: const Icon(Icons.chevron_right),
            onTap: selectStartDate,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.event_outlined,
              color: AppColors.primary,
            ),
            title: const Text('End Date'),
            subtitle: Text(
              endDate == null
                  ? 'Not selected'
                  : formatDate(endDate!),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: selectEndDate,
          ),
          const SizedBox(height: 18),
          const Text(
            'Medication Times',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ...selectedTimes.map(
                (time) => Chip(
                  label: Text(time.format(context)),
                ),
              ),
              ActionChip(
                avatar: const Icon(Icons.add),
                label: const Text('Add Time'),
                onPressed: addTime,
              ),
            ],
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
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: saveMedication,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Save Medication',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}