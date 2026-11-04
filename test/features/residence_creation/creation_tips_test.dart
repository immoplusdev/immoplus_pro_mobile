import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/layout/creation_tips.dart';

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
}
