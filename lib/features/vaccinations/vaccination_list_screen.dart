import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'add_vaccination_screen.dart';
import 'models/vaccination.dart';
import 'services/vaccination_api_service.dart';

class VaccinationListScreen extends StatefulWidget {
  final int petId;

  const VaccinationListScreen({super.key, required this.petId});

  @override
  State<VaccinationListScreen> createState() => _VaccinationListScreenState();
}

class _VaccinationListScreenState extends State<VaccinationListScreen> {
  final VaccinationApiService vaccinationApiService = VaccinationApiService();

  List<Vaccination> vaccinations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadVaccinations();
  }

  Future<void> loadVaccinations() async {
    try {
      final result = await vaccinationApiService.getVaccinations(widget.petId);

      if (!mounted) {
        return;
      }

      setState(() {
        vaccinations = result;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load vaccinations: $e')),
      );
    }
  }

  Future<void> addVaccination() async {
    final vaccination = await Navigator.push<Vaccination>(
      context,
      MaterialPageRoute(builder: (context) => const AddVaccinationScreen()),
    );

    if (vaccination == null) {
      return;
    }

    try {
      await vaccinationApiService.createVaccination(widget.petId, vaccination);

      await loadVaccinations();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save vaccination: $e')));
    }
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = vaccinations
        .where(
          (v) =>
              v.nextDoseDate != null && v.nextDoseDate!.isAfter(DateTime.now()),
        )
        .toList();

    final history = vaccinations.where((v) => v.completed).toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Vaccinations',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text(
                  'Upcoming',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 14),

                if (upcoming.isEmpty)
                  const Text(
                    'No upcoming vaccinations.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),

                ...upcoming.map(
                  (vaccination) => Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFE6FFFB),
                        child: Icon(
                          Icons.notifications_active_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(vaccination.name),
                      subtitle: Text(
                        'Next: ${formatDate(vaccination.nextDoseDate!)}',
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Vaccination History',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 14),

                if (history.isEmpty)
                  const Text(
                    'No vaccination history yet.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),

                ...history.map(
                  (vaccination) => Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFE6FFFB),
                        child: Icon(
                          Icons.vaccines_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(vaccination.name),
                      subtitle: Text(formatDate(vaccination.vaccinationDate)),
                      trailing: const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addVaccination,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Vaccine'),
      ),
    );
  }
}
