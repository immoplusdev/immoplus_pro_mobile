import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/features/home_page/pages/booking_page.dart';
import 'package:immoplus_pro/features/home_page/pages/earning_page.dart';
import 'package:immoplus_pro/features/home_page/pages/visit_page.dart';

class HomeRouter {
  static late GoRouter router;

  static void setup() {
    router = GoRouter(
      initialLocation: '/booking',
      routes: [
        GoRoute(
          path: '/booking',
          name: BookingPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              const BookingPage(),
        ),
        GoRoute(
          path: '/visit',
          name: VisitPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              const VisitPage(),
        ),
        GoRoute(
          path: '/earning',
          name: EarningPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              const EarningPage(),
        ),
      ],
    );
  }
}
