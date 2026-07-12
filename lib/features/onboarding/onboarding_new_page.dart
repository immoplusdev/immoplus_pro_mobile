import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/features/authentification/authentification_page.dart';
import 'package:immoplus_pro/features/notification/widgets/notification_actif_sheet.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/services/notification_actif_service.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OnboardingNewPage extends StatefulWidget {
  const OnboardingNewPage({super.key});
  static String name = 'ONBOARDING_NEW';
  @override
  _OnboardingNewPageState createState() => _OnboardingNewPageState();
}

class _Constants {
  // Colors
  static const Color titleColor = Color(0xFF001B3D);
  static const Color backgroundColor = Colors.white;
  static const Color dotInactiveColor =
      Color(0xFFE0E0E0); // Colors.grey.shade300

  // Typography
  static const double titleFontSize = 42.0;
  static const FontWeight titleFontWeight = FontWeight.w800;
  static const double titleHeight = 1.1;
  static const double buttonFontSize = 18.0;

  // Spacing & Layout
  static const double horizontalPadding = 24.0;
  static const double buttonPadding = 40.0;
  static const double dotBottomPosition = 40.0;
  static const double dotHeight = 10.0;
  static const double dotWidth = 35.0;
  static const double dotMargin = 4.0;
  static const double slideGapTop = 80.0;
  static const double slideGapBottom = 100.0;
  static const double gradientHeightLarge = 200.0;
  static const double gradientHeightSmall = 150.0;
  static const double buttonBorderRadius = 25.0;

  // Animation
  static const int animationDurationMs = 300;
}

class _OnboardingNewPageState extends State<OnboardingNewPage> {
  final sessionManager = getIt<SessionManager>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnBoardingItem> items = [
    OnBoardingItem(
      title: "Gérez tout\nau même\nendroit",
      image: "assets/img/onboarding/1_v2.png",
    ),
    OnBoardingItem(
      title: "Gagnez de\nl’argent en\ntoute sécurité",
      image: "assets/img/onboarding/2_v2.png",
    ),
    OnBoardingItem(
      title: "Publiez vos\nbiens\nfacilement",
      image: "assets/img/onboarding/3_v2.png",
    ),
  ];

  Future<void> _navigateLoginPage() async {
    await sessionManager.markOnboardingAsRead();
    if (mounted) {
      context.goNamed(AuthenticationPage.name);
    }
  }

  void _showNotificationModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetCtx) => NotificationActifSheet(
        onAccept: () async {
          Navigator.of(sheetCtx).pop();
          await NotificationActifService.setStatus(NotificationActifService.accepted);
          await OneSignal.Notifications.requestPermission(true);
          await _navigateLoginPage();
        },
        onMaybeLater: () async {
          Navigator.of(sheetCtx).pop();
          await NotificationActifService.setStatus(NotificationActifService.maybeLater);
          await _navigateLoginPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.sen(
      fontSize: _Constants.titleFontSize,
      fontWeight: _Constants.titleFontWeight,
      color: _Constants.titleColor,
      height: _Constants.titleHeight,
    );

    return Scaffold(
      backgroundColor: _Constants.backgroundColor,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: items.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildPage(index, titleStyle);
            },
          ),
          // Pagination Dots
          Positioned(
            bottom: _Constants.dotBottomPosition,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(items.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(
                      milliseconds: _Constants.animationDurationMs),
                  margin: const EdgeInsets.symmetric(
                      horizontal: _Constants.dotMargin),
                  height: _Constants.dotHeight,
                  width: _Constants.dotWidth,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.customBlue
                        : _Constants.dotInactiveColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index, TextStyle titleStyle) {
    final item = items[index];

    return Column(
      children: [
        if (index == 0) ...[
          // Slide 1: Image top (faded), Title bottom
          Expanded(
            flex: 7,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    item.image,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: _Constants.gradientHeightLarge,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(0.8),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _Constants.horizontalPadding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.title,
                style: titleStyle,
              ),
            ),
          ),
          const Spacer(flex: 2),
        ] else if (index == 1) ...[
          // Slide 2: Title top, Image middle (faded)
          const Gap(_Constants.slideGapTop),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _Constants.horizontalPadding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.title,
                style: titleStyle,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    item.image,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: _Constants.gradientHeightSmall,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(_Constants.slideGapBottom),
        ] else ...[
          // Slide 3: Title top, Image middle (faded), Button bottom
          const Gap(_Constants.slideGapTop),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _Constants.horizontalPadding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item.title,
                style: titleStyle,
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    item.image,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: _Constants.gradientHeightSmall,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: _Constants.buttonPadding),
            child: CustomButtom(
              text: "Démarrer",
              color: AppColors.customBlue,
              borderRadius:
                  BorderRadius.circular(_Constants.buttonBorderRadius),
              fontSize: _Constants.buttonFontSize,
              onClick: _showNotificationModal,
            ),
          ),
          const Gap(_Constants.slideGapBottom),
        ],
      ],
    );
  }
}

class OnBoardingItem {
  final String title;
  final String image;

  OnBoardingItem({
    required this.title,
    required this.image,
  });
}

