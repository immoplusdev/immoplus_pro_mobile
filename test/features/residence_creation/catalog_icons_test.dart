import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/catalog_icon_view.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/catalog_icons.dart';

void main() {
  test('chaque code mappé pointe vers un SVG qui existe', () {
    for (final code in CatalogIcons.mappedCodes) {
      final asset = CatalogIcons.svgAsset(code);

      expect(asset, isNotNull, reason: code);
      expect(File(asset!.replaceFirst('./', '')).existsSync(), isTrue,
          reason: '$code -> $asset');
    }
  });

  test('chaque type et chaque équipement du catalogue a un SVG', () {
    Iterable<String> codesOf(String fixture) {
      final data = jsonDecode(
        File('test/features/residence_creation/fixtures/$fixture')
            .readAsStringSync(),
      )['data'] as Map<String, dynamic>;
      final groups = data['categories'] as List? ?? [data];
      return [
        for (final group in groups)
          for (final item in group['items'] as List) item['code'] as String,
      ];
    }

    final codes = {
      ...codesOf('property_types.json'),
      ...codesOf('amenities.json')
    };
    final withoutSvg =
        codes.where((code) => CatalogIcons.svgAsset(code) == null).toList();

    expect(codes.length, greaterThan(100));
    expect(withoutSvg, isEmpty, reason: 'codes sans SVG : $withoutSvg');
  });

  test('un code inconnu n\'a pas d\'asset', () {
    expect(CatalogIcons.svgAsset('CODE_INCONNU'), isNull);
    expect(CatalogIcons.fallback('bath'), Icons.bathtub_outlined);
    expect(CatalogIcons.fallback('inconnu'), Icons.check_circle_outline);
  });

  testWidgets('SVG si disponible, sinon icône Material', (tester) async {
    Future<void> show(CatalogItem item, CatalogIconTone tone) =>
        tester.pumpWidget(MaterialApp(
          home: Scaffold(body: CatalogIconView(item: item, tone: tone)),
        ));

    await show(
      const CatalogItem(code: 'WIFI', label: 'Wifi', icon: 'wifi'),
      CatalogIconTone.brand,
    );
    expect(find.byType(SvgPicture), findsOneWidget);

    await show(
      const CatalogItem(code: 'CODE_INCONNU', label: 'Inconnu', icon: 'bath'),
      CatalogIconTone.muted,
    );
    expect(find.byType(SvgPicture), findsNothing);
    expect(find.byIcon(Icons.bathtub_outlined), findsOneWidget);
  });
}
