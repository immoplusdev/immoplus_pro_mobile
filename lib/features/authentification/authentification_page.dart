import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
import 'package:immoplus_pro/features/login_page/login_page.dart';
import 'package:immoplus_pro/features/login_page/register_page.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/gen/assets.gen.dart';
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
          // backgroundColor: HexColor("#121224"),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Color(0xFFFFFFFF),
                      Color(0xFFFFFEFE),
                      Color(0xFF64DCFD),
                      Color(0xFF156CE4),
                    ],
                    stops: const [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(appPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Gap(80),
                      _infoTile(label: "Publiez"),
                      _infoTile(label: "Gérez"),
                      _infoTile(label: "Encaissez"),
                      Gap(180),
                      Image.asset(
                        Assets.icon.iconRadius.path,
                        width: 63,
                        height: 63,
                      ),
                      Gap(15),
                      Text(
                          "Commencez à publier, gérer et vendre vos biens immobiliers",
                          // textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          )),
                      Gap(80),
                      CustomButtom(
                        text: "Connexion",
                        onClick: () {
                          context.pushNamed(LoginPage.name);
                        },
                        color: AppColors.customBlue,
                        borderRadius: BorderRadius.circular(43),
                      ),
                      Gap(6),
                      CustomButtom(
                        onClick: () {
                          context.pushNamed(RegisterPage.name);
                        },
                        color: AppColors.whiteBackground,
                        textColor: AppColors.black,
                        borderRadius: BorderRadius.circular(43),
                        child: FittedBox(
                          child: RichText(
                            text: TextSpan(
                              text: "Vous n’avez pas de compte ? ",
                              children: [
                                TextSpan(
                                  text: "Inscrivez-vous",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                )
                              ],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Gap(10),
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

  Widget _infoTile({required String label}) {
    return Text(
      label,
      style: TextStyle(
        color: AppColors.black,
        fontSize: 40,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
