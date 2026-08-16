class Vaccination {
  final int? id;
  final int? petId;
  final String name;
  final DateTime vaccinationDate;
  final DateTime? nextDoseDate;
  final String? veterinarian;
  final String? notes;
  final bool completed;

  const Vaccination({
    this.id,
    this.petId,
    required this.name,
    required this.vaccinationDate,
    this.nextDoseDate,
    this.veterinarian,
    this.notes,
    required this.completed,
  });

  factory Vaccination.fromJson(
    Map<String, dynamic> json,
  ) {
    return Vaccination(
      id: json['id'],
      petId: json['petId'],
      name: json['name'] ?? '',
      vaccinationDate: DateTime.parse(
        json['vaccinationDate'],
      ),
      nextDoseDate: json['nextDoseDate'] == null
          ? null
          : DateTime.parse(json['nextDoseDate']),
      veterinarian: json['veterinarian'],
      notes: json['notes'],
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'vaccinationDate':
          vaccinationDate.toIso8601String().split('T').first,
      'nextDoseDate': nextDoseDate
          ?.toIso8601String()
          .split('T')
          .first,
      'veterinarian': veterinarian,
      'notes': notes,
      'completed': completed,
    };
  }
}