import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_cubit.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_state.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';
import 'package:immoplus_pro/features/residence_creation/models/place_suggestion.dart';
import 'package:immoplus_pro/features/residence_creation/repositories/residence_creation_repository.dart';
import 'package:immoplus_pro/services/analytics_service.dart';

class _FakeAnalytics implements AnalyticsService {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

class _FakeRepository implements ResidenceCreationRepository {
  Map<String, dynamic>? sentPayload;
  DioException? failWith;
  final uploadedFiles = <File>[];
  bool failUpload = false;
  Map<String, dynamic> residenceToEdit = {};
  String? updatedId;
  Map<String, dynamic>? updatedPayload;

  @override
  Future<String> uploadFile(File file) async {
    if (failUpload) {
      throw DioException(requestOptions: RequestOptions(path: '/files'));
    }
    uploadedFiles.add(file);
    return 'file-${uploadedFiles.length}';
  }

  @override
  Future<Map<String, dynamic>> getResidence(String id) async => residenceToEdit;

  @override
  Future<void> updateResidence(String id, Map<String, dynamic> payload) async {
    if (failWith != null) throw failWith!;
    updatedId = id;
    updatedPayload = payload;
  }

  @override
  Future<List<PlaceSuggestion>> searchPlaces(String input,
          {String? sessionToken}) async =>
      const [];

  @override
  Future<GeoPoint> getPlacePosition(String placeId,
          {String? sessionToken}) async =>
      const GeoPoint(latitude: 5.36, longitude: -3.98);

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
          {String? search}) async =>
      const [];

  @override
  Future<CreatedResidence> createResidence(Map<String, dynamic> payload) async {
    if (failWith != null) throw failWith!;
    sentPayload = payload;
    return const CreatedResidence(
      id: 'res-1',
      statusValidation: 'en_attente_validation',
      residenceDisponible: false,
    );
  }
}

ImageUploadItem _photo(int i) =>
    ImageUploadItem(status: UploadStatus.success, uploadedId: 'photo-$i');

void main() {
  late _FakeRepository repository;
  late ResidenceCreationCubit cubit;

  setUpAll(() => getIt.registerSingleton<AnalyticsService>(_FakeAnalytics()));

  setUp(() async {
    repository = _FakeRepository();
    cubit = ResidenceCreationCubit(repository: repository);
    await cubit.load();
  });

  tearDown(() => cubit.close());

  /// Remplit les champs obligatoires de chaque étape, étape par étape.
  Future<void> fillAndAdvance(Map<String, Object?> values) async {
    values.forEach(cubit.setValue);
    await cubit.next();
  }

  test('load : applique les valeurs par défaut de la configuration', () {
    final values = cubit.state.values;

    expect(cubit.state.loadStatus, FlowLoadStatus.ready);
    expect(values['composition'], {
      'bedrooms': 0,
      'livingRooms': 0,
      'bathrooms': 0,
      'maxGuests': 1,
    });
    expect(values['checkInFrom'], '14:00');
    expect(values['bookingMode'], 'INSTANT');
    expect(values['advanceNoticeDays'], 0);
    expect(values['maxNights'], 30);
    expect(values['petsAllowed'], false);
    expect(values['photos'], isEmpty);
  });

  test('next : bloque l\'étape tant que les champs requis sont invalides',
      () async {
    await cubit.next();

    expect(cubit.state.stepIndex, 0);
    expect(cubit.state.fieldErrors.keys, containsAll(['name', 'propertyType']));
  });

  test('setValue : efface l\'erreur du champ modifié', () async {
    await cubit.next();
    cubit.setValue('name', 'Palmiers');

    expect(cubit.state.fieldErrors.containsKey('name'), isFalse);
    expect(cubit.state.fieldErrors.containsKey('propertyType'), isTrue);
  });

  group('envoi des photos (POST /files)', () {
    List<ImageUploadItem> photos() =>
        cubit.state.values['photos'] as List<ImageUploadItem>;

    test('chaque photo est envoyée par le repository et gardée avec son id',
        () async {
      cubit.addPhotos([File('a.jpg'), File('b.jpg')]);
      await Future<void>.delayed(Duration.zero);

      expect(repository.uploadedFiles.map((f) => f.path), ['a.jpg', 'b.jpg']);
      expect(photos().map((p) => p.uploadedId), ['file-1', 'file-2']);
      expect(photos().every((p) => p.isUploaded), isTrue);
    });

    test('un échec d\'envoi marque la photo en erreur', () async {
      repository.failUpload = true;

      cubit.addPhotos([File('a.jpg')]);
      await Future<void>.delayed(Duration.zero);

      expect(photos().single.status, UploadStatus.failed);
      expect(photos().single.isUploaded, isFalse);
    });

    test('respecte le nombre maximal de photos', () async {
      cubit.addPhotos([File('a.jpg'), File('b.jpg'), File('c.jpg')],
          maxFiles: 2);
      await Future<void>.delayed(Duration.zero);

      expect(photos(), hasLength(2));
    });

    test('la vidéo utilise le même envoi', () async {
      final id = await cubit.uploadFile(File('clip.mp4'));

      expect(id, 'file-1');
      expect(repository.uploadedFiles.single.path, 'clip.mp4');
    });
  });

  Future<void> completeAllSteps() async {
    await fillAndAdvance({
      'name': 'Les Palmiers',
      'propertyType': 'VILLA',
      'location': const PlaceSelection(
        address: 'Cocody Riviera 3',
        position: GeoPoint(latitude: 5.36, longitude: -3.98),
      ),
    });
    await fillAndAdvance({});
    await fillAndAdvance({
      'photos': [for (var i = 1; i <= 5; i++) _photo(i)],
      'description': 'x' * 80,
    });
    await fillAndAdvance({'baseNightlyPrice': 35000});
  }

  test('parcours complet : soumet le payload et affiche la confirmation',
      () async {
    await completeAllSteps();
    expect(cubit.state.stepIndex, 4);
    expect(cubit.state.isLastStep, isTrue);

    await cubit.next();

    expect(cubit.state.created?.id, 'res-1');
    expect(cubit.state.isSubmitting, isFalse);
    final payload = repository.sentPayload!;
    expect(payload['nom'], 'Les Palmiers');
    expect(payload['typeResidence'], 'villa');
    expect(payload['miniature'], 'photo-1');
    expect(payload['baseNightlyPrice'], 35000);
    expect(payload['sameDayCutoff'], isNull);
  });

  test('erreur serveur : affiche l\'erreur sur le champ et revient à l\'étape',
      () async {
    await completeAllSteps();
    repository.failWith = DioException(
      requestOptions: RequestOptions(path: '/residences'),
      response: Response(
        requestOptions: RequestOptions(path: '/residences'),
        statusCode: 400,
        data: {
          'message': ['nom must be longer than 3 characters'],
        },
      ),
    );

    await cubit.next();

    expect(cubit.state.created, isNull);
    expect(cubit.state.isSubmitting, isFalse);
    expect(cubit.state.fieldErrors['name'], contains('nom must be longer'));
    expect(cubit.state.stepIndex, 0,
        reason: 'retour à l\'étape du champ en erreur');
  });

  test('erreur serveur non rattachable : message général, étape inchangée',
      () async {
    await completeAllSteps();
    repository.failWith = DioException(
      requestOptions: RequestOptions(path: '/residences'),
      response: Response(
        requestOptions: RequestOptions(path: '/residences'),
        statusCode: 500,
        data: {'message': 'Erreur interne'},
      ),
    );

    await cubit.next();

    expect(cubit.state.generalErrors, ['Erreur interne']);
    expect(cubit.state.stepIndex, 4);
  });

  group('édition d\'une résidence (PATCH)', () {
    Map<String, dynamic> fixture(String name) => jsonDecode(
          File('test/features/residence_creation/fixtures/$name')
              .readAsStringSync(),
        ) as Map<String, dynamic>;

    Future<ResidenceCreationCubit> editing(String fixtureName) async {
      repository.residenceToEdit = fixture(fixtureName);
      final edit =
          ResidenceCreationCubit(repository: repository, residenceId: 'res-9');
      addTearDown(edit.close);
      await edit.load();
      return edit;
    }

    test('préremplit le formulaire depuis une résidence au nouveau format',
        () async {
      final values = (await editing('residence_new_format.json')).state.values;

      expect(values['name'], 'test');
      expect(values['propertyType'], 'STUDIO');
      expect(values['composition'],
          {'bedrooms': 1, 'livingRooms': 1, 'bathrooms': 1, 'maxGuests': 3});
      expect(values['roomsAndBeds'],
          {'bunkBeds': 1, 'doubleBeds': 1, 'singleBeds': 1});
      final place = values['location'] as PlaceSelection;
      expect(place.address, 'testded');
      final point = place.position;
      expect(point.longitude, -3.9986141);
      expect(point.latitude, 5.353858199999999);
      expect(values['amenityCodes'], ['WIFI']);
      expect(
          (values['photos'] as List<ImageUploadItem>)
              .map((p) => p.uploadedId)
              .toList(),
          ['img-1', 'img-2', 'img-3', 'img-4', 'img-5']);
      expect(values['baseNightlyPrice'], 1000);
      expect(values['bookingHorizonDays'], 90);
      expect(values['preparationNights'], 1);
      expect(values['weekendPricingEnabled'], true);
      expect(values['weekendNightlyPrice'], 45000);
      expect(values['weeklyDiscountPercent'], 10);
    });

    test('une ancienne résidence retombe sur l\'ancien format puis les défauts',
        () async {
      final values = (await editing('residence_legacy.json')).state.values;

      expect(values['propertyType'], 'APPARTEMENT');
      expect((values['composition'] as Map)['maxGuests'], 4);
      expect(values['checkInFrom'], '06:00');
      expect(values['baseNightlyPrice'], 100);
      expect(values['minNights'], 1);
      expect(values['maxNights'], 2);
      expect(values['petsAllowed'], true);
      expect(values['amenityCodes'], isEmpty);
      expect(values['location'], isA<PlaceSelection>());
      expect(values['bookingMode'], 'INSTANT');
      expect(values['weekendPricingEnabled'], false);
    });

    test('enregistrer envoie le même payload que la création, en PATCH',
        () async {
      final edit = await editing('residence_new_format.json');

      for (var i = 0; i < 5; i++) {
        await edit.next();
      }

      expect(repository.updatedId, 'res-9');
      expect(repository.sentPayload, isNull); // pas de POST
      final payload = repository.updatedPayload!;
      expect(payload['nom'], 'test');
      expect(payload['propertyType'], 'STUDIO');
      expect(payload['typeResidence'], 'studio');
      expect(payload['images'], ['img-1', 'img-2', 'img-3', 'img-4', 'img-5']);
      expect(payload['miniature'], 'img-1');
      expect(payload['adresse'], 'testded');
      expect(payload['position'], {
        'type': 'Point',
        'coordinates': [-3.9986141, 5.353858199999999],
      });
      expect(payload['baseNightlyPrice'], 1000);
      expect(edit.state.updated, isTrue);
      expect(edit.state.created, isNull);
    });

    test('une erreur du serveur reste sur le formulaire', () async {
      final edit = await editing('residence_new_format.json');
      repository.failWith = DioException(
        requestOptions: RequestOptions(path: '/residences/res-9'),
        response: Response(
          requestOptions: RequestOptions(path: '/residences/res-9'),
          statusCode: 400,
          data: {'message': 'Invalide'},
        ),
      );

      for (var i = 0; i < 5; i++) {
        await edit.next();
      }

      expect(edit.state.updated, isFalse);
      expect(edit.state.isSubmitting, isFalse);
      expect(edit.state.generalErrors, isNotEmpty);
    });
  });
}
