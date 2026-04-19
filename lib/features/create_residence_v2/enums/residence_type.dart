enum ResidenceType {
  appartement('appartement', 'Appartement', 'building-user-solid'),
  maison('maison', 'Duplex', 'cottage'),
  villa('villa', 'Villa', 'villa');

  final String value;
  final String label;
  final String iconKey;

  const ResidenceType(this.value, this.label, this.iconKey);
}
