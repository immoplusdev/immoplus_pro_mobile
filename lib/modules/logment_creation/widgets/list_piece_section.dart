import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:immoplus_pro/data/models/residence/piece_model.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/increase_listtile.dart';

class ListPieceSection extends StatefulWidget {
  const ListPieceSection({super.key});

  @override
  State<ListPieceSection> createState() => _ListPieceSectionState();
}

List<Map<String, dynamic>> listPiece = [
  {
    "nom": "Salon",
    "nombre": 0,
  },
  {
    "nom": "Chambre",
    "nombre": 0,
  },
  {
    "nom": "Salle de bains",
    "nombre": 0,
  },
  {
    "nom": "Cuisine",
    "nombre": 0,
  },
  {
    "nom": "Salle à manger",
    "nombre": 0,
  },
];

class _ListPieceSectionState extends State<ListPieceSection> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10)
                    .copyWith(bottom: 10),
                child: IncreaseListTile(
                  title: listPiece[index]['nom'],
                  onUpdate: (p0, p1) {
                    listPiece[index]['nombre'] = p1;
                    ResidenceCreationModelBuilder().pieces = listPiece
                        .map(
                          (e) => PieceModel.fromJson(e),
                        )
                        .toList();

                    inspect(ResidenceCreationModelBuilder().pieces);
                  },
                ),
              ),
          childCount: listPiece.length),
    );
  }
}
