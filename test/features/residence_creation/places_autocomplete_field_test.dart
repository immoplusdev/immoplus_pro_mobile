import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';
import 'package:immoplus_pro/features/residence_creation/models/place_suggestion.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/places_autocomplete_field.dart';

const _suggestion = PlaceSuggestion(
  placeId: 'p1',
  description: 'Cocody Angré CHU, Abidjan',
  primaryText: 'Cocody Angré CHU',
  secondaryText: 'Abidjan',
);

const _field = CreationField(
  key: 'location',
  type: CreationFieldType.googlePlacesAutocomplete,
  label: 'Localisation',
  placeholder: 'Ex. Cocody, Angré CHU',
  required: true,
);

void main() {
  testWidgets('saisie -> suggestions -> choix, puis retaper annule le choix',
      (tester) async {
    final searches = <String>[];
    final changes = <PlaceSelection?>[];
    PlaceSelection? value;

    await tester.pumpWidget(MaterialApp(
      home: StatefulBuilder(
        builder: (context, setState) => Scaffold(
          body: SingleChildScrollView(
            child: PlacesAutocompleteField(
              field: _field,
              value: value,
              errorText: null,
              search: (input, {sessionToken}) async {
                searches.add(input);
                return [_suggestion];
              },
              resolve: (s, {sessionToken}) async => PlaceSelection(
                address: s.description,
                position: const GeoPoint(latitude: 5.4, longitude: -4.0),
              ),
              onChanged: (v) => setState(() {
                value = v;
                changes.add(v);
              }),
            ),
          ),
        ),
      ),
    ));

    // Moins de 3 caractères : pas de recherche.
    await tester.enterText(find.byType(TextField), 'Co');
    await tester.pump(const Duration(milliseconds: 500));
    expect(searches, isEmpty);

    await tester.enterText(find.byType(TextField), 'Cocody');
    await tester.pump(const Duration(milliseconds: 500));
    expect(searches, ['Cocody']);
    expect(find.text('Cocody Angré CHU'), findsOneWidget);

    await tester.tap(find.text('Cocody Angré CHU'));
    await tester.pumpAndSettle();
    expect(value?.address, 'Cocody Angré CHU, Abidjan');
    expect(value?.position.latitude, 5.4);
    expect(find.text('Cocody Angré CHU'), findsNothing); // liste refermée

    // Modifier le texte invalide l'adresse choisie.
    await tester.enterText(find.byType(TextField), 'Cocody Angré');
    await tester.pump(const Duration(milliseconds: 500));
    expect(value, isNull);
  });

  testWidgets('une erreur de recherche affiche un message', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PlacesAutocompleteField(
          field: _field,
          value: null,
          errorText: null,
          search: (input, {sessionToken}) async => throw Exception('réseau'),
          resolve: (s, {sessionToken}) async => throw UnimplementedError(),
          onChanged: (_) {},
        ),
      ),
    ));

    await tester.enterText(find.byType(TextField), 'Cocody');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.textContaining('Recherche indisponible'), findsOneWidget);
  });

  testWidgets('le bouton carte remplit le champ avec l\'adresse choisie',
      (tester) async {
    PlaceSelection? value;

    await tester.pumpWidget(MaterialApp(
      home: StatefulBuilder(
        builder: (context, setState) => Scaffold(
          body: PlacesAutocompleteField(
            field: _field,
            value: value,
            errorText: null,
            search: (input, {sessionToken}) async => const [],
            resolve: (s, {sessionToken}) async => throw UnimplementedError(),
            pickOnMap: (_) async => const PlaceSelection(
              address: 'Riviera 3, Abidjan',
              position: GeoPoint(latitude: 5.36, longitude: -3.98),
            ),
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ),
    ));

    await tester.tap(find.byIcon(Icons.map_outlined));
    await tester.pumpAndSettle();

    expect(value?.address, 'Riviera 3, Abidjan');
    expect(find.text('Riviera 3, Abidjan'), findsOneWidget);
  });

  testWidgets('sans pickOnMap, pas de bouton carte', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PlacesAutocompleteField(
          field: _field,
          value: null,
          errorText: null,
          search: (input, {sessionToken}) async => const [],
          resolve: (s, {sessionToken}) async => throw UnimplementedError(),
          onChanged: (_) {},
        ),
      ),
    ));

    expect(find.byIcon(Icons.map_outlined), findsNothing);
  });
}
