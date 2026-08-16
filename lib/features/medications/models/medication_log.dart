class MedicationLog {
  final int id;
  final int medicationId;
  final String medicationName;
  final String dose;
  final DateTime scheduledAt;
  final DateTime? givenAt;
  final String status;

  const MedicationLog({
    required this.id,
    required this.medicationId,
    required this.medicationName,
    required this.dose,
    required this.scheduledAt,
    this.givenAt,
    required this.status,
  });

  factory MedicationLog.fromJson(Map<String, dynamic> json) {
    return MedicationLog(
      id: json['id'],
      medicationId: json['medicationId'],
      medicationName: json['medicationName'] ?? '',
      dose: json['dose'] ?? '',
      scheduledAt: DateTime.parse(json['scheduledAt']),
      givenAt: json['givenAt'] == null
          ? null
          : DateTime.parse(json['givenAt']),
      status: json['status'] ?? 'PENDING',
    );
  }
}