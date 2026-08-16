import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../models/vaccination.dart';

class VaccinationApiService {
  Future<List<Vaccination>> getVaccinations(int petId) async {
    final response = await http.get(
      Uri.parse(
        '${ApiConstants.baseUrl}/pets/$petId/vaccinations',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load vaccinations: ${response.body}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map(
          (json) => Vaccination.fromJson(json),
        )
        .toList();
  }

  Future<Vaccination> createVaccination(
    int petId,
    Vaccination vaccination,
  ) async {
    final response = await http.post(
      Uri.parse(
        '${ApiConstants.baseUrl}/pets/$petId/vaccinations',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        vaccination.toJson(),
      ),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Failed to create vaccination: ${response.body}',
      );
    }

    return Vaccination.fromJson(
      jsonDecode(response.body),
    );
  }
}