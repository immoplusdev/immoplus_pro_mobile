// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:immoplus_pro/utils/hex_color.dart';

class Constantes {
  static String tempPage = '/home';
  static var globalkey = GlobalKey<NavigatorState>();
  static const String visitToAsk = "visit_to_ask";
  static const String toOrder = 'to_order';
  static const String service = 'service';
  static const String toContact = 'to_contact';
  static const String mooving = 'mooving';
  static const String booking = 'booking';
  static String mapToken = dotenv.env['GOOGLE_KEY'] ?? '';
  static late BuildContext appContext;
  static test() {}

  // static visibilityVisitAndBooking(
  //         {required ProductDetailModel productDetailModel}) =>
  //     (productDetailModel.category!.productType == booking) ||
  //     (productDetailModel.category!.productType == visitToAsk);
  // static visibilityBooking({required ProductDetailModel productDetailModel}) =>
  //     (productDetailModel.category!.productType == booking);
  // static visibilityOrder({required ProductDetailModel productDetailModel}) =>
  //     (productDetailModel.category!.productType == toOrder);
  // static visibilityContact({required ProductDetailModel productDetailModel}) =>
  //     (productDetailModel.category!.productType == toContact);
  BuildContext context;
  Constantes({required this.context});
  static ColorScheme colorScheme = ColorScheme(
    primary: HexColor.fromHex("#2072ca"),
    secondary: const Color(0xFFABABAB),
    surface: const Color.fromARGB(255, 166, 173, 180),
    error: const Color(0xFFFFFFFF),
    onPrimary: const Color(0xFFFFFFFF),
    onSecondary: HexColor.fromHex("04b4fc"),
    onSurface: const Color(0xFF3E3C3C),
    onError: const Color(0xFFFFFFFF),
    brightness: Brightness.light,
  );

  static String url = "api.immoplus.ci";
  static Shadow textShadow = const Shadow(
      offset: Offset(0.0, 0.0),
      blurRadius: 10.0,
      color: Color.fromRGBO(0, 0, 0, 1));
}

enum ProductType {
  visit_to_ask,

  to_order,

  to_contact,

  service,

  booking,
}

enum ServiceType {
  commande,
  service,
  visite,
}

enum ServicesCollection {
  demandes_visites,
  reservations,
}

enum ServiceStatus {
  pending,
  successful,
  failed,
  en_cours_validation_user,
  en_cours_validation_admin,
}

enum PaymentStatus {
  payment_required,
  processing,
  action_required,
  waiting_for_validation,
  pending,
  failed,
  successful,
  paye,
  non_paye,
}

enum DeliveryMethod {
  moto,
  camion,
}

enum ShippingStatus {
  successful,
  failed,
  en_cours_recuperation,
  en_cours_livraison,
}

enum NotificationCollection {
  payments,
}
