class Medication {
  final int? id;
  final int? petId;
  final String name;
  final String dose;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> times;
  final String? notes;

  const Medication({
    this.id,
    this.petId,
    required this.name,
    required this.dose,
    required this.startDate,
    this.endDate,
    required this.times,
    this.notes,
  });

  factory Medication.fromJson(
    Map<String, dynamic> json,
  ) {
    return Medication(
      id: json['id'],
      petId: json['petId'],
      name: json['name'] ?? '',
      dose: json['dose'] ?? '',
      startDate: DateTime.parse(
        json['startDate'],
      ),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate']),
      times: List<String>.from(
        json['times'] ?? [],
      ),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dose': dose,
      'startDate':
          startDate.toIso8601String().split('T').first,
      'endDate':
          endDate?.toIso8601String().split('T').first,
      'times': times,
      'notes': notes,
    };
  }
}