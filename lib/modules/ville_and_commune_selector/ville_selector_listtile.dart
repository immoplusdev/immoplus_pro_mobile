import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/configs/ville_model.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/ville_selector_page.dart';

class VilleSelectorListtile extends StatefulWidget {
  const VilleSelectorListtile({super.key, required this.onSelect});
  final void Function(VilleModel? ville) onSelect;

  @override
  State<VilleSelectorListtile> createState() => _VilleSelectorListtileState();
}

class _VilleSelectorListtileState extends State<VilleSelectorListtile> {
  VilleModel? villeModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      tileColor: (villeModel != null)
          ? AppColors.primaryLite
          : CupertinoColors.tertiarySystemFill,
      leading: Icon(
        FontAwesomeIcons.treeCity,
        color: (villeModel != null) ? AppColors.primary : Colors.grey.shade400,
      ),
      title: Text(
        (villeModel != null) ? villeModel!.name : "Selectioner une ville",
      ),
      trailing: const Icon(CupertinoIcons.chevron_right_circle_fill),
      onTap: () => showModalBottomSheet(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        isDismissible: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        showDragHandle: true,
        builder: (context) => const FractionallySizedBox(
          heightFactor: 0.835,
          child: VilleSelectorPage(),
        ),
      ).then(
        (value) {
          if (value is VilleModel) {
            setState(() {
              villeModel = value;
              widget.onSelect(value);
            });
          }
        },
      ),
    );
  }
}
