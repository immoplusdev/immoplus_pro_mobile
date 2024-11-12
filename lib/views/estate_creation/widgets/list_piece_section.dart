import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:immoplus_pro/data/models/residence/piece_model.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/increase_listtile.dart';
import 'package:immoplus_pro/views/estate_creation/utils/creation_estate_manager.dart';

class EstateListPieceSection extends StatefulWidget {
  const EstateListPieceSection({super.key});

  @override
  State<EstateListPieceSection> createState() => _EstateListPieceSectionState();
}

class _EstateListPieceSectionState extends State<EstateListPieceSection> {
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
  @override
  void initState() {
    if (EstateCreationModelBuilder().pieces.isNotEmpty) {
      setState(() {
        listPiece = List.generate(
          EstateCreationModelBuilder().pieces.length,
          (index) => EstateCreationModelBuilder().pieces[index].toJson(),
        );
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10)
                    .copyWith(bottom: 10),
                child: IncreaseListTile(
                  title: listPiece[index]['nom'],
                  itemCount: listPiece[index]['nombre'],
                  onUpdate: (p0, p1) {
                    listPiece[index]['nombre'] = p1;
                    EstateCreationModelBuilder().pieces = listPiece
                        .map(
                          (e) => PieceModel.fromJson(e),
                        )
                        .toList();

                    inspect(EstateCreationModelBuilder().pieces);
                  },
                ),
              ),
          childCount: listPiece.length),
    );
  }
}
