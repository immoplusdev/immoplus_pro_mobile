class CertificationModel {
  final String userId;
  final int scoreTotal;
  final String status;
  final CertificationPiliers piliers;
  final CertificationConditions conditionsAttribution;
  final DateTime lastCalculatedAt;

  CertificationModel({
    required this.userId,
    required this.scoreTotal,
    required this.status,
    required this.piliers,
    required this.conditionsAttribution,
    required this.lastCalculatedAt,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      userId: json['userId'] as String,
      scoreTotal: json['scoreTotal'] as int,
      status: json['status'] as String,
      piliers: CertificationPiliers.fromJson(json['piliers'] as Map<String, dynamic>),
      conditionsAttribution: CertificationConditions.fromJson(
        json['conditionsAttribution'] as Map<String, dynamic>,
      ),
      lastCalculatedAt: DateTime.parse(json['lastCalculatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'scoreTotal': scoreTotal,
    'status': status,
    'piliers': piliers.toJson(),
    'conditionsAttribution': conditionsAttribution.toJson(),
    'lastCalculatedAt': lastCalculatedAt.toIso8601String(),
  };
}

class CertificationPiliers {
  final CertificationScore informations;
  final CertificationScore reservations;
  final CertificationScore avis;
  final CertificationScore fiabilite;

  CertificationPiliers({
    required this.informations,
    required this.reservations,
    required this.avis,
    required this.fiabilite,
  });

  factory CertificationPiliers.fromJson(Map<String, dynamic> json) {
    return CertificationPiliers(
      informations: CertificationScore.fromJson(
        json['informations'] as Map<String, dynamic>,
      ),
      reservations: CertificationScore.fromJson(
        json['reservations'] as Map<String, dynamic>,
      ),
      avis: CertificationScore.fromJson(json['avis'] as Map<String, dynamic>),
      fiabilite: CertificationScore.fromJson(
        json['fiabilite'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'informations': informations.toJson(),
    'reservations': reservations.toJson(),
    'avis': avis.toJson(),
    'fiabilite': fiabilite.toJson(),
  };
}

class CertificationScore {
  final int score;
  final int max;
  final int? nbReservationsEffectuees;
  final double? noteMoyenne;
  final int? nbAvisRecus;
  final double? tauxReponse;
  final int? delaiMedianMinutes;
  final int? plafond;

  CertificationScore({
    required this.score,
    required this.max,
    this.nbReservationsEffectuees,
    this.noteMoyenne,
    this.nbAvisRecus,
    this.tauxReponse,
    this.delaiMedianMinutes,
    this.plafond,
  });

  factory CertificationScore.fromJson(Map<String, dynamic> json) {
    return CertificationScore(
      score: json['score'] as int,
      max: json['max'] as int,
      nbReservationsEffectuees: json['nbReservationsEffectuees'] as int?,
      noteMoyenne: (json['noteMoyenne'] as num?)?.toDouble(),
      nbAvisRecus: json['nbAvisRecus'] as int?,
      tauxReponse: (json['tauxReponse'] as num?)?.toDouble(),
      delaiMedianMinutes: json['delaiMedianMinutes'] as int?,
      plafond: json['plafond'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'score': score,
    'max': max,
    if (nbReservationsEffectuees != null) 'nbReservationsEffectuees': nbReservationsEffectuees,
    if (noteMoyenne != null) 'noteMoyenne': noteMoyenne,
    if (nbAvisRecus != null) 'nbAvisRecus': nbAvisRecus,
    if (tauxReponse != null) 'tauxReponse': tauxReponse,
    if (delaiMedianMinutes != null) 'delaiMedianMinutes': delaiMedianMinutes,
    if (plafond != null) 'plafond': plafond,
  };

  double get percentage => (score / max) * 100;
}

class CertificationConditions {
  final bool identiteVerifiee;
  final bool moyenPaiementVerifie;
  final bool avisMinimum;
  final bool reservationsMin10;
  final bool fiabiliteMin14;
  final bool aucuneSanctionActive;

  CertificationConditions({
    required this.identiteVerifiee,
    required this.moyenPaiementVerifie,
    required this.avisMinimum,
    required this.reservationsMin10,
    required this.fiabiliteMin14,
    required this.aucuneSanctionActive,
  });

  factory CertificationConditions.fromJson(Map<String, dynamic> json) {
    return CertificationConditions(
      identiteVerifiee: json['identiteVerifiee'] as bool? ?? false,
      moyenPaiementVerifie: json['moyenPaiementVerifie'] as bool? ?? false,
      avisMinimum: json['avisMinimum'] as bool? ?? false,
      reservationsMin10: json['reservationsMin10'] as bool? ?? false,
      fiabiliteMin14: json['fiabiliteMin14'] as bool? ?? false,
      aucuneSanctionActive: json['aucuneSanctionActive'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'identiteVerifiee': identiteVerifiee,
    'moyenPaiementVerifie': moyenPaiementVerifie,
    'avisMinimum': avisMinimum,
    'reservationsMin10': reservationsMin10,
    'fiabiliteMin14': fiabiliteMin14,
    'aucuneSanctionActive': aucuneSanctionActive,
  };
}
