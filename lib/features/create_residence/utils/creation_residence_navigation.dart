import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/create_residence/screens/amenities_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/description_editor_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/logement_location_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/logment_price_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/pictures_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/rules_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/type_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/video_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/wellcome_page.dart';

class CreationResidenceNavigation {
  static late PageController pageController;

  static ValueNotifier<int> stepperStateNotifier = ValueNotifier<int>(0);

  static void setStepe(int step) {
    stepperStateNotifier.value = step;
  }

  static int getPageIdByName(String pageName) {
    if (pageName == WellcommePage.name) {
      return 0;
    } else if (pageName == TypeLogmentPage.name) {
      return 1;
    } else if (pageName == AmentitiesPage.name) {
      return 2;
    } else if (pageName == LogmentLocationPage.name) {
      return 3;
    } else if (pageName == PicturesLogmentPage.name) {
      return 4;
    } else if (pageName == VideoLogmentPage.name) {
      return 5;
    } else if (pageName == RulesPage.name) {
      return 6;
    } else if (pageName == DescriptionEditorPage.name) {
      return 7;
    } else if (pageName == LogmentPricePage.name) {
      return 8;
    } else {
      throw ArgumentError("Page name inconnu : $pageName");
    }
  }

  static goToPage({
    required String pageName,
  }) {
    setStepe(getPageIdByName(pageName));
    pageController.animateToPage(
      getPageIdByName(pageName),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  static goToPageIndex({
    required int pageIndex,
  }) {
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
