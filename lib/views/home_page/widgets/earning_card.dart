import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/views/booking/booking_earning_detail_pages.dart';

class EarningCard extends StatelessWidget {
  const EarningCard({super.key, required this.available});
  final bool available;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 10),
      child: ListTile(
        onTap: available
            ? () => showModalBottomSheet(
                  backgroundColor: AppColors.scafold,
                  showDragHandle: true,
                  enableDrag: true,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  context: context,
                  builder: (context) =>
                      Container(height: 500, child: BookingEarningDetailPage()),
                )
            : null,
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        tileColor: Colors.white,
        leading: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: available
                ? Icon(
                    FontAwesomeIcons.moneyBillTransfer,
                    color: Colors.green.shade800,
                  )
                : Icon(
                    FontAwesomeIcons.circleXmark,
                    color: Colors.red.shade200,
                  )),
        title: Text(Utils.formatCurrency(8000000)),
        titleTextStyle: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: available ? Colors.green : Colors.red.shade200),
        subtitle: Text(available ? 'À retirer' : 'À partir du 15 Mai 2021'),
        trailing: available
            ? Icon(
                CupertinoIcons.chevron_right_circle_fill,
                color: Colors.black,
              )
            : null,
      ),
    );
  }
}
