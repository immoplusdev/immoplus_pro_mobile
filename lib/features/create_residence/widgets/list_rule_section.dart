import 'package:flutter/cupertino.dart';
import 'package:immoplus_pro/features/create_residence/widgets/rules_listtile.dart';

class ListRuleSection extends StatefulWidget {
  const ListRuleSection({super.key});

  @override
  State<ListRuleSection> createState() => _ListRuleSectionState();
}

List<Map<String, dynamic>> listPiece = [
  {
    "nom": "Les animaux sont autorisés ?",
    "id": 1,
  },
  {
    "nom": "Les fêtes sont autorisées?",
    "id": 2,
  },
  {
    "nom": " Éviter le bruit",
    "id": 3,
  },
];

class _ListRuleSectionState extends State<ListRuleSection> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10)
                    .copyWith(bottom: 10),
                child: RuleListTile(
                  title: listPiece[index]['nom'],
                  id: listPiece[index]['id'],
                  // onUpdate: (p0, p1) {
                  //   listPiece[index]['nombre'] = p1;
                  //   inspect(listPiece);
                  // },
                ),
              ),
          childCount: listPiece.length),
    );
  }
}
