import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/features/shared_widgets/status_chip.dart';

enum ResercationStatus {
  non_paye,
  paye,
}

class ReservationStatusSection extends StatelessWidget {
  const ReservationStatusSection({super.key, required this.status});
  final String status;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      tileColor: Colors.white,
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: FaIcon(FontAwesomeIcons.handHoldingDollar,
          color: Colors.grey,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Statut de réservation :",
      ),
      trailing: StatusChip(
        status: status,
        text: Utils.getServiceStatus(status),
      ),
    );
  }
}
