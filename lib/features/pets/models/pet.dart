class Pet {
  final int? id;
  final String name;
  final String type;
  final String breed;
  final String gender;
  final DateTime? birthDate;
  final double? weight;
  final bool isNeutered;
  final String? photoUrl;

  const Pet({
    this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.gender,
    this.birthDate,
    this.weight,
    required this.isNeutered,
    this.photoUrl,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      breed: json['breed'] ?? '',
      gender: json['gender'] ?? '',
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate']),
      weight: json['weight'] == null
          ? null
          : (json['weight'] as num).toDouble(),
      isNeutered: json['neutered'] ?? false,
      photoUrl: json['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'breed': breed,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String().split('T').first,
      'weight': weight,
      'neutered': isNeutered,
      'photoUrl': photoUrl,
    };
  }
}