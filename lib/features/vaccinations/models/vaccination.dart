class Vaccination {
  final String name;
  final DateTime vaccinationDate;
  final DateTime? nextDoseDate;
  final String? veterinarian;
  final String? notes;
  final bool completed;

  const Vaccination({
    required this.name,
    required this.vaccinationDate,
    this.nextDoseDate,
    this.veterinarian,
    this.notes,
    required this.completed,
  });
}
