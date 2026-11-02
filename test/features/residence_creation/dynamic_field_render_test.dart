import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_cubit.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_state.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';
import 'package:immoplus_pro/features/residence_creation/repositories/residence_creation_repository.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/step/step_content.dart';
import 'package:immoplus_pro/services/analytics_service.dart';

class _FakeAnalytics implements AnalyticsService {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

class _FakeRepository implements ResidenceCreationRepository {
  @override
  Future<CreationFlow> getCreationFlow() async {
    final json = jsonDecode(
      File('test/features/residence_creation/fixtures/creation_flow.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;
    return CreationFlow.fromJson(json['data'] as Map<String, dynamic>);
  }

  @override
  Future<List<CatalogGroup>> getCatalog(String catalogEndpoint,
      {String? search}) async {
    return [
      CatalogGroup(key: 'G', label: 'Groupe', items: [
        const CatalogItem(code: 'WIFI', label: 'Wifi', countKey: 'wifis'),
        const CatalogItem(code: 'VILLA', label: 'Villa', countKey: 'villas'),
      ]),
    ];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

/// Les tests rendent le texte avec une police de repli ~2x plus large que
/// Plus Jakarta Sans ; on réduit l'échelle pour approcher la largeur réelle.
Widget _withRealisticTextWidth(BuildContext context, Widget? child) =>
    MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(0.55)),
      child: child!,
    );

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    getIt.registerSingleton<AnalyticsService>(_FakeAnalytics());
  });

  testWidgets('chaque étape de la configuration réelle s\'affiche',
      (tester) async {
    // Écran très haut : le ListView construit tous les champs.
    tester.view.physicalSize = const Size(390, 8000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final cubit = ResidenceCreationCubit(repository: _FakeRepository());
    await cubit.load();
    addTearDown(cubit.close);

    final stepCount = cubit.state.flow!.steps.length;
    for (var step = 0; step < stepCount; step++) {
      // Montre aussi les champs conditionnels.
      cubit.setValue('advanceNoticeDays', 0);
      cubit.setValue('weekendPricingEnabled', true);
      cubit.setValue('position', const GeoPoint(latitude: 1, longitude: 2));

      await tester.pumpWidget(
        MaterialApp(
          builder: _withRealisticTextWidth,
          home: BlocProvider.value(
            value: cubit,
            child: BlocBuilder<ResidenceCreationCubit, ResidenceCreationState>(
              builder: (context, state) => Scaffold(
                body: ListView(
                  children: [
                    StepContent(
                      step: state.flow!.steps[step],
                      state: state,
                      cubit: cubit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull, reason: 'étape ${step + 1}');
    }
  });
}
