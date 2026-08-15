class PetAssetHelper {
  static String getAsset(String type) {
    switch (type.toLowerCase()) {
      case 'cat':
        return 'assets/images/pets/cat.png';

      case 'dog':
        return 'assets/images/pets/dog.png';

      case 'rabbit':
        return 'assets/images/pets/rabbit.png';

      case 'bird':
        return 'assets/images/pets/bird.png';

      case 'hamster':
        return 'assets/images/pets/hamster.png';

      case 'guinea pig':
        return 'assets/images/pets/guinea_pig.png';

      case 'fish':
        return 'assets/images/pets/fish.png';

      case 'turtle':
        return 'assets/images/pets/turtle.png';

      case 'reptile':
        return 'assets/images/pets/reptile.png';

      default:
        return 'assets/images/pets/other.png';
    }
  }
}