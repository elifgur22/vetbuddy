import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../models/medication_log.dart';

class MedicationLogApiService {
  String formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> createDailyLogs(
    int petId,
    DateTime date,
  ) async {
    final formattedDate = formatDate(date);

    final response = await http.post(
      Uri.parse(
        '${ApiConstants.baseUrl}/pets/$petId/medication-logs'
        '?date=$formattedDate',
      ),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Failed to create medication logs: ${response.body}',
      );
    }
  }

  Future<List<MedicationLog>> getDailyLogs(
    int petId,
    DateTime date,
  ) async {
    final formattedDate = formatDate(date);

    final response = await http.get(
      Uri.parse(
        '${ApiConstants.baseUrl}/pets/$petId/medication-logs'
        '?date=$formattedDate',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load medication logs: ${response.body}',
      );
    }

    final List<dynamic> data = jsonDecode(response.body);

    return data
        .map(
          (json) => MedicationLog.fromJson(json),
        )
        .toList();
  }

  Future<MedicationLog> markGiven(int logId) async {
    final response = await http.patch(
      Uri.parse(
        '${ApiConstants.baseUrl}/medication-logs/$logId/given',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to mark medication as given',
      );
    }

    return MedicationLog.fromJson(
      jsonDecode(response.body),
    );
  }

  Future<MedicationLog> markMissed(int logId) async {
    final response = await http.patch(
      Uri.parse(
        '${ApiConstants.baseUrl}/medication-logs/$logId/missed',
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to mark medication as missed',
      );
    }

    return MedicationLog.fromJson(
      jsonDecode(response.body),
    );
  }
}