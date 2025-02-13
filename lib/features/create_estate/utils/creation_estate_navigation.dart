import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_amenities_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_logement_location_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_logment_price_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_pictures_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_type_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_video_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_wellcome_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estatedescription_editor_page.dart';

class CreationEstateNavigation {
  static late PageController pageController;

  static ValueNotifier<int> stepperStateNotifier = ValueNotifier<int>(0);

  static void setStepe(int step) {
    stepperStateNotifier.value = step;
  }

  static int getPageIdByName(String pageName) {
    if (pageName == EstateWellcommePage.name) {
      return 0;
    } else if (pageName == EstateTypePage.name) {
      return 1;
    } else if (pageName == EstateAmentitiesPage.name) {
      return 2;
    } else if (pageName == EstateLogmentLocationPage.name) {
      return 3;
    } else if (pageName == EstatePicturesLogmentPage.name) {
      return 4;
    } else if (pageName == EstateVideoLogmentPage.name) {
      return 5;
    } else if (pageName == EstateDescriptionEditorPage.name) {
      return 6;
    } else if (pageName == EstateLogmentPricePage.name) {
      return 7;
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
