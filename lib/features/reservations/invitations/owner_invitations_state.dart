import 'package:immoplus_pro/data/models/reservations/owner_invitation_model.dart';

/// État minimal (pas de Freezed ici, volontairement — pas besoin de
/// codegen pour une liste + deux actions par item).
sealed class OwnerInvitationsState {
  const OwnerInvitationsState();
}

class OwnerInvitationsInitial extends OwnerInvitationsState {
  const OwnerInvitationsInitial();
}

class OwnerInvitationsLoading extends OwnerInvitationsState {
  const OwnerInvitationsLoading();
}

class OwnerInvitationsError extends OwnerInvitationsState {
  final String message;
  const OwnerInvitationsError(this.message);
}

class OwnerInvitationsLoaded extends OwnerInvitationsState {
  final List<OwnerInvitationItem> items;

  /// id (voir [OwnerInvitationItem.id]) de la card en cours de
  /// confirmation/déclin, pour afficher un spinner local sur cette seule
  /// card sans bloquer le reste de la liste.
  final String? actingItemId;

  const OwnerInvitationsLoaded(this.items, {this.actingItemId});

  OwnerInvitationsLoaded copyWith({
    List<OwnerInvitationItem>? items,
    String? actingItemId,
    bool clearActingItemId = false,
  }) {
    return OwnerInvitationsLoaded(
      items ?? this.items,
      actingItemId: clearActingItemId ? null : (actingItemId ?? this.actingItemId),
    );
  }
}
