// Harnais : réservations en attente (données simulées, sans réseau ni authentification)
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/app/design_system/theme/theme_config.dart';
import 'package:immoplus_pro/app/design_system/tokens/app_typography.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.config.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/models/reservations/client_model.dart';
import 'package:immoplus_pro/data/models/reservations/owner_invitation_model.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/booking/logic/booking_cubit.dart';
import 'package:immoplus_pro/features/reservations/invitations/owner_invitations_cubit.dart';
import 'package:immoplus_pro/features/reservations/invitations/owner_invitations_state.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_cubit.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_page.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:toastification/toastification.dart';

/// Cubit simulé pour les réservations en attente : gère la pagination et les filtres localement.
class _FakePendingReservationsCubit extends PendingReservationsCubit {
  final List<ReservationModel> enAttenteReponse;
  final List<ReservationModel> enAttentePaiement;

  _FakePendingReservationsCubit({
    required this.enAttenteReponse,
    required this.enAttentePaiement,
  });

  @override
  void init() {
    pagingController.addPageRequestListener((_) {
      if (currentFilter == PendingReservationFilter.enAttenteReponse) {
        pagingController.appendLastPage(List.from(enAttenteReponse));
      } else {
        pagingController.appendLastPage(List.from(enAttentePaiement));
      }
    });
  }

  @override
  Future<void> accepter(String reservationId) async {
    enAttenteReponse.removeWhere((item) => item.id == reservationId);
    pagingController.refresh();
    emit(const RequestState.success(message: "Réservation acceptée"));
  }

  @override
  Future<bool> refuser(String reservationId, {String? notes}) async {
    enAttenteReponse.removeWhere((item) => item.id == reservationId);
    pagingController.refresh();
    emit(const RequestState.success(message: "Réservation refusée"));
    return true;
  }
}

/// Cubit simulé pour les invitations "reverse search".
class _FakeOwnerInvitationsCubit extends OwnerInvitationsCubit {
  final List<OwnerInvitationItem> invitations;

  _FakeOwnerInvitationsCubit({required this.invitations});

  @override
  Future<void> load() async {
    emit(OwnerInvitationsLoaded(List.from(invitations)));
  }

  @override
  Future<bool> confirm(OwnerInvitationItem item) async {
    invitations.removeWhere((i) => i.id == item.id);
    emit(OwnerInvitationsLoaded(List.from(invitations)));
    return true;
  }

  @override
  Future<bool> decline(OwnerInvitationItem item, {String? motif}) async {
    invitations.removeWhere((i) => i.id == item.id);
    emit(OwnerInvitationsLoaded(List.from(invitations)));
    return true;
  }
}

List<OwnerInvitationItem> _sampleInvitations() => [
      OwnerInvitationItem(
        reverseSearchId: 'rev-001',
        residenceId: 'res-001',
        nom: 'Demande urgente : Villa 4 pièces avec jardin',
        adresse: 'Cocody Riviera Golf, Abidjan',
        montant: 450000,
        dateDebut: DateTime.now().add(const Duration(days: 3)),
        dateFin: DateTime.now().add(const Duration(days: 8)),
        expiresAt: DateTime.now().add(const Duration(hours: 14)),
      ),
    ];

List<ReservationModel> _sampleEnAttenteReponse() => [
      ReservationModel(
        id: 'res-rep-001',
        codeReservation: 'RES-84920',
        dateDebut:
            DateTime.now().add(const Duration(days: 2)).toIso8601String(),
        dateFin:
            DateTime.now().add(const Duration(days: 6)).toIso8601String(),
        statusReservation: 'en_attente_reponse',
        montantTotalReservation: 280000,
        delaisProprietaireReponse:
            DateTime.now().add(const Duration(hours: 18)).toIso8601String(),
        residence: const ResidenceModel(
          id: 'prop-001',
          nom: 'Appartement Deluxe Vue Lagune',
          adresse: 'Plateau, Boulevard Lagunaire',
          commune: 'Plateau',
          ville: 'Abidjan',
          prixReservation: 70000,
        ),
        client: const ClientModel(
          id: 'cli-001',
          firstName: 'Koffi',
          lastName: 'Kouassi',
          phoneNumber: '+225 07 12 34 56 78',
          email: 'koffi.kouassi@email.com',
        ),
      ),
      ReservationModel(
        id: 'res-rep-002',
        codeReservation: 'RES-84921',
        dateDebut:
            DateTime.now().add(const Duration(days: 5)).toIso8601String(),
        dateFin:
            DateTime.now().add(const Duration(days: 12)).toIso8601String(),
        statusReservation: 'en_attente_reponse',
        montantTotalReservation: 665000,
        delaisProprietaireReponse:
            DateTime.now().add(const Duration(hours: 6)).toIso8601String(),
        residence: const ResidenceModel(
          id: 'prop-002',
          nom: 'Villa Océane avec Piscine privée',
          adresse: 'Assinie Mafia, Km 8',
          commune: 'Assinie',
          ville: 'Assinie',
          prixReservation: 95000,
        ),
        client: const ClientModel(
          id: 'cli-002',
          firstName: 'Aïssata',
          lastName: 'Diallo',
          phoneNumber: '+225 05 98 76 54 32',
          email: 'aissata.diallo@email.com',
        ),
      ),
    ];

List<ReservationModel> _sampleEnAttentePaiement() => [
      ReservationModel(
        id: 'res-pay-001',
        codeReservation: 'RES-72103',
        dateDebut:
            DateTime.now().add(const Duration(days: 1)).toIso8601String(),
        dateFin:
            DateTime.now().add(const Duration(days: 4)).toIso8601String(),
        statusReservation: 'en_attente_paiement_client',
        statusFacture: 'non_paye',
        montantTotalReservation: 150000,
        delaisPaiementClient:
            DateTime.now().add(const Duration(hours: 10)).toIso8601String(),
        residence: const ResidenceModel(
          id: 'prop-003',
          nom: 'Studio Cosy Deux Plateaux',
          adresse: 'Cocody Deux Plateaux Vallons',
          commune: 'Cocody',
          ville: 'Abidjan',
          prixReservation: 50000,
        ),
        client: const ClientModel(
          id: 'cli-003',
          firstName: 'Marc',
          lastName: 'Gomez',
          phoneNumber: '+225 01 44 55 66 77',
          email: 'marc.gomez@email.com',
        ),
      ),
      ReservationModel(
        id: 'res-pay-002',
        codeReservation: 'RES-72104',
        dateDebut:
            DateTime.now().add(const Duration(days: 7)).toIso8601String(),
        dateFin:
            DateTime.now().add(const Duration(days: 10)).toIso8601String(),
        statusReservation: 'en_attente_paiement_client',
        statusFacture: 'non_paye',
        montantTotalReservation: 375000,
        delaisPaiementClient:
            DateTime.now().add(const Duration(hours: 22)).toIso8601String(),
        residence: const ResidenceModel(
          id: 'prop-004',
          nom: 'Duplex Prestige Zone 4',
          adresse: 'Marcory Zone 4C, Rue du Canal',
          commune: 'Marcory',
          ville: 'Abidjan',
          prixReservation: 125000,
        ),
        client: const ClientModel(
          id: 'cli-004',
          firstName: 'Christelle',
          lastName: "N'Guessan",
          phoneNumber: '+225 07 88 99 00 11',
          email: 'christelle.nguessan@email.com',
        ),
      ),
    ];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);

  // Initialise le conteneur d'injection GetIt si non initialisé
  if (!getIt.isRegistered<SessionManager>()) {
    getIt.init();
  }

  // Session simulée pour éviter les erreurs d'authentification
  SessionManager().currentUser = UserModelSchema()
    ..userId = 'mock-pro-user-id'
    ..firstName = 'Josias'
    ..lastName = 'Ezechiel'
    ..roleName = 'pro_particulier';

  Widget pageWithMock(
      {bool empty = false, PendingReservationFilter? initialFilter}) {
    final cubit = _FakePendingReservationsCubit(
      enAttenteReponse: empty ? [] : _sampleEnAttenteReponse(),
      enAttentePaiement: empty ? [] : _sampleEnAttentePaiement(),
    );
    if (initialFilter != null) {
      cubit.setFilter(initialFilter);
    }
    cubit.init();

    final invitationsCubit = _FakeOwnerInvitationsCubit(
      invitations: empty ? [] : _sampleInvitations(),
    );
    invitationsCubit.load();

    return PendingReservationsPage(
      cubit: cubit,
      invitationsCubit: invitationsCubit,
      initialFilter: initialFilter,
    );
  }

  final router = GoRouter(
    initialLocation: '/pending/payment',
    routes: [
      GoRoute(
        path: '/menu',
        builder: (context, state) => const _DevMenu(),
      ),
      GoRoute(
        path: '/pending',
        builder: (context, state) => pageWithMock(empty: false),
      ),
      GoRoute(
        path: '/pending/payment',
        builder: (context, state) => pageWithMock(
          empty: false,
          initialFilter: PendingReservationFilter.enAttentePaiement,
        ),
      ),
      GoRoute(
        path: '/pending/empty',
        builder: (context, state) => pageWithMock(empty: true),
      ),
    ],
  );

  final theme = ThemeData(
    textTheme: AppTypography.lightTextTheme(),
    useMaterial3: false,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFFF8F9FA),
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: Colors.white,
      titleTextStyle: AppTypography.h4.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondaryContainer: Colors.white,
      onPrimary: Colors.white,
      surface: Colors.white,
      secondary: const Color.fromARGB(255, 229, 228, 228),
      onSecondary: Colors.white,
    ),
  );

  runApp(
    BlocProvider(
      create: (_) => BookingCubit(),
      child: MaterialApp.router(
        title: 'Harnais · Réservations en attente',
        debugShowCheckedModeBanner: false,
        theme: theme,
        routerConfig: router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fr', 'FR')],
        builder: (context, child) => ToastificationWrapper(
          child: EasyLoading.init()(context, child),
        ),
      ),
    ),
  );
}

class _DevMenu extends StatelessWidget {
  const _DevMenu();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harnais Dev · ImmoPlus Pro'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            ListTile(
              leading: const Icon(Icons.list_alt, color: Colors.blue),
              title: const Text('Réservations en attente (avec données)'),
              subtitle: const Text(
                  'Invitations, réservations à confirmer et en attente paiement'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/pending'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.hourglass_empty, color: Colors.orange),
              title: const Text('Réservations en attente (état vide)'),
              subtitle: const Text('Aucune réservation en attente'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => context.push('/pending/empty'),
            ),
          ],
        ),
      ),
    );
  }
}

