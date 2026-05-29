import 'package:immoplus_pro/features/booking/booking_history_page.dart';
import 'package:immoplus_pro/features/estate_detail/estate_details_page.dart';
import 'package:immoplus_pro/features/estates/estates_page.dart';
import 'package:immoplus_pro/features/estates/estates_page_v2.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_page.dart';
import 'package:immoplus_pro/features/residence/residences_page.dart';
import 'package:immoplus_pro/features/residence_detail/residence_details_page.dart';
import 'package:immoplus_pro/features/visits/visit_history_page.dart';

enum PushNotificationType {
  auth, // Inscription
  user, // User-related
  reservation, // Réservations
  residence, // Résidences
  bienImmobilier, // Biens immobiliers
  demandeVisite, // Demandes de visite
  payment, // Paiements
  wallet, // Wallet
  newReservationWaiting; // Nouvelle réservation en attente

  /// Retourne la route correspondante
  String? getRoute(String? id) {
    switch (this) {
      case PushNotificationType.reservation:
        return BookingHistoryPage.route();

      case PushNotificationType.demandeVisite:
        return VisitHistoryPage.route();

      case PushNotificationType.residence:
        return id != null
            ? ResidenceDetailsPage.route(id: id)
            : ResidencesPage.route();

      case PushNotificationType.bienImmobilier:
        return id != null
            ? EstateDetailsPage.route(id: id)
            : EstatesPageV2.route();

      case PushNotificationType.newReservationWaiting:
        return PendingReservationsPage.route();

      case PushNotificationType.wallet:
      // return HomePage.route();
      case PushNotificationType.payment:
      case PushNotificationType.auth:
      case PushNotificationType.user:
        return null;
    }
  }

  /// Convertir une string en enum
  static PushNotificationType? fromString(String? type) {
    if (type == null) return null;

    switch (type.toLowerCase()) {
      case 'auth':
        return PushNotificationType.auth;

      case 'user':
        return PushNotificationType.user;

      case 'reservation':
        return PushNotificationType.reservation;

      case 'residence':
        return PushNotificationType.residence;

      case 'bien_immobilier':
        return PushNotificationType.bienImmobilier;

      case 'demande_visite':
        return PushNotificationType.demandeVisite;

      case 'payment':
        return PushNotificationType.payment;

      case 'wallet':
        return PushNotificationType.wallet;

      case 'new_reservation_waiting':
        return PushNotificationType.newReservationWaiting;

      default:
        return null;
    }
  }
}
