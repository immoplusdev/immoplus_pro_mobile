import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';

sealed class DemandesState {
  const DemandesState();
}

class DemandesInitial extends DemandesState {
  const DemandesInitial();
}

class DemandesLoading extends DemandesState {
  const DemandesLoading();
}

class DemandesLoaded extends DemandesState {
  final List<AlertMarketplaceItem> items;
  final int totalCount;
  final int badgeCount;

  const DemandesLoaded({
    required this.items,
    this.totalCount = 0,
    this.badgeCount = 0,
  });

  DemandesLoaded copyWith({
    List<AlertMarketplaceItem>? items,
    int? totalCount,
    int? badgeCount,
  }) {
    return DemandesLoaded(
      items: items ?? this.items,
      totalCount: totalCount ?? this.totalCount,
      badgeCount: badgeCount ?? this.badgeCount,
    );
  }
}

class DemandesError extends DemandesState {
  final String error;
  const DemandesError(this.error);
}
