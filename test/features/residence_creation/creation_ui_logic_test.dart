import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_step_key.dart';
import 'package:immoplus_pro/features/residence_creation/models/residence_recap.dart';
import 'package:immoplus_pro/features/residence_creation/pages/residence_creation_success_view.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/thousands_formatter.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/step/booking_step_extras.dart';

CreationFlow _loadFlow() {
  final json = jsonDecode(
    File('test/features/residence_creation/fixtures/creation_flow.json')
        .readAsStringSync(),
  ) as Map<String, dynamic>;
  return CreationFlow.fromJson(json['data'] as Map<String, dynamic>);
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
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('ThousandsFormatter', () {
    test('sépare les milliers', () {
      expect(ThousandsFormatter.format(35000), '35.000');
      expect(ThousandsFormatter.format(1234567), '1.234.567');
      expect(ThousandsFormatter.format(999), '999');
      expect(ThousandsFormatter.format(35000, separator: ' '), '35 000');
    });

    test('digitsOf garde uniquement les chiffres', () {
      expect(ThousandsFormatter.digitsOf('35.000 fcfa'), '35000');
    });
  });

  group('CreationStepKey', () {
    test('toutes les étapes de l\'API ont un libellé court', () {
      final keys =
          _loadFlow().steps.map((s) => CreationStepKey.fromValue(s.key));

      expect(keys, isNot(contains(CreationStepKey.unknown)));
      expect(keys.map((k) => k.shortLabel), [
        'Mon bien',
        'Équipements',
        'Présentation',
        'Règles et prix',
        'Réservations',
      ]);
    });

    test('une étape inconnue ne casse pas', () {
      expect(CreationStepKey.fromValue('nouvelle'), CreationStepKey.unknown);
    });
  });

  group('BookingSummary', () {
    final fields = _loadFlow().allFields;

    test('arrivée le jour même avec heure limite et tarif week-end', () {
      final lines = BookingSummary.linesFrom(fields, {
        'bookingMode': 'INSTANT',
        'advanceNoticeDays': 0,
        'sameDayCutoff': '18:00',
        'minNights': 1,
        'maxNights': 30,
        'baseNightlyPrice': 35000,
        'weekendPricingEnabled': true,
        'weekendNightlyPrice': 45000,
      });

      expect(lines, [
        'Réservation instantanée',
        'Jour même avant 18:00',
        '1 à 30 nuits',
        '35000 F/nuit · Week-end 45000 F',
      ]);
    });

    test('préavis de plusieurs jours, sans tarif week-end', () {
      final lines = BookingSummary.linesFrom(fields, {
        'bookingMode': 'INSTANT',
        'advanceNoticeDays': 2,
        'minNights': 2,
        'maxNights': 10,
        'baseNightlyPrice': 20000,
        'weekendPricingEnabled': false,
        'weekendNightlyPrice': 99999,
      });

      expect(lines, contains('Préavis de 2 jours'));
      expect(lines.last, '20000 F/nuit');
    });
  });

  group('ResidenceRecap', () {
    test('se construit à partir des valeurs du formulaire', () {
      final recap = ResidenceRecap.fromValues({
        'name': ' Résidence Les Palmiers ',
        'propertyType': 'APPARTEMENT',
        'composition': {'bedrooms': 2, 'livingRooms': 1},
        'baseNightlyPrice': 35000,
        'photos': [ImageUploadItem(status: UploadStatus.failed)],
      });

      expect(recap.name, 'Résidence Les Palmiers');
      expect(recap.propertyTypeLabel, 'Appartement');
      expect(recap.bedrooms, 2);
      expect(recap.nightlyPrice, 35000);
      expect(recap.coverPhoto, isNull);
    });
  });

  testWidgets('écran de succès : récapitulatif et actions', (tester) async {
    tester.view.physicalSize = const Size(390, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final taps = <String>[];
    await tester.pumpWidget(MaterialApp(
      builder: _withRealisticTextWidth,
      home: ResidenceCreationSuccessView(
        recap: const ResidenceRecap(
          name: 'Résidence Les Palmiers',
          propertyTypeLabel: 'Appartement',
          bedrooms: 2,
          nightlyPrice: 35000,
        ),
        onEdit: () => taps.add('edit'),
        onHome: () => taps.add('home'),
      ),
    ));

    expect(find.text('Résidence créée !'), findsOneWidget);
    expect(find.text('Appartement · 2 chambre(s) · 35 000 FCFA/nuit'),
        findsOneWidget);

    expect(find.text('Vérifier votre logement'), findsOneWidget);
    expect(find.text('Commission'), findsOneWidget);
    expect(find.text('Première réservation'), findsOneWidget);
    await tester.tap(find.text('Modifier'));
    await tester.tap(find.text('Accueil'));

    expect(taps, ['edit', 'home']);
  });
}
