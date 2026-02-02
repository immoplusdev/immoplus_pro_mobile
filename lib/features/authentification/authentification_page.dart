import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/features/authentification/registration_content.dart';
import 'package:immoplus_pro/features/login_page/pages/login_with_email_screen.dart';
import 'package:immoplus_pro/features/otp_login/otp_login_page.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/features/registration/pages/send_email_opt_page.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/features/registration/pages/enterprise_registration.dart';
import 'package:immoplus_pro/features/registration/pages/particulier_registration.dart';
import 'package:immoplus_pro/widgets/config_env.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key, this.initialTab = 0});
  static String name = "AUTHENTICATION_PAGE";
  final int initialTab; // 0 pour connexion, 1 pour inscription

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _loginPageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _loginPageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: EnvironmentsBadge(
        child: Scaffold(
          backgroundColor: HexColor("#121224"),
          body: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              // AppBar avec logo
              SliverAppBar(
                backgroundColor: HexColor("#121224"),
                leadingWidth: 35,
                automaticallyImplyLeading: false,
                actions: [
                  SvgPicture.asset(
                    'assets/icons/logo_immo.svg',
                    color: HexColor('#2072ca'),
                    width: 50,
                  ),
                  const Gap(20),
                ],
              ),
              const SliverGap(30),

              // Titre principal
              SliverToBoxAdapter(
                child: Center(
                  child: Text(
                    "Bienvenue sur ImmoPlus Pro",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              const SliverGap(8),

              // Sous-titre
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: AutoSizeText(
                      maxLines: 2,
                      "Gérez vos biens immobiliers en toute simplicité",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                    ),
                  ),
                ),
              ),
              const SliverGap(30),

              // TabBar personnalisé
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: HexColor('#2072ca'),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: HexColor('#2072ca').withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white.withOpacity(0.7),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      tabs: const [
                        Tab(
                          height: 48,
                          child: Text("Connexion"),
                        ),
                        Tab(
                          height: 48,
                          child: Text("Inscription"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverGap(20),

              // Contenu des onglets
              SliverFillRemaining(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Page de connexion (avec OTP et Email)
                      PageView(
                        controller: _loginPageController,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          OTPLoginPage(
                            rootPageController: _loginPageController,
                          ),
                          LoginWithEmailScreen(
                            rootPageController: _loginPageController,
                          ),
                        ],
                      ),

                      // Page d'inscription (choix Entreprise/Indépendant)
                      Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: appPadding),
                        child: SingleChildScrollView(
                          child: RegistrationContent(
                            entrepriseOnTap: () {
                              context.pushNamed(
                                SendEmailOptPage.name,
                                extra: {
                                  "onSuccess": (DataRouterRegistration
                                      dataRouterRegistration) {
                                    context.pushReplacementNamed(
                                      EnterpriseRegistrationPage.name,
                                      extra: dataRouterRegistration,
                                    );
                                  },
                                },
                              );
                            },
                            particulierOnTap: () {
                              context.pushNamed(SendEmailOptPage.name, extra: {
                                "onSuccess": (DataRouterRegistration
                                    dataRouterRegistration) {
                                  context.pushReplacementNamed(
                                    ParticulierRegistration.name,
                                    extra: dataRouterRegistration,
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
