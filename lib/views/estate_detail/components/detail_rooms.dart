import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';

class DetailEstateRooms extends StatelessWidget {
  DetailEstateRooms({super.key, required this.bienImmobilier});
  final BienImmobilierModel bienImmobilier;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 8),
        child: Wrap(
          children: bienImmobilier.pieces!
              .asMap()
              .map((index, piece) => MapEntry(
                  index,
                  AutoSizeText(
                      "${piece.nombre} ${piece.nom} ${(index < bienImmobilier.pieces!.length - 1) ? '•' : ''} ")))
              .values
              .toList(),
        ),
      ),
    );
  }
}
