import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_cubit.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_state.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/repositories/residence_creation_repository.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/option_fields.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/layout/creation_tips.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/step/step_content.dart';
import 'package:immoplus_pro/services/analytics_service.dart';

class _FakeAnalytics implements AnalyticsService {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

class _FakeBookingRepository implements ResidenceCreationRepository {
  @override
  Future<CreationFlow> getCreationFlow() async => CreationFlow.fromJson({
        'flowVersion': '1',
        'intent': 'STAY',
        'title': 'Nouvelle résidence',
        'steps': [
          {
            'key': 'booking',
            'title': 'Comment souhaitez-vous recevoir vos réservations ?',
            'position': 5,
            'tips': [
              {
                'title': 'Conseil Immo Plus',
                'text': 'Conseil instantané',
                'variant': 'info',
                'visibleWhen': {'field': 'bookingMode', 'equals': 'INSTANT'},
              },
              {
                'title': 'Conseil Immo Plus',
                'text': 'Conseil demande',
                'variant': 'info',
                'visibleWhen': {'field': 'bookingMode', 'equals': 'REQUEST'},
              },
            ],
            'fields': [
              {
                'key': 'bookingMode',
                'type': 'single_select_cards',
                'required': true,
                'defaultValue': null,
                'options': [
                  {
                    'value': 'INSTANT',
                    'label': 'Réservation instantanée',
                    'description': 'Le client paie et réserve immédiatement.',
                    'enabled': true,
                  },
                  {
                    'value': 'REQUEST',
                    'label': 'Demande de réservation',
                    'description':
                        'Vous confirmez la disponibilité avant paiement.',
                    'enabled': true,
                  },
                ],
              },
            ],
          },
        ],
      });

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

CreationStep _step(Object? tips) => CreationStep.fromJson({
      'key': 'amenities',
      'title': 'Équipements',
      'fields': <Object>[],
      if (tips != null) 'tips': tips,
    });

Widget _host(List<CreationTip> tips) => MaterialApp(
      home: Scaffold(
          body: SingleChildScrollView(child: CreationTips(tips: tips))),
    );

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    if (!getIt.isRegistered<AnalyticsService>()) {
      getIt.registerSingleton<AnalyticsService>(_FakeAnalytics());
    }
  });

  group('tips de l\'API', () {
    test('sont lus dans l\'ordre, avec leur variante', () {
      final step = _step([
        {'title': 'Conseil Immo Plus', 'text': 'Premier', 'variant': 'info'},
        {'title': 'Attention', 'text': 'Second', 'variant': 'warning'},
      ]);

      expect(step.tips.map((t) => t.text), ['Premier', 'Second']);
      expect(step.tips.map((t) => t.variant),
          [TipVariant.info, TipVariant.warning]);
    });

    test('absents : aucune erreur, liste vide', () {
      expect(_step(null).tips, isEmpty);
    });

    test('une variante inconnue ou absente s\'affiche comme info', () {
      final step = _step([
        {'title': 'A', 'text': 'a', 'variant': 'nouvelle'},
        {'title': 'B', 'text': 'b'},
      ]);

      expect(
          step.tips.map((t) => t.variant), [TipVariant.info, TipVariant.info]);
    });

    test('un conseil vide est ignoré', () {
      expect(
          _step([
            {'variant': 'info'}
          ]).tips,
          isEmpty);
    });

    test('visibleWhen est parsé et filtre selon la valeur du champ', () {
      final step = _step([
        {
          'title': 'Conseil Immo Plus',
          'text': 'Pour instantané',
          'variant': 'info',
          'visibleWhen': {'field': 'bookingMode', 'equals': 'INSTANT'},
        },
        {
          'title': 'Conseil Immo Plus',
          'text': 'Toujours visible',
          'variant': 'info',
        },
      ]);

      expect(step.tips.first.visibleWhen?.field, 'bookingMode');
      expect(step.tips.first.visibleWhen?.equals, 'INSTANT');
      expect(step.tips.first.isVisible({'bookingMode': 'INSTANT'}), isTrue);
      expect(step.tips.first.isVisible({'bookingMode': 'REQUEST'}), isFalse);
      expect(step.tips.first.isVisible(const {}), isFalse);
      expect(step.tips.last.isVisible(const {}), isTrue);
    });
  });

  group('CreationTips', () {
    testWidgets('affiche le titre et le texte de chaque conseil, dans l\'ordre',
        (tester) async {
      await tester.pumpWidget(_host(const [
        CreationTip(title: 'Titre 1', text: 'Texte 1'),
        CreationTip(
            title: 'Titre 2', text: 'Texte 2', variant: TipVariant.success),
      ]));

      expect(find.text('Titre 1'), findsOneWidget);
      expect(find.text('Texte 2'), findsOneWidget);
      expect(tester.getTopLeft(find.text('Titre 1')).dy,
          lessThan(tester.getTopLeft(find.text('Titre 2')).dy));
    });

    testWidgets('sans conseil, n\'affiche rien', (tester) async {
      await tester.pumpWidget(_host(const []));

      expect(find.byType(Container), findsNothing);
    });
  });

  testWidgets(
      'StepContent booking affiche le conseil sous la carte sélectionnée',
      (tester) async {
    tester.view.physicalSize = const Size(390, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final cubit = ResidenceCreationCubit(repository: _FakeBookingRepository());
    await cubit.load();
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(0.55)),
          child: child!,
        ),
        home: BlocProvider.value(
          value: cubit,
          child: BlocBuilder<ResidenceCreationCubit, ResidenceCreationState>(
            builder: (context, state) => Scaffold(
              body: ListView(
                children: [
                  StepContent(
                    step: state.flow!.steps.single,
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

    final instantCard = find.descendant(
      of: find.byType(OptionCardsField),
      matching: find.text('Réservation instantanée'),
    );
    final requestCard = find.descendant(
      of: find.byType(OptionCardsField),
      matching: find.text('Demande de réservation'),
    );

    expect(find.text('Conseil instantané'), findsNothing);
    expect(find.text('Conseil demande'), findsNothing);

    await tester.tap(instantCard);
    await tester.pumpAndSettle();

    expect(find.text('Conseil instantané'), findsOneWidget);
    expect(find.text('Conseil demande'), findsNothing);
    expect(
      tester.getTopLeft(instantCard).dy,
      lessThan(tester.getTopLeft(find.text('Conseil instantané')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Conseil instantané')).dy,
      lessThan(tester.getTopLeft(requestCard).dy),
    );

    await tester.tap(requestCard);
    await tester.pumpAndSettle();

    expect(find.text('Conseil instantané'), findsNothing);
    expect(find.text('Conseil demande'), findsOneWidget);
    expect(
      tester.getTopLeft(requestCard).dy,
      lessThan(tester.getTopLeft(find.text('Conseil demande')).dy),
    );
    expect(
      tester.getTopLeft(find.text('Conseil demande')).dy,
      lessThan(tester.getTopLeft(find.text('Votre configuration')).dy),
    );
  });
}
