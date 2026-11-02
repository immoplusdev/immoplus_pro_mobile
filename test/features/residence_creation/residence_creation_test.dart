import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/residence_creation/logic/field_validator.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_payload_builder.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';
import 'package:immoplus_pro/features/residence_creation/models/residence_field_keys.dart';
import 'package:immoplus_pro/features/residence_creation/models/server_validation_errors.dart';

CreationFlow _loadFlow() {
  final json = jsonDecode(
    File('test/features/residence_creation/fixtures/creation_flow.json')
        .readAsStringSync(),
  ) as Map<String, dynamic>;
  return CreationFlow.fromJson(json['data'] as Map<String, dynamic>);
}

CreationField _field(CreationFlow flow, String key) =>
    flow.allFields.firstWhere((f) => f.key == key);

ImageUploadItem _photo(String id) => ImageUploadItem(
      status: UploadStatus.success,
      uploadedId: id,
    );

/// Valeurs d'un formulaire complet, comme dans l'exemple du ticket.
Map<String, dynamic> _filledValues() => {
      'name': ' Résidence Les Palmiers ',
      'propertyType': 'APPARTEMENT',
      'composition': {
        'bedrooms': 2,
        'livingRooms': 1,
        'bathrooms': 1,
        'maxGuests': 4,
      },
      'roomsAndBeds': {'doubleBeds': 2, 'kitchens': 1, 'gardens': 0},
      'address': 'Cocody Riviera 3, Abidjan',
      'city': const SelectedRef(id: 'uuid-ville', label: 'Abidjan'),
      'commune': const SelectedRef(id: 'uuid-commune', label: 'Cocody'),
      'position': const GeoPoint(latitude: 5.3612, longitude: -3.9871),
      'amenityCodes': ['WIFI', 'PISCINE'],
      'photos': [for (var i = 1; i <= 5; i++) _photo('uuid-photo-$i')],
      'video': null,
      'description': 'x' * 80,
      'checkInFrom': '14:00',
      'checkOutBefore': '12:00',
      'petsAllowed': false,
      'partiesAllowed': false,
      'baseNightlyPrice': 35000,
      'bookingMode': 'INSTANT',
      'advanceNoticeDays': 2,
      'sameDayCutoff': '18:00',
      'minNights': 1,
      'maxNights': 30,
      'weekendPricingEnabled': false,
      'weekendNightlyPrice': 40000,
      'preparationNights': 1,
      'bookingHorizonDays': 90,
      'weeklyDiscountPercent': 0,
    };

void main() {
  group('CreationFlow', () {
    test('parse la configuration réelle de l\'API', () {
      final flow = _loadFlow();

      expect(flow.steps.map((s) => s.key), [
        'property',
        'location',
        'amenities',
        'presentation',
        'rules_pricing',
        'booking',
      ]);
      expect(
        flow.allFields.where((f) => f.type == CreationFieldType.unknown),
        isEmpty,
        reason: 'tous les types de champs de la config sont gérés',
      );
    });

    test('REQUEST (enabled: false) n\'est pas proposé', () {
      final bookingMode = _field(_loadFlow(), 'bookingMode');

      expect(bookingMode.enabledOptions.map((o) => o.value), ['INSTANT']);
    });

    test('sameDayCutoff et weekendNightlyPrice suivent visibleWhen', () {
      final flow = _loadFlow();
      final cutoff = _field(flow, 'sameDayCutoff');
      final weekend = _field(flow, 'weekendNightlyPrice');

      expect(cutoff.isVisible({'advanceNoticeDays': 0}), isTrue);
      expect(cutoff.isVisible({'advanceNoticeDays': 2}), isFalse);
      expect(weekend.isVisible({'weekendPricingEnabled': true}), isTrue);
      expect(weekend.isVisible({'weekendPricingEnabled': false}), isFalse);
    });
  });

  group('FieldValidator', () {
    final flow = _loadFlow();

    test('nom : 3 à 80 caractères', () {
      final name = _field(flow, 'name');

      expect(FieldValidator.validate(name, ''), isNotNull);
      expect(FieldValidator.validate(name, 'ab'), contains('Minimum 3'));
      expect(FieldValidator.validate(name, 'a' * 81), contains('Maximum 80'));
      expect(FieldValidator.validate(name, 'Palmiers'), isNull);
    });

    test('description : 80 à 2000 caractères', () {
      final description = _field(flow, 'description');

      expect(FieldValidator.validate(description, 'court'),
          contains('Minimum 80'));
      expect(FieldValidator.validate(description, 'x' * 2001),
          contains('Maximum 2000'));
      expect(FieldValidator.validate(description, 'x' * 80), isNull);
    });

    test('photos : 5 minimum, envoi terminé', () {
      final photos = _field(flow, 'photos');

      expect(
        FieldValidator.validate(photos, [_photo('1'), _photo('2')]),
        contains('au moins 5'),
      );
      expect(
        FieldValidator.validate(photos, [
          for (var i = 0; i < 5; i++) _photo('$i'),
          ImageUploadItem(status: UploadStatus.uploading),
        ]),
        contains('en cours'),
      );
      expect(
        FieldValidator.validate(
            photos, [for (var i = 0; i < 5; i++) _photo('$i')]),
        isNull,
      );
    });

    test('tarif : requis et minimum 1000', () {
      final price = _field(flow, 'baseNightlyPrice');

      expect(FieldValidator.validate(price, null), isNotNull);
      expect(FieldValidator.validate(price, 500), contains('Minimum 1000'));
      expect(FieldValidator.validate(price, 35000), isNull);
    });
  });

  group('ResidencePayloadBuilder', () {
    final flow = _loadFlow();

    test('produit le payload de l\'exemple du ticket', () {
      final payload = ResidencePayloadBuilder.build(flow, _filledValues());

      expect(payload['nom'], 'Résidence Les Palmiers');
      expect(payload['typeResidence'], 'appartement');
      expect(payload['propertyType'], 'APPARTEMENT');
      expect(payload['adresse'], 'Cocody Riviera 3, Abidjan');
      expect(payload['ville'], 'uuid-ville');
      expect(payload['commune'], 'uuid-commune');
      expect(payload['position'], {
        'type': 'Point',
        'coordinates': [-3.9871, 5.3612],
      });
      expect(payload['miniature'], 'uuid-photo-1');
      expect(payload['images'], [for (var i = 1; i <= 5; i++) 'uuid-photo-$i']);
      expect(payload['video'], isNull);
      expect(payload['amenityCodes'], ['WIFI', 'PISCINE']);
      expect(payload['capacity'], {
        'bedrooms': 2,
        'livingRooms': 1,
        'bathrooms': 1,
        'maxGuests': 4,
      });
      expect(payload['roomCounts'], {'doubleBeds': 2, 'kitchens': 1},
          reason: 'les quantités à 0 sont écartées');
      expect(payload['baseNightlyPrice'], 35000);
      expect(payload['bookingMode'], 'INSTANT');
      expect(payload['advanceNoticeDays'], 2);
      expect(payload['minNights'], 1);
      expect(payload['maxNights'], 30);
    });

    test('envoie null pour les champs masqués', () {
      final payload = ResidencePayloadBuilder.build(flow, _filledValues());

      expect(payload['sameDayCutoff'], isNull,
          reason: 'advanceNoticeDays != 0');
      expect(payload['weekendNightlyPrice'], isNull,
          reason: 'weekendPricingEnabled == false');
    });

    test('garde les champs conditionnels quand ils sont visibles', () {
      final values = _filledValues()
        ..['advanceNoticeDays'] = 0
        ..['weekendPricingEnabled'] = true;

      final payload = ResidencePayloadBuilder.build(flow, values);

      expect(payload['sameDayCutoff'], '18:00');
      expect(payload['weekendNightlyPrice'], 40000);
    });

    test('ignore les photos non envoyées', () {
      final values = _filledValues()
        ..['photos'] = [
          _photo('a'),
          ImageUploadItem(status: UploadStatus.failed),
        ];

      final payload = ResidencePayloadBuilder.build(flow, values);

      expect(payload['images'], ['a']);
    });
  });

  group('ServerValidationErrors', () {
    DioException error(Object? data) => DioException(
          requestOptions: RequestOptions(path: '/residences'),
          response: Response(
            requestOptions: RequestOptions(path: '/residences'),
            statusCode: 400,
            data: data,
          ),
        );

    bool known(String key) =>
        {'nom', 'capacity', 'baseNightlyPrice'}.contains(key);

    test('rattache un message de liste à son champ', () {
      final parsed = ServerValidationErrors.fromDioException(
        error({
          'message': [
            'baseNightlyPrice must not be less than 1000',
            'quelque chose d\'autre',
          ],
        }),
        knownPayloadKey: known,
      );

      expect(parsed.byPayloadKey['baseNightlyPrice'], contains('1000'));
      expect(parsed.general, ['quelque chose d\'autre']);
    });

    test('lit `errors` sous forme de map et de liste', () {
      final fromMap = ServerValidationErrors.fromDioException(
        error({
          'errors': {
            'nom': ['trop court'],
            'capacity.maxGuests': 'invalide',
          },
        }),
        knownPayloadKey: known,
      );
      final fromList = ServerValidationErrors.fromDioException(
        error({
          'errors': [
            {'field': 'nom', 'message': 'trop court'},
          ],
        }),
        knownPayloadKey: known,
      );

      expect(
          fromMap.byPayloadKey, {'nom': 'trop court', 'capacity': 'invalide'});
      expect(fromList.byPayloadKey, {'nom': 'trop court'});
    });

    test('message simple : erreur générale', () {
      final parsed = ServerValidationErrors.fromDioException(
        error({'message': 'Forbidden'}),
        knownPayloadKey: known,
      );

      expect(parsed.general, ['Forbidden']);
      expect(parsed.byPayloadKey, isEmpty);
    });

    test('clé du payload -> champ du flow', () {
      expect(ResidenceFieldKeys.fieldKeyForPayloadKey('nom'), 'name');
      expect(
          ResidenceFieldKeys.fieldKeyForPayloadKey('capacity'), 'composition');
      expect(ResidenceFieldKeys.fieldKeyForPayloadKey('miniature'), 'photos');
      expect(
          ResidenceFieldKeys.fieldKeyForPayloadKey('minNights'), 'minNights');
    });
  });
}
