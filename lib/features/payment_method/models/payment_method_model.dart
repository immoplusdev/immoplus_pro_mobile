class PaymentMethodModel {
  final String? moyenPaiementType;
  final String? moyenPaiementNumero;

  const PaymentMethodModel({
    this.moyenPaiementType,
    this.moyenPaiementNumero,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      moyenPaiementType: json['moyenPaiementType'] as String?,
      moyenPaiementNumero: json['moyenPaiementNumero'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'moyenPaiementType': moyenPaiementType,
    'moyenPaiementNumero': moyenPaiementNumero,
  };

  bool get isRegistered => moyenPaiementType != null && moyenPaiementNumero != null;
}
