import 'package:immoplus_pro/data/enums/alert_enums.dart';

class AlertMarketplaceResponse {
  final List<AlertMarketplaceItem> data;
  final AlertMarketplacePagination? pagination;

  const AlertMarketplaceResponse({
    required this.data,
    this.pagination,
  });

  factory AlertMarketplaceResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] ?? json;
    List<AlertMarketplaceItem> items = [];
    AlertMarketplacePagination? pagination;

    if (rawData is List) {
      items = rawData
          .whereType<Map<String, dynamic>>()
          .map((e) => AlertMarketplaceItem.fromJson(e))
          .toList();
      if (json['pagination'] is Map<String, dynamic>) {
        pagination = AlertMarketplacePagination.fromJson(
            json['pagination'] as Map<String, dynamic>);
      }
    } else if (rawData is Map<String, dynamic>) {
      // 1. Extraction de la liste des demandes/propositions
      final innerData = rawData['data'];
      List<dynamic>? rawItemsList;

      if (innerData is Map<String, dynamic>) {
        final dList = innerData['demands'] as List<dynamic>?;
        final pList = (innerData['myProposals'] ?? innerData['proposals'])
            as List<dynamic>?;
        if (dList != null || pList != null) {
          rawItemsList = [
            if (dList != null) ...dList,
            if (pList != null) ...pList,
          ];
        }
      } else if (innerData is List) {
        rawItemsList = innerData;
      }

      // Si non trouvé dans innerData, chercher directement dans rawData
      rawItemsList ??= (rawData['demands'] as List<dynamic>?) ??
          (rawData['myProposals'] as List<dynamic>?) ??
          (rawData['proposals'] as List<dynamic>?);

      if (rawItemsList != null) {
        items = rawItemsList
            .whereType<Map<String, dynamic>>()
            .map((e) => AlertMarketplaceItem.fromJson(e))
            .toList();
      }

      // 2. Extraction de la pagination
      final paginationJson = rawData['pagination'] ?? json['pagination'];
      if (paginationJson is Map<String, dynamic>) {
        pagination = AlertMarketplacePagination.fromJson(paginationJson);
      } else if (rawData['totalDemands'] != null || rawData['total'] != null) {
        pagination = AlertMarketplacePagination(
          page: rawData['page'] as int? ?? 1,
          limit: rawData['limit'] as int? ?? 10,
          total: (rawData['totalDemands'] ?? rawData['total']) as int? ??
              items.length,
          totalPages: rawData['pages'] as int? ?? 1,
        );
      }
    }

    return AlertMarketplaceResponse(
      data: items,
      pagination: pagination,
    );
  }
}

class AlertMarketplacePagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const AlertMarketplacePagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory AlertMarketplacePagination.fromJson(Map<String, dynamic> json) {
    return AlertMarketplacePagination(
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      total: json['total'] as int? ?? (json['totalDemands'] as int? ?? 0),
      totalPages: json['pages'] as int? ?? (json['totalPages'] as int? ?? 1),
    );
  }
}

class AlertMarketplaceItem {
  final String id;
  final String? userId;
  final String title;
  final String? clientName;
  final String? targetType;
  final String? descriptionClient;
  final AlertCriteria? criteria;
  final StatusAlert status;
  final int matchCount;
  final int proposalCount;
  final int responseCount;
  final bool hasResponded;
  final DateTime? createdAt;
  final DateTime? viewedByProfessionalAt;
  final List<AlertProposal> proposals;

  const AlertMarketplaceItem({
    required this.id,
    this.userId,
    required this.title,
    this.clientName,
    this.targetType,
    this.descriptionClient,
    this.criteria,
    required this.status,
    this.matchCount = 0,
    this.proposalCount = 0,
    this.responseCount = 0,
    this.hasResponded = false,
    this.createdAt,
    this.viewedByProfessionalAt,
    this.proposals = const [],
  });

  bool get isNew => viewedByProfessionalAt == null;

  String get formattedPublishedDate {
    if (createdAt == null) return '';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.isNegative || diff.inSeconds < 60) {
      return "Publiée à l'instant";
    } else if (diff.inMinutes < 60) {
      return 'Publiée il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'Publiée il y a ${diff.inHours} h';
    } else if (diff.inDays < 7) {
      return 'Publiée il y a ${diff.inDays} j';
    } else if (diff.inDays < 30) {
      final weeks = (diff.inDays / 7).floor();
      return 'Publiée il y a $weeks sem';
    } else {
      final months = (diff.inDays / 30).floor();
      return 'Publiée il y a $months mois';
    }
  }

  factory AlertMarketplaceItem.fromJson(Map<String, dynamic> json) {
    final criteria =
        json['criteria'] != null && json['criteria'] is Map<String, dynamic>
            ? AlertCriteria.fromJson(json['criteria'] as Map<String, dynamic>)
            : null;

    // Construction d'un titre pertinent si title est null ou vide
    String generatedTitle = json['title'] as String? ?? '';
    if (generatedTitle.isEmpty) {
      if (criteria != null) {
        final propType =
            criteria.propertyType != null && criteria.propertyType!.isNotEmpty
                ? criteria.propertyType!.toUpperCase()
                : 'LOGEMENT';
        final loc = criteria.location != null &&
                criteria.location!.isNotEmpty &&
                criteria.location != '<UNKNOWN>'
            ? ' à ${criteria.location}'
            : '';
        generatedTitle = '$propType$loc';
      } else {
        generatedTitle = 'Demande de logement';
      }
    }

    final clientName = json['clientName'] as String?;
    final descClient = json['descriptionClient'] as String? ??
        json['description'] as String? ??
        (clientName != null ? 'Demande déposée par $clientName' : null);

    return AlertMarketplaceItem(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String?,
      title: generatedTitle,
      clientName: clientName,
      targetType: json['targetType'] as String?,
      descriptionClient: descClient,
      criteria: criteria,
      status: StatusAlert.fromValue(json['status'] as String?),
      matchCount: json['matchCount'] as int? ?? 0,
      proposalCount: json['proposalCount'] as int? ?? 0,
      responseCount: json['responseCount'] as int? ?? 0,
      hasResponded: json['hasResponded'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      viewedByProfessionalAt: json['viewedByProfessionalAt'] != null
          ? DateTime.tryParse(json['viewedByProfessionalAt'] as String)
          : null,
      proposals: json['proposals'] != null && json['proposals'] is List
          ? (json['proposals'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => AlertProposal.fromJson(e))
              .toList()
          : const [],
    );
  }
}

class AlertCriteria {
  final String? location;
  final String? propertyType;
  final String? transactionType;
  final int? roomsMin;
  final int? roomsMax;
  final num? priceMin;
  final num? priceMax;
  final num? surfaceMin;
  final List<String> extras;

  const AlertCriteria({
    this.location,
    this.propertyType,
    this.transactionType,
    this.roomsMin,
    this.roomsMax,
    this.priceMin,
    this.priceMax,
    this.surfaceMin,
    this.extras = const [],
  });

  factory AlertCriteria.fromJson(Map<String, dynamic> json) {
    List<String> rawExtras = [];
    if (json['extras'] != null && json['extras'] is List) {
      rawExtras = (json['extras'] as List)
          .where((e) => e != null && e.toString().trim().isNotEmpty)
          .map((e) => e.toString())
          .toList();
    }
    return AlertCriteria(
      location:
          json['location'] == '<UNKNOWN>' ? null : json['location'] as String?,
      propertyType: (json['property_type'] ?? json['propertyType']) as String?,
      transactionType:
          (json['transaction_type'] ?? json['transactionType']) as String?,
      roomsMin: (json['rooms_min'] ?? json['roomsMin']) as int?,
      roomsMax: (json['rooms_max'] ?? json['roomsMax']) as int?,
      priceMin: (json['price_min'] ?? json['priceMin']) as num?,
      priceMax: (json['price_max'] ?? json['priceMax']) as num?,
      surfaceMin: (json['surface_min'] ?? json['surfaceMin']) as num?,
      extras: rawExtras,
    );
  }

  String get formattedBudget {
    if (priceMin != null && priceMax != null) {
      return '${_formatNumber(priceMin!)} — ${_formatNumber(priceMax!)} FCFA / mois';
    } else if (priceMax != null) {
      return 'Jusqu\'à ${_formatNumber(priceMax!)} FCFA / mois';
    } else if (priceMin != null) {
      return 'À partir de ${_formatNumber(priceMin!)} FCFA / mois';
    }
    return 'Budget sur demande';
  }

  static String _formatNumber(num number) {
    final str = number.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
  }
}

class AlertProposal {
  final String id;
  final String? professionalId;
  final String? professionalName;
  final String? proposedItemId;
  final String? proposedItemName;
  final num? proposedItemPrice;
  final String? proposedItemImage;
  final String? message;
  final AlertProposalStatus status;
  final DateTime? createdAt;

  const AlertProposal({
    required this.id,
    this.professionalId,
    this.professionalName,
    this.proposedItemId,
    this.proposedItemName,
    this.proposedItemPrice,
    this.proposedItemImage,
    this.message,
    required this.status,
    this.createdAt,
  });

  factory AlertProposal.fromJson(Map<String, dynamic> json) {
    return AlertProposal(
      id: json['id'] as String? ?? '',
      professionalId: json['professionalId'] as String?,
      professionalName: json['professionalName'] as String?,
      proposedItemId: (json['proposedItemId'] ?? json['propertyId']) as String?,
      proposedItemName: json['proposedItemName'] as String?,
      proposedItemPrice: json['proposedItemPrice'] as num?,
      proposedItemImage: json['proposedItemImage'] as String?,
      message: json['message'] as String?,
      status: AlertProposalStatus.fromValue(json['status'] as String?),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}

class ConciergeNote {
  final String id;
  final String? authorId;
  final String? authorName;
  final String? message;
  final String? proposedItemId;
  final String? proposedItemName;
  final String? entityType;
  final DateTime? createdAt;

  const ConciergeNote({
    required this.id,
    this.authorId,
    this.authorName,
    this.message,
    this.proposedItemId,
    this.proposedItemName,
    this.entityType,
    this.createdAt,
  });

  factory ConciergeNote.fromJson(Map<String, dynamic> json) {
    return ConciergeNote(
      id: json['id'] as String? ?? '',
      authorId: json['authorId'] as String?,
      authorName: json['authorName'] as String?,
      message: json['message'] as String?,
      proposedItemId: json['proposedItemId'] as String?,
      proposedItemName: json['proposedItemName'] as String?,
      entityType: json['entityType'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }
}

class AlertDetailModel {
  final String id;
  final String? userId;
  final String title;
  final String? targetType;
  final String? descriptionClient;
  final AlertCriteria? criteria;
  final StatusAlert status;
  final int matchCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AlertProposal> proposals;
  final List<ConciergeNote> conciergeNotes;

  const AlertDetailModel({
    required this.id,
    this.userId,
    required this.title,
    this.targetType,
    this.descriptionClient,
    this.criteria,
    required this.status,
    this.matchCount = 0,
    this.createdAt,
    this.updatedAt,
    this.proposals = const [],
    this.conciergeNotes = const [],
  });

  factory AlertDetailModel.fromJson(Map<String, dynamic> json) {
    final alertData = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return AlertDetailModel(
      id: alertData['id'] as String? ?? '',
      userId: alertData['userId'] as String?,
      title: alertData['title'] as String? ?? 'Détail de la demande',
      targetType: alertData['targetType'] as String?,
      descriptionClient: alertData['descriptionClient'] as String?,
      criteria: alertData['criteria'] != null &&
              alertData['criteria'] is Map<String, dynamic>
          ? AlertCriteria.fromJson(
              alertData['criteria'] as Map<String, dynamic>)
          : null,
      status: StatusAlert.fromValue(alertData['status'] as String?),
      matchCount: alertData['matchCount'] as int? ?? 0,
      createdAt: alertData['createdAt'] != null
          ? DateTime.tryParse(alertData['createdAt'] as String)
          : null,
      updatedAt: alertData['updatedAt'] != null
          ? DateTime.tryParse(alertData['updatedAt'] as String)
          : null,
      proposals:
          alertData['proposals'] != null && alertData['proposals'] is List
              ? (alertData['proposals'] as List)
                  .whereType<Map<String, dynamic>>()
                  .map((e) => AlertProposal.fromJson(e))
                  .toList()
              : const [],
      conciergeNotes: alertData['conciergeNotes'] != null &&
              alertData['conciergeNotes'] is List
          ? (alertData['conciergeNotes'] as List)
              .whereType<Map<String, dynamic>>()
              .map((e) => ConciergeNote.fromJson(e))
              .toList()
          : const [],
    );
  }
}

class AlertProMatchItem {
  final String id;
  final String title;
  final String? image;
  final String? location;
  final int? rooms;
  final num? price;
  final int matchScore;
  final String? type;

  const AlertProMatchItem({
    required this.id,
    required this.title,
    this.image,
    this.location,
    this.rooms,
    this.price,
    required this.matchScore,
    this.type,
  });

  String get formattedPrice {
    if (price == null) return '';
    final str = price!.toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write(' ');
      }
      buffer.write(str[i]);
    }
    return '${buffer.toString()} FCFA / mois';
  }

  String get subtitle {
    final loc = location ?? 'Cocody';
    final r = rooms != null ? ' · $rooms pièces' : '';
    return '$loc$r';
  }

  factory AlertProMatchItem.fromJson(Map<String, dynamic> json) {
    return AlertProMatchItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Bien immobilier',
      image: json['image'] as String?,
      location: json['location'] as String?,
      rooms: json['rooms'] as int?,
      price: json['price'] as num?,
      matchScore: json['matchScore'] as int? ?? 0,
      type: json['type'] as String?,
    );
  }
}

class AlertProMatchesResponse {
  final String alertId;
  final List<AlertProMatchItem> matches;

  const AlertProMatchesResponse({
    required this.alertId,
    required this.matches,
  });

  factory AlertProMatchesResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawMatches = data['matches'] ?? data['data'];
    List<AlertProMatchItem> list = [];
    if (rawMatches is List) {
      list = rawMatches
          .whereType<Map<String, dynamic>>()
          .map((e) => AlertProMatchItem.fromJson(e))
          .toList();
    }
    return AlertProMatchesResponse(
      alertId: data['alertId'] as String? ?? '',
      matches: list,
    );
  }
}

class AlertBadgeCountModel {
  final int newDemandsCount;
  final int totalActiveDemands;
  final Map<String, int> countByStatus;

  const AlertBadgeCountModel({
    this.newDemandsCount = 0,
    this.totalActiveDemands = 0,
    this.countByStatus = const {},
  });

  factory AlertBadgeCountModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    Map<String, int> counts = {};
    if (data['countByStatus'] is Map<String, dynamic>) {
      (data['countByStatus'] as Map<String, dynamic>).forEach((k, v) {
        if (v is int) counts[k] = v;
      });
    }

    return AlertBadgeCountModel(
      newDemandsCount: data['newDemandsCount'] as int? ?? 0,
      totalActiveDemands: data['totalActiveDemands'] as int? ?? 0,
      countByStatus: counts,
    );
  }
}

class AlertProposalResponse {
  final String? id;
  final String? alertId;
  final String? propertyId;
  final String? message;
  final AlertProposalStatus status;
  final String? responseMessage;

  const AlertProposalResponse({
    this.id,
    this.alertId,
    this.propertyId,
    this.message,
    required this.status,
    this.responseMessage,
  });

  factory AlertProposalResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return AlertProposalResponse(
      id: data['id'] as String?,
      alertId: data['alertId'] as String?,
      propertyId: data['propertyId'] as String?,
      message: data['message'] as String?,
      status: AlertProposalStatus.fromValue(data['status'] as String?),
      responseMessage: json['message'] as String?,
    );
  }
}
