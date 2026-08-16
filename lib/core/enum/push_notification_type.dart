import 'package:immoplus_pro/features/booking/booking_history_page.dart';
import 'package:immoplus_pro/features/estate_detail/estate_details_page.dart';
import 'package:immoplus_pro/features/estates/estates_page.dart';
import 'package:immoplus_pro/features/estates/estates_page_v2.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_page.dart';
import 'package:immoplus_pro/features/residence/residences_page.dart';
import 'package:immoplus_pro/features/residence_detail/residence_details_page.dart';
import 'package:immoplus_pro/features/visits/visit_history_page.dart';
import 'package:immoplus_pro/features/ratings/pages/create_rating_page.dart';
import 'package:immoplus_pro/features/ratings/pages/ratings_history_page.dart';
import 'package:immoplus_pro/features/home_v2/home_page_v2.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/pages/owner_stats_page.dart';
import 'package:immoplus_pro/features/calendar/calendar_page_v2.dart';
import 'package:immoplus_pro/features/payments/payments_page_v2.dart';
import 'package:immoplus_pro/features/create_residence_v2/create_lodgment_page_v2.dart';
import 'package:immoplus_pro/features/create_estate_v2/create_estate_page_v2.dart';

enum MarketingNotificationCode {
  proOnb01('PRO-ONB-01'),
  proOnbEnt01('PRO-ONBENT-01'),
  proOnb05('PRO-ONB-05'),
  proOnb02('PRO-ONB-02'),
  proOnbEnt02('PRO-ONBENT-02'),
  proOnb03('PRO-ONB-03'),
  proOnb04('PRO-ONB-04'),
  proReeng07('PRO-REENG-07'),
  proOnb07('PRO-ONB-07'),
  proOnbEnt04('PRO-ONBENT-04'),
  proPerf01('PRO-PERF-01'),
  proMilestone10Reservations('PRO-MILESTONE-10-RESERVATIONS'),
  proMilestone50Reservations('PRO-MILESTONE-50-RESERVATIONS'),
  proMilestone100Reservations('PRO-MILESTONE-100-RESERVATIONS'),
  proOnb06('PRO-ONB-06'),
  proCalDailyAm('PRO-CAL-DAILY-AM'),
  proCalDailyPm('PRO-CAL-DAILY-PM'),
  proCalEvt03('PRO-CAL-EVT-03'),
  proReeng60('PRO-REENG-60'),
  proPerf06('PRO-PERF-06'),
  proSeason02('PRO-SEASON-02'),
  proCal01('PRO-CAL-01'),
  proCal02('PRO-CAL-02'),
  proCal03('PRO-CAL-03'),
  proCal04('PRO-CAL-04'),
  proCalEvt02('PRO-CAL-EVT-02'),
  proNurt01('PRO-NURT-01'),
  proNurt03('PRO-NURT-03'),
  proPerf02('PRO-PERF-02'),
  proPerf05('PRO-PERF-05'),
  proMilestoneFirstResidence('PRO-MILESTONE-FIRST-RESIDENCE'),
  proNurt02('PRO-NURT-02'),
  proReeng14('PRO-REENG-14'),
  proMilestoneFirstReservation('PRO-MILESTONE-FIRST-RESERVATION'),
  proCheckout01('PRO-CHECKOUT-01'),
  proCheckout02('PRO-CHECKOUT-02'),
  proWallet02('PRO-WALLET-02'),
  proMilestone5Stars('PRO-MILESTONE-5STARS');

  final String value;
  const MarketingNotificationCode(this.value);

  static MarketingNotificationCode? fromString(String? code) {
    if (code == null) return null;
    for (var enumValue in MarketingNotificationCode.values) {
      if (enumValue.value == code) return enumValue;
    }
    return null;
  }
}

enum PushNotificationType {
  auth, // Inscription
  user, // User-related
  reservation, // Réservations
  residence, // Résidences
  bienImmobilier, // Biens immobiliers
  demandeVisite, // Demandes de visite
  payment, // Paiements
  wallet, // Wallet
  newReservationWaiting, // Nouvelle réservation en attente
  ratingRequest, // Demande de notation (évaluation)
  reverseSearchInvitation, // Invitation "reverse search" (vague propriétaire)
  marketing; // Notifications marketing (pro-notifications)

  /// Retourne la route correspondante
  String? getRoute(String? id, {String? code}) {
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

      case PushNotificationType.ratingRequest:
        return id != null ? CreateRatingPage.route(id: id) : null;

      case PushNotificationType.reverseSearchInvitation:
        // Même route que newReservationWaiting : une page poussée "normale"

        return PendingReservationsPage.route();

      case PushNotificationType.marketing:
        final mktCode = MarketingNotificationCode.fromString(code);
        if (mktCode == null) return null;

        switch (mktCode) {
          case MarketingNotificationCode.proOnb01:
          case MarketingNotificationCode.proOnbEnt01:
          case MarketingNotificationCode.proOnb05:
            return HomePageV2.routePath;

          case MarketingNotificationCode.proOnb02:
            return CreateLodgmentPageV2.routePath;

          case MarketingNotificationCode.proOnbEnt02:
            return CreateEstatePageV2.routePath;

          case MarketingNotificationCode.proOnb03:
          case MarketingNotificationCode.proOnb04:
          case MarketingNotificationCode.proReeng07:
            return ResidencesPage.routePath();

          case MarketingNotificationCode.proOnb07:
          case MarketingNotificationCode.proOnbEnt04:
          case MarketingNotificationCode.proPerf01:
          case MarketingNotificationCode.proMilestone10Reservations:
          case MarketingNotificationCode.proMilestone50Reservations:
          case MarketingNotificationCode.proMilestone100Reservations:
            return OwnerStatsPage.routePath();

          case MarketingNotificationCode.proOnb06:
          case MarketingNotificationCode.proCalDailyAm:
          case MarketingNotificationCode.proCalDailyPm:
          case MarketingNotificationCode.proCalEvt03:
          case MarketingNotificationCode.proReeng60:
          case MarketingNotificationCode.proPerf06:
          case MarketingNotificationCode.proSeason02:
            return CalendarPageV2.routePath;

          case MarketingNotificationCode.proCal01:
          case MarketingNotificationCode.proCal02:
          case MarketingNotificationCode.proCal03:
          case MarketingNotificationCode.proCal04:
          case MarketingNotificationCode.proCalEvt02:
          case MarketingNotificationCode.proNurt01:
          case MarketingNotificationCode.proNurt03:
          case MarketingNotificationCode.proPerf02:
          case MarketingNotificationCode.proPerf05:
          case MarketingNotificationCode.proMilestoneFirstResidence:
            return id != null ? ResidenceDetailsPage.route(id: id) : ResidencesPage.routePath();

          case MarketingNotificationCode.proNurt02:
          case MarketingNotificationCode.proReeng14:
            return PendingReservationsPage.routePath();

          case MarketingNotificationCode.proMilestoneFirstReservation:
          case MarketingNotificationCode.proCheckout01:
          case MarketingNotificationCode.proCheckout02:
            return BookingHistoryPage.routePath();

          case MarketingNotificationCode.proWallet02:
            return PaymentsPageV2.routePath;

          case MarketingNotificationCode.proMilestone5Stars:
            return RatingsHistoryPage.routePath();
        }


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

      case 'rating_request':
        return PushNotificationType.ratingRequest;

      case 'reverse_search_invitation':
        return PushNotificationType.reverseSearchInvitation;

      case 'marketing':
        return PushNotificationType.marketing;

      default:
        return null;
    }
  }
}
