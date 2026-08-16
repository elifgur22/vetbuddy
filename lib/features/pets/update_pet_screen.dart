import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import 'models/pet.dart';

class UpdatePetScreen extends StatefulWidget {
  final Pet pet;

  const UpdatePetScreen({
    super.key,
    required this.pet,
  });

  @override
  State<UpdatePetScreen> createState() => _UpdatePetScreenState();
}

class _UpdatePetScreenState extends State<UpdatePetScreen> {
  late final TextEditingController nameController;
  late final TextEditingController breedController;
  late final TextEditingController weightController;

  late String selectedType;
  late String selectedGender;
  late bool isNeutered;

  final List<String> petTypes = [
    'Cat',
    'Dog',
    'Rabbit',
    'Bird',
    'Hamster',
    'Guinea Pig',
    'Fish',
    'Turtle',
    'Reptile',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.pet.name,
    );

    breedController = TextEditingController(
      text: widget.pet.breed,
    );

    weightController = TextEditingController(
      text: widget.pet.weight?.toString() ?? '',
    );

    selectedType = widget.pet.type;
    selectedGender = widget.pet.gender;
    isNeutered = widget.pet.isNeutered;
  }

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void savePet() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your pet name.'),
        ),
      );
      return;
    }

    final updatedPet = Pet(
      id: widget.pet.id,
      name: nameController.text.trim(),
      type: selectedType,
      breed: breedController.text.trim(),
      gender: selectedGender,
      birthDate: widget.pet.birthDate,
      weight: double.tryParse(
        weightController.text.trim(),
      ),
      isNeutered: isNeutered,
      photoUrl: widget.pet.photoUrl,
    );

    Navigator.pop(
      context,
      updatedPet,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Edit Pet',
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
              labelText: 'Pet Name',
            ),
          ),

          const SizedBox(height: 18),

          DropdownButtonFormField<String>(
            initialValue: selectedType,
            decoration: const InputDecoration(
              labelText: 'Pet Type',
            ),
            items: petTypes
                .map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedType = value;
                });
              }
            },
          ),

          const SizedBox(height: 18),

          TextField(
            controller: breedController,
            decoration: const InputDecoration(
              labelText: 'Breed',
            ),
          ),

          const SizedBox(height: 18),

          DropdownButtonFormField<String>(
            initialValue: selectedGender,
            decoration: const InputDecoration(
              labelText: 'Gender',
            ),
            items: const [
              DropdownMenuItem(
                value: 'Male',
                child: Text('Male'),
              ),
              DropdownMenuItem(
                value: 'Female',
                child: Text('Female'),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  selectedGender = value;
                });
              }
            },
          ),

          const SizedBox(height: 18),

          TextField(
            controller: weightController,
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
            decoration: const InputDecoration(
              labelText: 'Weight',
              suffixText: 'kg',
            ),
          ),

          const SizedBox(height: 12),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'Neutered',
            ),
            value: isNeutered,
            activeThumbColor: AppColors.primary,
            onChanged: (value) {
              setState(() {
                isNeutered = value;
              });
            },
          ),

          const SizedBox(height: 28),

          ElevatedButton(
            onPressed: savePet,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}