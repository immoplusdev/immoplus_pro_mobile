import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';

class DetailLogmentRooms extends StatelessWidget {
  DetailLogmentRooms({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 8),
        child: Wrap(
          children: logmentModel.pieces!
              .asMap()
              .map((index, piece) => MapEntry(
                  index,
                  Text(
                      "${piece.nombre} ${piece.nom} ${(index < logmentModel.pieces!.length - 1) ? '•' : ''} ")))
              .values
              .toList(),
        ),
      ),
    );
  }
}
