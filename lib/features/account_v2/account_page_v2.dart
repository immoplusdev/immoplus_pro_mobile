import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/authentification/delete_account_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/delete_account_cubit_state.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/account/widgets/edit_account.dart';
import 'package:immoplus_pro/features/home_page/pages/general_condition_page.dart';
import 'package:immoplus_pro/features/contact_change/view/change_credentials_page.dart';
import 'package:immoplus_pro/features/ratings/pages/ratings_history_page.dart';
import 'package:immoplus_pro/gen/assets.gen.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/utils/utils.dart';

class AccountPageV2 extends StatefulWidget {
  const AccountPageV2({super.key});

  static String name = 'ACCOUNT_PAGE_V2';
  static const String routePath = '/account_v2';

  @override
  State<AccountPageV2> createState() => _AccountPageV2State();
}

class _AccountPageV2State extends State<AccountPageV2>
    with WidgetsBindingObserver {
  final sessionManager = SessionManager();
  UserModelSchema? currentUser;
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentUser = sessionManager.currentUser;
    _refreshNotificationStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshNotificationStatus();
    }
  }

  Future<void> _refreshNotificationStatus() async {
    if (!mounted) return;
    
    // On vérifie le statut réel dans le système du téléphone
    final osGranted = OneSignal.Notifications.permission;
    
    // On force l'abonnement ou le désabonnement pour s'aligner avec l'OS
    if (osGranted) {
      await OneSignal.User.pushSubscription.optIn();
    } else {
      await OneSignal.User.pushSubscription.optOut();
    }
    
    if (!mounted) return;
    
    // Le toggle reflète toujours 100% la réalité du téléphone
    setState(() {
      _notificationsEnabled = osGranted;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    // vers les paramètres spécifiques des notifications du système pour que 
    // l'utilisateur gère l'activation ou la désactivation.
    // Au retour dans l'application, didChangeAppLifecycleState mettra à jour
    // le toggle (bouton bleu ou gris) en lisant le statut réel de l'OS.
    await AppSettings.openAppSettings(type: AppSettingsType.notification);
  }



  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEAEDER BLEU
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                bottom: 30,
                left: 20,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    backgroundImage: (currentUser?.avatar != null)
                        ? CachedNetworkImageProvider(
                            Utils.getImagePath(id: currentUser!.avatar!))
                        : const NetworkImage(
                                "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg")
                            as ImageProvider,
                  ),
                  const Gap(15),
                  Text(
                    currentUser!.greetingText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(5),
                  const Text(
                    "Bienvenue dans votre dashboard",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const Gap(30),

            // SECTION 1 : Propriétés
            // _buildSection(
            //   title: "Propriétés",
            //   children: [
            //     _buildActionItem(
            //       icon: ImmoIcons.resi,
            //       title: "Mes résidences",
            //       onTap: () => context.pushNamed(ResidencesPage.name),
            //     ),
            //     _buildActionItem(
            //       icon: FontAwesomeIcons.treeCity,
            //       title: "Biens immobiliers",
            //       onTap: () => context.pushNamed(EstatesPage.name),
            //       isLast: currentUser?.roleName == Roles.customer.name,
            //     ),
            //     if (currentUser?.roleName != Roles.customer.name)
            //       _buildActionItem(
            //         icon: FontAwesomeIcons.couch,
            //         title: "Mes meubles",
            //         onTap: () => context.pushNamed(FurnituresPage.name),
            //         isLast: true,
            //       ),
            //   ],
            // ),

            // const Gap(25),

            // // SECTION 2 : Historiques
            // _buildSection(
            //   title: "Historiques et réservations",
            //   children: [
            //     _buildActionItem(
            //       icon: Icons.pending_actions_outlined,
            //       title: "Réservations en attente",
            //       onTap: () => context.push(PendingReservationsPage.route()),
            //     ),
            //     _buildActionItem(
            //       icon: FontAwesomeIcons.suitcaseRolling,
            //       title: "Historique des réservations",
            //       onTap: () => context.pushNamed(BookingHistoryPage.name),
            //     ),
            //     _buildActionItem(
            //       icon: FontAwesomeIcons.route,
            //       title: "Historique des visites",
            //       onTap: () => context.pushNamed(VisitHistoryPage.name),
            //       isLast: true,
            //     ),
            //   ],
            // ),

            const Gap(25),

            // SECTION : Notifications
            _buildSection(
              title: "Notifications",
              children: [
                _buildNotificationToggle(),
              ],
            ),

            const Gap(25),

            // SECTION : Avis et Évaluations
            _buildSection(
              title: "Avis & Évaluations",
              children: [
                _buildActionItem(
                  iconData: Iconsax.star,
                  title: "Historique des évaluations",
                  onTap: () => context.push(RatingsHistoryPage.routePath()),
                  isLast: true,
                ),
              ],
            ),

            const Gap(25),

            // SECTION 3 : Paramètres de compte
            _buildSection(
              title: "Paramètres de compte",
              children: [
                _buildActionItem(
                  icon: Assets.svgs.userEdit,
                  title: "Modifier mes informations",
                  onTap: () async {
                    await context.pushNamed(EditAccount.name);
                    currentUser = sessionManager.currentUser;
                    if (mounted) setState(() {});
                  },
                ),
                _buildActionItem(
                  icon: Assets.svgs.userSquare,
                  title: "Changer mes identifiants de connexion",
                  onTap: () => context.pushNamed(ChangeCredentialsPage.name),
                ),
                _buildActionItem(
                  icon: Assets.svgs.documentText,
                  title: "Conditions générales d'utilisation",
                  onTap: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      isScrollControlled: true,
                      showDragHandle: true,
                      context: context,
                      builder: (context) => const FractionallySizedBox(
                          heightFactor: 0.9, child: GeneralConditionPage()),
                    );
                  },
                  isLast: true,
                ),
              ],
            ),

            const Gap(40),

            // DÉCONNEXION
            Center(
              child: TextButton.icon(
                onPressed: _showLogoutDialog,
                icon: const Icon(Iconsax.logout, color: Colors.redAccent),
                label: const Text(
                  "Déconnexion",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const Gap(15),

            Center(
              child: TextButton(
                onPressed: _showDeleteAccountDialog,
                child: const Text(
                  "Supprimer mon compte",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ),
        const Gap(15),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationToggle() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        child: SvgPicture.asset(
          'assets/icons/notification-bing.svg',
          width: 14,
          height: 14,
          colorFilter: ColorFilter.mode(
            _notificationsEnabled ? AppColors.primary : Colors.grey,
            BlendMode.srcIn,
          ),
        ),
      ),
      title: const Text(
        "Activer les notifications",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
      trailing: Switch.adaptive(
        value: _notificationsEnabled,
        onChanged: _toggleNotifications,
        activeColor: Colors.white,
        activeTrackColor: AppColors.primary,
      ),
    );
  }

  Widget _buildActionItem({
    String? icon,
    IconData? iconData,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          leading: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: iconData != null
                  ? Icon(iconData, color: AppColors.primary, size: 22)
                  : SvgPicture.asset(icon!),
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: AppColors.primary,
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey.shade300,
            indent: 70,
            endIndent: 20,
          ),
      ],
    );
  }

  void _showLogoutDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Annuler'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () async {
                // SessionManager.logout() ferme tous les dialogs ouverts
                // via navigatorKey avant de naviguer — pas besoin de pop() ici.
                await SessionManager().logout();
              },
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog() {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider(
          create: (context) => DeleteAccountCubit(),
          child: BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
            listener: (context, state) {
              state.maybeWhen(
                success: () async {
                  Navigator.of(dialogContext).pop();
                  await SessionManager().logout();
                },
                orElse: () {},
              );
            },
            builder: (context, state) {
              return CupertinoAlertDialog(
                title: const Text('Suppression de compte'),
                content: const Text(
                  'Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.',
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: const Text('Annuler'),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: state.maybeWhen(
                      loading: () => null,
                      orElse: () => () {
                        context.read<DeleteAccountCubit>().deleteAccount();
                      },
                    ),
                    child: state.maybeWhen(
                      loading: () => const CupertinoActivityIndicator(),
                      orElse: () => const Text('Oui, supprimer'),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
