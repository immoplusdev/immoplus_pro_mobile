enum EstateType {
  appartement('appartement', 'Appartement', 'building-user-solid'),
  maison('maison', 'Duplex', 'cottage'),
  villa('villa', 'Villa', 'villa'),
  studio('studio', 'Studio', 'studio'),
  bureau('bureau', 'Bureau', 'bureau'),
  terrain('terrain', 'Terrain', 'land');

  final String value;
  final String label;
  final String iconKey;

  const EstateType(this.value, this.label, this.iconKey);
}
