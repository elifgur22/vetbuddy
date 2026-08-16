import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../models/medication.dart';

class MedicationApiService {
  Future<List<Medication>> getMedications(
    int petId,
  ) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.baseUrl}/pets/$petId/medications',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load medications: ${response.body}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map(
          (json) => Medication.fromJson(json),
        )
        .toList();
  }

  Future<Medication> createMedication(
    int petId,
    Medication medication,
  ) async {
    final response = await http.post(
      Uri.parse(
        '${ApiConstants.baseUrl}/pets/$petId/medications',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        medication.toJson(),
      ),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Failed to create medication: ${response.body}',
      );
    }

    return Medication.fromJson(
      jsonDecode(response.body),
    );
  }
}