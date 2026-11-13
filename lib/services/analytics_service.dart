import 'dart:developer';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:immoplus_pro/data/enums/analytics_enums.dart';
import 'package:immoplus_pro/data/enums/home_filters.dart';
import 'package:immoplus_pro/data/enums/qr_scan_error.dart';
import 'package:injectable/injectable.dart';

abstract class AnalyticsService {
  Future<void> identifyUser({
    required String userId,
    required int totalProperties,
    required String kycStatus,
    required bool isProValidated,
    required String accountStatus,
    required String accountType,
    required String registrationDate,
  });

  Future<void> updatePropertyCountProperty(int totalProperties);
  Future<void> updateKycStatusProperty(String kycStatus);
  Future<void> updateProValidationProperty(bool isProValidated);
  Future<void> clearUser();

  // 1. Authentification
  Future<void> logSignUp({required String method});
  Future<void> logLogin({required String method});

  // 2. KYC
  Future<void> logKycStarted();
  Future<void> logKycSubmitted();
  Future<void> logKycDocumentsEditStarted();
  Future<void> logKycDocumentsEditSubmitted();

  // 3. Funnel de création de bien
  Future<void> logPropertyCreationStarted({String? codeBien, String? typeBien});
  Future<void> logPropertyInfoSubmitted({
    required String typeBien,
    required String commune,
    required int nbPieces,
    required double surface,
  });
  Future<void> logPropertyMediaUploaded({
    required int nbPhotos,
    required bool hasVideo,
  });
  Future<void> logPropertyCreationSubmitted({
    required String typeBien,
    required double prix,
    required String commune,
  });
  Future<void> logPropertyCreationSuccess({
    required String idBien,
    required String typeBien,
    required double prix,
  });
  Future<void> logPropertyCreationAbandoned({
    required String step,
    String? reason,
  });
  Future<void> logPropertyCreationFailed({
    required String typeBien,
    String? errorCode,
  });

  // 4. Gestion des annonces
  Future<void> logPropertyListViewed({required int totalProperties});
  Future<void> logPropertyAvailabilityToggled({
    required String idBien,
    required bool isAvailable,
  });

  // 5. Gestion des réservations
  Future<void> logBookingCardTapped({
    required String idReservation,
    required String status,
  });
  Future<void> logBookingAccepted({required String idReservation});
  Future<void> logBookingRefused({
    required String idReservation,
    required RefusalReason reason,
    String? notes,
  });
  Future<void> logCalendarUpdatedAfterRefusal({
    required String idReservation,
    required int minutesSinceRefusal,
  });
  Future<void> logRefusalNoCorrectiveAction({required String idReservation});

  // 6. Gestion des visites
  Future<void> logVisitRequestReceived({required String idVisite});
  Future<void> logVisitScheduled({
    required String idVisite,
    required String dateVisite,
  });

  // 7. Portefeuille & retraits
  Future<void> logWithdrawalFormOpened({required double soldeDisponible});
  Future<void> logWithdrawalSubmitted({
    required double montantRetrait,
    required String paymentMethod,
  });
  Future<void> logPayoutCardSetupStarted();
  Future<void> logPayoutCardRegistered();
  Future<void> logWithdrawalSuccess({
    required double montantRetrait,
    required String paymentMethod,
  });
  Future<void> logWithdrawalFailed({
    required double montantRetrait,
    String? paymentMethod,
  });

  // 7bis. Paiement réservation (mobile money)
  Future<void> logPaymentCompleted({
    required String operator,
    double? amount,
  });
  Future<void> logPaymentFailed({
    required String operator,
    double? amount,
    String? step,
  });

  // 8. Tableaux de bord
  Future<void> logStatsPageViewed({required String period});
  Future<void> logStatsPeriodChanged({
    required String oldPeriod,
    required String newPeriod,
  });

  // 9. Notifications push
  Future<void> logPushNotificationReceived({
    required String idNotification,
    required String typeNotification,
  });
  Future<void> logPushNotificationTapped({
    required String idNotification,
    required String typeNotification,
  });

  // 10. Deep links
  Future<void> logDeepLinkOpened({
    required String url,
    String? source,
    String? medium,
    String? campaign,
  });

  // 11. Tableau de bord
  Future<void> logDashboardActionTapped({required DashboardAction action});
  Future<void> logTabReservationsTapped();
  Future<void> logTabVisitesTapped();
  Future<void> logBookingFilterChanged({required BookingFilterV2 filter});
  Future<void> logVisitFilterChanged({required VisitFilterV2 filter});
  Future<void> logNotificationIconTapped();

  // 12. Certification
  Future<void> logCertificationBannerViewed({
    required CertificationPlacement placement,
  });
  Future<void> logCertificationBannerTapped({
    required CertificationPlacement placement,
  });
  Future<void> logCertificationPageViewed();
  Future<void> logCertificationDocumentsSubmitted();

  // 13. Navigation principale
  Future<void> logNavTabTapped({required NavTab tab});

  // 14. Bannières promotionnelles
  Future<void> logProBannerViewed({required int? bannerId, String? type});
  Future<void> logProBannerCtaTapped({required int? bannerId, String? type});
  Future<void> logProBannerDismissed({required int? bannerId, String? type});

  // 15. Coffre / Portefeuille
  Future<void> logVaultUnlocked();
  Future<void> logWithdrawalButtonTapped();

  // 16. Scanner QR
  Future<void> logQrScannerOpened();
  Future<void> logQrPresenceValidated();
  Future<void> logQrPresenceFailed({required QrScanError error});
}

@LazySingleton(as: AnalyticsService)
class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  String _getPropertyBucket(int count) {
    if (count <= 0) return "0";
    if (count == 1) return "1";
    if (count <= 5) return "2-5";
    return "6+";
  }

  @override
  Future<void> identifyUser({
    required String userId,
    required int totalProperties,
    required String kycStatus,
    required bool isProValidated,
    required String accountStatus,
    required String accountType,
    required String registrationDate,
  }) async {
    try {
      await _analytics.setUserId(id: userId);
      await _analytics.setUserProperty(
        name: 'total_properties',
        value: _getPropertyBucket(totalProperties),
      );
      await _analytics.setUserProperty(
        name: 'kyc_status',
        value: kycStatus,
      );
      await _analytics.setUserProperty(
        name: 'is_pro_validated',
        value: isProValidated.toString(),
      );
      await _analytics.setUserProperty(
        name: 'account_status',
        value: accountStatus,
      );
      await _analytics.setUserProperty(
        name: 'account_type',
        value: accountType,
      );
      await _analytics.setUserProperty(
        name: 'registration_date',
        value: registrationDate,
      );
      log('GA4: Identified user $userId', name: 'ANALYTICS');
    } catch (e) {
      log('GA4 Error setting user: $e', name: 'ANALYTICS');
    }
  }

  @override
  Future<void> updatePropertyCountProperty(int totalProperties) async {
    try {
      await _analytics.setUserProperty(
        name: 'total_properties',
        value: _getPropertyBucket(totalProperties),
      );
      log('GA4: Updated property count property: $totalProperties', name: 'ANALYTICS');
    } catch (e) {
      log('GA4 Error setting total_properties property: $e', name: 'ANALYTICS');
    }
  }

  @override
  Future<void> updateKycStatusProperty(String kycStatus) async {
    try {
      await _analytics.setUserProperty(
        name: 'kyc_status',
        value: kycStatus,
      );
      log('GA4: Updated kyc_status property: $kycStatus', name: 'ANALYTICS');
    } catch (e) {
      log('GA4 Error setting kyc_status property: $e', name: 'ANALYTICS');
    }
  }

  @override
  Future<void> updateProValidationProperty(bool isProValidated) async {
    try {
      await _analytics.setUserProperty(
        name: 'is_pro_validated',
        value: isProValidated.toString(),
      );
      log('GA4: Updated is_pro_validated property: $isProValidated', name: 'ANALYTICS');
    } catch (e) {
      log('GA4 Error setting is_pro_validated property: $e', name: 'ANALYTICS');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _analytics.setUserId(id: null);
      log('GA4: Cleared user identity', name: 'ANALYTICS');
    } catch (e) {
      log('GA4 Error clearing user: $e', name: 'ANALYTICS');
    }
  }

  /// GA4 limite la valeur d'un paramètre d'événement à 100 caractères.
  static const int _maxParamLength = 100;

  String _truncate(String value) => value.length <= _maxParamLength
      ? value
      : value.substring(0, _maxParamLength);

  // Helper log event
  Future<void> _logEvent(String name, [Map<String, Object>? parameters]) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
      log('GA4 Event: $name params: $parameters', name: 'ANALYTICS');
    } catch (e) {
      log('GA4 Error logging $name: $e', name: 'ANALYTICS');
    }
  }

  // 1. Authentification
  @override
  Future<void> logSignUp({required String method}) =>
      _logEvent('sign_up', {'method': method});

  @override
  Future<void> logLogin({required String method}) =>
      _logEvent('login', {'method': method});

  // 2. KYC
  @override
  Future<void> logKycStarted() => _logEvent('kyc_started');

  @override
  Future<void> logKycSubmitted() => _logEvent('kyc_submitted');

  @override
  Future<void> logKycDocumentsEditStarted() =>
      _logEvent('kyc_documents_edit_started');

  @override
  Future<void> logKycDocumentsEditSubmitted() =>
      _logEvent('kyc_documents_edit_submitted');

  // 3. Funnel de création de bien
  @override
  Future<void> logPropertyCreationStarted({String? codeBien, String? typeBien}) =>
      _logEvent('property_creation_started', {
        if (codeBien != null) 'code_bien': codeBien,
        if (typeBien != null) 'type_bien': typeBien,
      });

  @override
  Future<void> logPropertyInfoSubmitted({
    required String typeBien,
    required String commune,
    required int nbPieces,
    required double surface,
  }) =>
      _logEvent('property_info_submitted', {
        'type_bien': typeBien,
        'commune': commune,
        'nb_pieces': nbPieces,
        'surface': surface,
      });

  @override
  Future<void> logPropertyMediaUploaded({
    required int nbPhotos,
    required bool hasVideo,
  }) =>
      _logEvent('property_media_uploaded', {
        'nb_photos': nbPhotos,
        'has_video': hasVideo ? 1 : 0,
      });

  @override
  Future<void> logPropertyCreationSubmitted({
    required String typeBien,
    required double prix,
    required String commune,
  }) =>
      _logEvent('property_creation_submitted', {
        'type_bien': typeBien,
        'prix': prix,
        'commune': commune,
      });

  @override
  Future<void> logPropertyCreationSuccess({
    required String idBien,
    required String typeBien,
    required double prix,
  }) =>
      _logEvent('property_creation_success', {
        'id_bien': idBien,
        'type_bien': typeBien,
        'prix': prix,
      });

  @override
  Future<void> logPropertyCreationAbandoned({
    required String step,
    String? reason,
  }) =>
      _logEvent('property_creation_abandoned', {
        'step': step,
        if (reason != null) 'reason': reason,
      });

  @override
  Future<void> logPropertyCreationFailed({
    required String typeBien,
    String? errorCode,
  }) =>
      _logEvent('property_creation_failed', {
        'type_bien': typeBien,
        if (errorCode != null) 'error_code': errorCode,
      });

  // 4. Gestion des annonces
  @override
  Future<void> logPropertyListViewed({required int totalProperties}) =>
      _logEvent('property_list_viewed', {'total_properties': totalProperties});

  @override
  Future<void> logPropertyAvailabilityToggled({
    required String idBien,
    required bool isAvailable,
  }) =>
      _logEvent('property_availability_toggled', {
        'id_bien': idBien,
        'is_available': isAvailable ? 1 : 0,
      });

  // 5. Gestion des réservations
  @override
  Future<void> logBookingCardTapped({
    required String idReservation,
    required String status,
  }) =>
      _logEvent('booking_card_tapped', {
        'id_reservation': idReservation,
        'status': status,
      });

  @override
  Future<void> logBookingAccepted({required String idReservation}) =>
      _logEvent('booking_accepted', {'id_reservation': idReservation});

  @override
  Future<void> logBookingRefused({
    required String idReservation,
    required RefusalReason reason,
    String? notes,
  }) =>
      _logEvent('booking_refused', {
        'id_reservation': idReservation,
        'refusal_reason': reason.value,
        if (notes != null && notes.isNotEmpty)
          'refusal_notes': _truncate(notes),
      });

  @override
  Future<void> logCalendarUpdatedAfterRefusal({
    required String idReservation,
    required int minutesSinceRefusal,
  }) =>
      _logEvent('calendar_updated_after_refusal', {
        'id_reservation': idReservation,
        'minutes_since_refusal': minutesSinceRefusal,
      });

  @override
  Future<void> logRefusalNoCorrectiveAction({required String idReservation}) =>
      _logEvent('refusal_no_corrective_action', {
        'id_reservation': idReservation,
      });

  // 6. Gestion des visites
  @override
  Future<void> logVisitRequestReceived({required String idVisite}) =>
      _logEvent('visit_request_received', {'id_visite': idVisite});

  @override
  Future<void> logVisitScheduled({
    required String idVisite,
    required String dateVisite,
  }) =>
      _logEvent('visit_scheduled', {
        'id_visite': idVisite,
        'date_visite': dateVisite,
      });

  // 7. Portefeuille & retraits
  @override
  Future<void> logWithdrawalFormOpened({required double soldeDisponible}) =>
      _logEvent('withdrawal_form_opened', {'solde_disponible': soldeDisponible});

  @override
  Future<void> logWithdrawalSubmitted({
    required double montantRetrait,
    required String paymentMethod,
  }) =>
      _logEvent('withdrawal_submitted', {
        'montant_retrait': montantRetrait,
        'payment_method': paymentMethod,
      });

  @override
  Future<void> logPayoutCardSetupStarted() =>
      _logEvent('payout_card_setup_started');

  @override
  Future<void> logPayoutCardRegistered() =>
      _logEvent('payout_card_registered');

  @override
  Future<void> logWithdrawalSuccess({
    required double montantRetrait,
    required String paymentMethod,
  }) =>
      _logEvent('withdrawal_success', {
        'montant_retrait': montantRetrait,
        'payment_method': paymentMethod,
      });

  @override
  Future<void> logWithdrawalFailed({
    required double montantRetrait,
    String? paymentMethod,
  }) =>
      _logEvent('withdrawal_failed', {
        'montant_retrait': montantRetrait,
        if (paymentMethod != null) 'payment_method': paymentMethod,
      });

  // 7bis. Paiement réservation (mobile money)
  @override
  Future<void> logPaymentCompleted({
    required String operator,
    double? amount,
  }) =>
      _logEvent('payment_completed', {
        'operator': operator,
        if (amount != null) 'amount': amount,
      });

  @override
  Future<void> logPaymentFailed({
    required String operator,
    double? amount,
    String? step,
  }) =>
      _logEvent('payment_failed', {
        'operator': operator,
        if (amount != null) 'amount': amount,
        if (step != null) 'step': step,
      });

  // 8. Tableaux de bord
  @override
  Future<void> logStatsPageViewed({required String period}) =>
      _logEvent('stats_page_viewed', {'period': period});

  @override
  Future<void> logStatsPeriodChanged({
    required String oldPeriod,
    required String newPeriod,
  }) =>
      _logEvent('stats_period_changed', {
        'old_period': oldPeriod,
        'new_period': newPeriod,
      });

  // 9. Notifications push
  @override
  Future<void> logPushNotificationReceived({
    required String idNotification,
    required String typeNotification,
  }) =>
      _logEvent('push_notification_received', {
        'id_notification': idNotification,
        'type_notification': typeNotification,
      });

  @override
  Future<void> logPushNotificationTapped({
    required String idNotification,
    required String typeNotification,
  }) =>
      _logEvent('push_notification_tapped', {
        'id_notification': idNotification,
        'type_notification': typeNotification,
      });

  // 10. Deep links
  @override
  Future<void> logDeepLinkOpened({
    required String url,
    String? source,
    String? medium,
    String? campaign,
  }) =>
      _logEvent('deep_link_opened', {
        'url': url,
        if (source != null) 'source': source,
        if (medium != null) 'medium': medium,
        if (campaign != null) 'campaign': campaign,
      });

  // 11. Tableau de bord
  @override
  Future<void> logDashboardActionTapped({required DashboardAction action}) =>
      _logEvent('dashboard_action_tapped', {'action': action.value});

  @override
  Future<void> logTabReservationsTapped() =>
      _logEvent('tab_reservations_tapped');

  @override
  Future<void> logTabVisitesTapped() => _logEvent('tab_visites_tapped');

  @override
  Future<void> logBookingFilterChanged({required BookingFilterV2 filter}) =>
      _logEvent('booking_filter_changed', {'filter': filter.name});

  @override
  Future<void> logVisitFilterChanged({required VisitFilterV2 filter}) =>
      _logEvent('visit_filter_changed', {'filter': filter.name});

  @override
  Future<void> logNotificationIconTapped() =>
      _logEvent('notification_icon_tapped');

  // 12. Certification
  @override
  Future<void> logCertificationBannerViewed({
    required CertificationPlacement placement,
  }) =>
      _logEvent('certification_banner_viewed', {'placement': placement.value});

  @override
  Future<void> logCertificationBannerTapped({
    required CertificationPlacement placement,
  }) =>
      _logEvent('certification_banner_tapped', {'placement': placement.value});

  @override
  Future<void> logCertificationPageViewed() =>
      _logEvent('certification_page_viewed');

  @override
  Future<void> logCertificationDocumentsSubmitted() =>
      _logEvent('certification_documents_submitted');

  // 13. Navigation principale
  @override
  Future<void> logNavTabTapped({required NavTab tab}) =>
      _logEvent(tab.eventName);

  // 14. Bannières promotionnelles
  @override
  Future<void> logProBannerViewed({required int? bannerId, String? type}) =>
      _logEvent('pro_banner_viewed', _bannerParams(bannerId, type));

  @override
  Future<void> logProBannerCtaTapped({required int? bannerId, String? type}) =>
      _logEvent('pro_banner_cta_tapped', _bannerParams(bannerId, type));

  @override
  Future<void> logProBannerDismissed({required int? bannerId, String? type}) =>
      _logEvent('pro_banner_dismissed', _bannerParams(bannerId, type));

  Map<String, Object> _bannerParams(int? bannerId, String? type) => {
        if (bannerId != null) 'banner_id': bannerId,
        if (type != null) 'banner_type': type,
      };

  // 15. Coffre / Portefeuille
  @override
  Future<void> logVaultUnlocked() => _logEvent('vault_unlocked');

  @override
  Future<void> logWithdrawalButtonTapped() =>
      _logEvent('withdrawal_button_tapped');

  // 16. Scanner QR
  @override
  Future<void> logQrScannerOpened() => _logEvent('qr_scanner_opened');

  @override
  Future<void> logQrPresenceValidated() => _logEvent('qr_presence_validated');

  @override
  Future<void> logQrPresenceFailed({required QrScanError error}) =>
      _logEvent('qr_presence_failed', {'error_type': error.analyticsValue});
}
