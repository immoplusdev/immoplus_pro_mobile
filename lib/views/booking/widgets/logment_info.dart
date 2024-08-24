import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/utils/utils.dart';

class LogmentInfo extends StatelessWidget {
  const LogmentInfo({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      tileColor: CupertinoColors.tertiarySystemFill,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: CircleAvatar(
        backgroundImage: Utils.getImage(id: logmentModel.images.first),
      ),
      title: Text(logmentModel.nom ?? 'no name'),
      subtitle: RichText(
          text: TextSpan(children: [
        TextSpan(
            text: Utils.formatCurrency(logmentModel.prixReservation!),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700)),
        TextSpan(
            text: ' Par nuit', style: TextStyle(color: Colors.grey.shade600))
      ])),
    );
  }
}
