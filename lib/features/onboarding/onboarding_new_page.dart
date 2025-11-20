import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/features/onboarding/data/onboarding_entity.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_button.dart';
import 'package:immoplus_pro/main.dart';
import 'package:immoplus_pro/splash_screen.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class OnboardingNewPage extends StatefulWidget {
  const OnboardingNewPage({super.key});
  static String name = 'ONBOARDING_NEW';
  @override
  _OnboardingNewPageState createState() => _OnboardingNewPageState();
}

class _OnboardingNewPageState extends State<OnboardingNewPage> {
  // Future<void> _endOnboarding() async {
  //   await isarInstance.writeTxn(
  //     () async {
  //       await isarInstance.onboardingEntitys
  //           .put(OnboardingEntity(id: 1, opened: true));
  //     },
  //   );
  // }

  /// Navigation vers la page d'accueil après avoir marqué l'onboarding comme lu
  Future<void> _navigateToHome() async {
    await SessionManager().markOnboardingAsRead();
    if (mounted) {
      context.goNamed(SplashScreen.name);
    }
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // PageView

            Expanded(
              flex: 4,
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  _buildPage(
                    imagePath: "assets/img/onboarding/onb_1.jpg",
                    color: Colors.blueAccent,
                    title: "Bienvenue sur ImmoPlus Pro",
                    content:
                        "Découvrez une plateforme dédiée aux professionnels de l'immobilier pour gérer facilement leurs logements et réservations.",
                  ),
                  _buildPage(
                    imagePath: "assets/img/onboarding/onb_2.jpg",
                    color: Colors.greenAccent,
                    title: "Publiez vos résidences et gérez vos réservations",
                    content:
                        "Ajoutez vos biens en quelques clics et recevez directement les réservations des clients intéressés.",
                  ),
                  _buildPage(
                    imagePath: "assets/img/onboarding/onb_3.jpg",
                    color: Colors.orangeAccent,
                    title: "Boostez la visibilité de vos maisons à louer",
                    content:
                        "Mettez vos logements en avant et facilitez les visites en planifiant des rendez-vous avec les potentiels locataires.",
                  ),
                  _buildPage(
                    imagePath: "assets/img/onboarding/login.jpg",
                    color: Colors.orangeAccent,
                    title: "Prêt à optimiser votre gestion immobilière ?",
                    content:
                        "Profitez d'ImmoPlus Pro pour simplifier votre activité et maximiser vos opportunités. Bonne utilisation ! 🚀",
                  ),
                ],
              ),
            ),
            // Stepper (dots indicator)
            SizedBox(
              height: 40,
              //color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 10,
                    width: _currentPage == index ? 20 : 10,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }),
              ),
            ),
            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButtom(
                text: _currentPage < 3
                    ? "Suivant".toUpperCase()
                    : "Commencer".toUpperCase(),
                onClick: () async {
                  if (_currentPage < 3) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    print("Onboarding terminé !");
                    _navigateToHome();
                  }
                },
              ),
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButtom(
                text: 'Passer',
                onClick: () async {
                  _navigateToHome();
                },
                color: Colors.white,
                textColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
      {required Color color,
      required String title,
      required String content,
      required imagePath}) {
    return Container(
      //color: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade300,
                ),
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20), // Applique les bords arrondis à l'image
                  child: Image.asset(
                    imagePath, // Chemin de l'image locale
                    width: 280,
                    // height: 380,
                    fit: BoxFit
                        .cover, // Ajuste l'image pour remplir le conteneur
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    maxLines: 2,
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: AutoSizeText(
                      maxLines: 4,
                      content,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
