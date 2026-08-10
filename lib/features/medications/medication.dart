class Medication {
  final String name;
  final String dose;
  final DateTime startDate;
  final DateTime? endDate;
  final List<String> times;
  final String? notes;

  const Medication({
    required this.name,
    required this.dose,
    required this.startDate,
    this.endDate,
    required this.times,
    this.notes,
  });
}