class OwnerStatsDto {
  final RevenueDto revenue;
  final PropertiesDto properties;
  final EngagementDto engagement;
  final ReservationsDto reservations;
  final OccupancyDto occupancy;
  final List<RevenueChartDto> revenueChart;
  final List<TopPropertyDto> topProperties;
  final List<TransactionDto> recentTransactions;

  OwnerStatsDto({
    required this.revenue,
    required this.properties,
    required this.engagement,
    required this.reservations,
    required this.occupancy,
    required this.revenueChart,
    required this.topProperties,
    required this.recentTransactions,
  });

  factory OwnerStatsDto.fromJson(Map<String, dynamic> json) {
    return OwnerStatsDto(
      revenue: RevenueDto.fromJson(json['revenue'] ?? {}),
      properties: PropertiesDto.fromJson(json['properties'] ?? {}),
      engagement: EngagementDto.fromJson(json['engagement'] ?? {}),
      reservations: ReservationsDto.fromJson(json['reservations'] ?? {}),
      occupancy: OccupancyDto.fromJson(json['occupancy'] ?? {}),
      revenueChart: (json['revenueChart'] as List? ?? [])
          .map((e) => RevenueChartDto.fromJson(e))
          .toList(),
      topProperties: (json['topProperties'] as List? ?? [])
          .map((e) => TopPropertyDto.fromJson(e))
          .toList(),
      recentTransactions: (json['recentTransactions'] as List? ?? [])
          .map((e) => TransactionDto.fromJson(e))
          .toList(),
    );
  }
}

class RevenueDto {
  final int currentPeriod;
  final double percentChange;
  final String currency;

  RevenueDto({
    required this.currentPeriod,
    required this.percentChange,
    required this.currency,
  });

  factory RevenueDto.fromJson(Map<String, dynamic> json) {
    return RevenueDto(
      currentPeriod: (json['currentPeriod'] ?? 0) as int,
      percentChange: (json['percentChange'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'XAF',
    );
  }
}

class PropertiesDto {
  final int totalActive;
  final int biens;
  final int residences;
  final int furniture;

  PropertiesDto({
    required this.totalActive,
    required this.biens,
    required this.residences,
    required this.furniture,
  });

  factory PropertiesDto.fromJson(Map<String, dynamic> json) {
    return PropertiesDto(
      totalActive: json['totalActive'] ?? 0,
      biens: json['biens'] ?? 0,
      residences: json['residences'] ?? 0,
      furniture: json['furniture'] ?? 0,
    );
  }
}

class EngagementDto {
  final int totalViews;
  final int totalLikes;
  final double averageScore;

  EngagementDto({
    required this.totalViews,
    required this.totalLikes,
    required this.averageScore,
  });

  factory EngagementDto.fromJson(Map<String, dynamic> json) {
    return EngagementDto(
      totalViews: json['totalViews'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
      averageScore: (json['averageScore'] ?? 0).toDouble(),
    );
  }
}

class ReservationsDto {
  final int confirmed;
  final int pending;
  final int cancelled;
  final int total;

  ReservationsDto({
    required this.confirmed,
    required this.pending,
    required this.cancelled,
    required this.total,
  });

  factory ReservationsDto.fromJson(Map<String, dynamic> json) {
    return ReservationsDto(
      confirmed: json['confirmed'] ?? 0,
      pending: json['pending'] ?? 0,
      cancelled: json['cancelled'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class OccupancyDto {
  final double currentPeriod;
  final double previousPeriod;

  OccupancyDto({
    required this.currentPeriod,
    required this.previousPeriod,
  });

  factory OccupancyDto.fromJson(Map<String, dynamic> json) {
    return OccupancyDto(
      currentPeriod: (json['currentPeriod'] ?? 0).toDouble(),
      previousPeriod: (json['previousPeriod'] ?? 0).toDouble(),
    );
  }
}

class RevenueChartDto {
  final String month;
  final int reservations;
  final int visits;

  RevenueChartDto({
    required this.month,
    required this.reservations,
    required this.visits,
  });

  factory RevenueChartDto.fromJson(Map<String, dynamic> json) {
    return RevenueChartDto(
      month: json['month'] ?? '',
      reservations: json['reservations'] ?? 0,
      visits: json['visits'] ?? 0,
    );
  }
}

class TopPropertyDto {
  final String id;
  final String nom;
  final int views;
  final int likes;

  TopPropertyDto({
    required this.id,
    required this.nom,
    required this.views,
    required this.likes,
  });

  factory TopPropertyDto.fromJson(Map<String, dynamic> json) {
    return TopPropertyDto(
      id: json['id'] ?? '',
      nom: json['nom'] ?? '',
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
    );
  }
}

class TransactionDto {
  final String id;
  final String date;
  final String type;
  final int amount;
  final String propertyName;
  final String direction;

  TransactionDto({
    required this.id,
    required this.date,
    required this.type,
    required this.amount,
    required this.propertyName,
    required this.direction,
  });

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    return TransactionDto(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      type: json['type'] ?? '',
      amount: json['amount'] ?? 0,
      propertyName: json['propertyName'] ?? '',
      direction: json['direction'] ?? 'in',
    );
  }
}
