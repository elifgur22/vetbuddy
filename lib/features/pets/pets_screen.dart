import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/pet_asset_helper.dart';

import 'add_pet_screen.dart';
import 'models/pet.dart';
import 'pet_detail_screen.dart';
import 'services/pet_api_service.dart';

class PetsScreen extends StatefulWidget {
  const PetsScreen({super.key});

  @override
  State<PetsScreen> createState() => _PetsScreenState();
}

class _PetsScreenState extends State<PetsScreen> {
  final PetApiService petApiService = PetApiService();

  List<Pet> pets = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPets();
  }

  Future<void> loadPets() async {
    try {
      final result = await petApiService.getPets();

      if (!mounted) {
        return;
      }

      setState(() {
        pets = result;
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
      ).showSnackBar(SnackBar(content: Text('Failed to load pets: $e')));
    }
  }

  Future<void> addPet() async {
    final pet = await Navigator.push<Pet>(
      context,
      MaterialPageRoute(builder: (context) => const AddPetScreen()),
    );

    if (pet == null) {
      return;
    }

    try {
      await petApiService.createPet(pet);

      await loadPets();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save pet: $e')));
    }
  }

  void openPetDetail(Pet pet) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetDetailScreen(pet: pet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Pets',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      // BODY
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pets.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.pets_outlined,
                      size: 70,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No pets yet',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Add your first pet to start tracking health, vaccinations and medications.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: addPet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Add Your First Pet'),
                    ),
                  ],
                ),
              ),
            )
          : RefreshIndicator(
              onRefresh: loadPets,
              child: ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount: pets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final pet = pets[index];

                  return InkWell(
                    onTap: () {
                      openPetDetail(pet);
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.12,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(
                                PetAssetHelper.getAsset(pet.type),
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.pets,
                                    color: AppColors.primary,
                                    size: 34,
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pet.name,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  pet.breed.isEmpty ? pet.type : pet.breed,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${pet.weight == null ? 'Weight not added' : '${pet.weight} kg'} • ${pet.gender}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

      // ADD PET BUTTON
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: addPet,
        icon: const Icon(Icons.add),
        label: const Text('Add Pet'),
      ),
    );
  }
}
