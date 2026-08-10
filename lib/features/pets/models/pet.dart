class Pet {
  final String name;
  final String type;
  final String breed;
  final String gender;
  final double? weight;
  final bool isNeutered;

  const Pet({
    required this.name,
    required this.type,
    required this.breed,
    required this.gender,
    this.weight,
    required this.isNeutered,
  });
}
