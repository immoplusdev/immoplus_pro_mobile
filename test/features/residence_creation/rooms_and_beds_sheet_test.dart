import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/rooms_and_beds_field.dart';

void main() {
  testWidgets(
      'le bouton Valider reste au-dessus de la barre de navigation Android',
      (tester) async {
    const navBar = 48.0;
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(MaterialApp(
      // Android plein écran : la barre système recouvre le bas de l'écran.
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: const EdgeInsets.only(bottom: navBar),
          viewPadding: const EdgeInsets.only(bottom: navBar),
        ),
        child: child!,
      ),
      home: Scaffold(
        body: RoomsAndBedsField(
          field: const CreationField(
            key: 'roomsAndBeds',
            type: CreationFieldType.bottomSheetCatalog,
            label: 'Ajouter des pièces et couchages',
          ),
          value: const {},
          errorText: null,
          loadCatalog: (endpoint, {search}) async => const [
            CatalogGroup(key: '', label: '', items: [
              CatalogItem(
                  code: 'LS', label: 'Lits simples', countKey: 'singleBeds'),
            ]),
          ],
          onChanged: (_) {},
        ),
      ),
    ));

    await tester.tap(find.text('Ajouter des pièces et couchages'));
    await tester.pumpAndSettle();

    final bottom = tester.getBottomLeft(find.text('Valider')).dy;
    expect(bottom, lessThanOrEqualTo(800 - navBar));
  });
}
