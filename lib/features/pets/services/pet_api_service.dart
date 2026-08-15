import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../models/pet.dart';

class PetApiService {
  Future<List<Pet>> getPets() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/pets'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load pets');
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map((json) => Pet.fromJson(json))
        .toList();
  }

  Future<Pet> createPet(Pet pet) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/pets'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(pet.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Failed to create pet: ${response.body}',
      );
    }

    return Pet.fromJson(
      jsonDecode(response.body),
    );
  }
}