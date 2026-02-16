import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/common/enums.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/constantes/immo_icons.dart';
import 'package:immoplus_pro/cubits/authentification/delete_account_cubit.dart';
import 'package:immoplus_pro/cubits/authentification/delete_account_cubit_state.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/account/widgets/edit_account.dart';
import 'package:immoplus_pro/features/booking/booking_history_page.dart';
import 'package:immoplus_pro/features/estates/estates_page.dart';
import 'package:immoplus_pro/features/home_page/pages/general_condition_page.dart';
import 'package:immoplus_pro/features/profil/update_password_page.dart';
import 'package:immoplus_pro/features/residence/residences_page.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_chip.dart';
import 'package:immoplus_pro/features/visits/visit_history_page.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:shimmer/shimmer.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  final sessionManager = SessionManager();
  UserModelSchema? currentUser;

  @override
  void initState() {
    super.initState();

    currentUser = sessionManager.currentUser;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.scafold,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              color: AppColors.scafold,
              child: DrawerHeader(
                // decoration: BoxDecoration(
                //   color: Colors.blue,
                // ),

                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CachedNetworkImage(
                          imageUrl: (currentUser!.avatar != null)
                              ? Utils.getImagePath(id: currentUser!.avatar!)
                              : "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg",
                          //"https://t3.ftcdn.net/jpg/03/91/34/72/240_F_391347204_XaDg0S7PtbzJRoeow3yWO1vK4pnqBVQY.jpg",

                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade400,
                            period: const Duration(milliseconds: 500),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit
                              .cover, // or other BoxFit values as per your design
                        ),
                      ),
                    ),
                    const Gap(5),
                    (currentUser!.isEntreprise)
                        ? AutoSizeText(
                            "Entreprise : ${currentUser?.nomEntreprise}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          )
                        : AutoSizeText(
                            '${currentUser?.firstName} ${currentUser?.lastName}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                    //Text('test@gmail.com'),
                    //AutoSizeText("${currentUser?.phoneNumber}"),
                    AutoSizeText(
                      currentUser?.email ?? "",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: [
                  UnconstrainedBox(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow.shade700,
                            Colors.orange.shade600,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          getRoleDescription(currentUser?.role ?? ''),
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ) ??
                                  const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),

                  Gap(8),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                        20,
                      ),
                      topRight: Radius.circular(
                        20,
                      ),
                    )),
                    tileColor: Colors.white,
                    onTap: () {
                      context.pushNamed(ResidencesPage.name);
                    },
                    horizontalTitleGap: 0,
                    leading: ImmoIcon(ImmoIcons.resi, color: AppColors.primary),

                    // Icon(
                    //   FontAwesomeIcons.key,
                    //   color: AppColors.primary,
                    //   size: 20,
                    // ),
                    title: const Text('Mes résidences'),

                    trailing: Icon(
                      FontAwesomeIcons.circleChevronRight,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  // if (currentUser!.isEntreprise)
                  const Divider(
                    height: 0,
                    thickness: 0.8,
                  ),
                  // if (currentUser!.isEntreprise)
                  ListTile(
                    tileColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(
                          20,
                        ),
                        bottomLeft: Radius.circular(
                          20,
                        ),
                      ),
                    ),
                    onTap: () {
                      context.pushNamed(EstatesPage.name);
                    },
                    horizontalTitleGap: 0,
                    leading: Icon(
                      FontAwesomeIcons.treeCity,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    title: const Text('Biens immobiliers'),
                    trailing: Icon(
                      FontAwesomeIcons.circleChevronRight,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  const Gap(10),
                  ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                        20,
                      ),
                      topRight: Radius.circular(
                        20,
                      ),
                    )),
                    tileColor: Colors.white,
                    onTap: () {
                      context.pushNamed(BookingHistoryPage.name);
                    },
                    horizontalTitleGap: 0,
                    leading: Icon(
                      FontAwesomeIcons.suitcaseRolling,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    title: const AutoSizeText(
                      'Historique des réservations',
                      maxLines: 1,
                    ),
                    trailing: Icon(
                      FontAwesomeIcons.circleChevronRight,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  // if (currentUser!.isEntreprise)
                  const Divider(
                    height: 0,
                    thickness: 0.8,
                  ),
                  // if (currentUser!.isEntreprise)
                  ListTile(
                    tileColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(
                          20,
                        ),
                        bottomLeft: Radius.circular(
                          20,
                        ),
                      ),
                    ),
                    onTap: () {
                      context.pushNamed(VisitHistoryPage.name);
                    },
                    horizontalTitleGap: 0,
                    leading: Icon(
                      FontAwesomeIcons.route,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    title: const AutoSizeText(
                      'Historique des visites',
                      maxLines: 1,
                    ),
                    trailing: Icon(
                      FontAwesomeIcons.circleChevronRight,
                      size: 15,
                      color: AppColors.primary,
                    ),
                  ),
                  const Gap(20),
                  ListTile(
                    tileColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                          20,
                        ),
                        topLeft: Radius.circular(
                          20,
                        ),
                      ),
                    ),
                    onTap: () async {
                      await context.pushNamed(EditAccount.name);

                      currentUser = sessionManager.currentUser;

                      if (mounted) {
                        setState(() {});
                      }
                    },
                    horizontalTitleGap: 0,
                    leading: Icon(
                      FontAwesomeIcons.userPen,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    title: const Text('Modifier mes informations'),
                    // trailing: Icon(
                    //   FontAwesomeIcons.circleChevronRight,
                    //   size: 15,
                    //   color: AppColors.primary,
                    // ),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0.8,
                  ),
                  ListTile(
                    tileColor: Colors.white,
                    horizontalTitleGap: 0,
                    leading: Icon(
                      FontAwesomeIcons.userShield,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    title: const Text('Modifier mot de passe'),
                    onTap: () => context.pushNamed(UpdatePasswordPage.name),
                    // trailing: Icon(
                    //   FontAwesomeIcons.circleChevronRight,
                    //   size: 15,
                    //   color: AppColors.primary,
                    // ),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0.8,
                  ),
                  ListTile(
                    tileColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(
                          20,
                        ),
                        bottomRight: Radius.circular(
                          20,
                        ),
                      ),
                    ),
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
                    horizontalTitleGap: 0,
                    leading: Icon(
                      FontAwesomeIcons.fileContract,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    title: const Text("Conditions générales d’utilisation"),
                  ),
                  const Gap(20),
                  ListTile(
                    horizontalTitleGap: 0,
                    leading: const Icon(
                      FontAwesomeIcons.arrowRightFromBracket,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    title: const Text(
                      "Se déconnecter",
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                    onTap: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: const Text('Déconnexion'),
                            content: const Text(
                                'Êtes-vous sûr de vouloir vous déconnecter ?'),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Ferme la pop-up sans se déconnecter
                                },
                                child: const Text('Annuler'),
                              ),
                              CupertinoDialogAction(
                                isDestructiveAction: true,
                                onPressed: () async {
                                  await SessionManager().logout();
                                },
                                child: const Text('Déconnexion'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  /// Delete account button
                  ListTile(
                    horizontalTitleGap: 0,
                    leading: const Icon(
                      FontAwesomeIcons
                          .trashCan, // Icon plus appropriée pour la suppression
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    title: const Text(
                      "Supprimer mon compte",
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                    onTap: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return BlocProvider(
                            create: (context) => DeleteAccountCubit(),
                            child: BlocConsumer<DeleteAccountCubit,
                                DeleteAccountState>(
                              listener: (context, state) {},
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
                                          context
                                              .read<DeleteAccountCubit>()
                                              .deleteAccount();
                                        },
                                      ),
                                      child: state.maybeWhen(
                                        loading: () =>
                                            const CupertinoActivityIndicator(),
                                        orElse: () =>
                                            const Text('Oui, supprimer'),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
