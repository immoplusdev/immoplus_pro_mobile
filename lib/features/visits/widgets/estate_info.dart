import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/utils/utils.dart';

class EstateInfo extends StatelessWidget {
  const EstateInfo({super.key, required this.bienImmobilierModel});
  final BienImmobilierModel bienImmobilierModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.customBlue.withOpacity(0.1)),
      ),
      leading: CircleAvatar(
          //backgroundImage: Utils.getImage(id: bienImmobilierModel.images.first),
          ),
      title: Text(bienImmobilierModel.nom ?? 'no name'),
      subtitle: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: Utils.formatCurrency(bienImmobilierModel.prix!),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700)),
        TextSpan(
            text: ' Par mois', style: TextStyle(color: Colors.grey.shade600))
      ])),
    );
  }
}
