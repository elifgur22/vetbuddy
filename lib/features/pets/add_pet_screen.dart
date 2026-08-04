import 'package:flutter/material.dart';

class AddPetScreen extends StatelessWidget {
  const AddPetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Pet'),
      ),
      body: const Center(
        child: Text('Add Pet Screen'),
      ),
    );
  }
}