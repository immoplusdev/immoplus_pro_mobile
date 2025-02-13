import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';

class DetailLogmentInfos extends StatelessWidget {
  const DetailLogmentInfos({super.key, required this.reservation});
  final ResidenceModel reservation;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 8, right: 8),
        child: SizedBox(
          width: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 15,
                color: AppColors.primary,
              ),
              Flexible(
                child: AutoSizeText(
                  " ${reservation.adresse}",
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
              // Gap(8),
              // Icon(
              //   Icons.star,
              //   size: 15,
              //   color: Colors.orange,
              // ),
              // Text(
              //   "4",
              //   style: TextStyle(
              //     fontSize: 12,
              //     color: Colors.orange,
              //   ),
              // ),

              // Visibility(
              //   visible:
              //       logmentModel.category!.productType == ProductType.booking,
              //   child: SizedBox(
              //     width: 200,
              //     child: ListTile(
              //       tileColor: AppColors.primaryLite,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(30)),
              //       dense: true,
              //       title: Text((logmentModel.deliveryMethod ==
              //               DeliveryMethod.camion.name)
              //           ? "Livraison par camion"
              //           : "Livraison par moto"),
              //       horizontalTitleGap: 0,
              //       leading: Icon(
              //         (logmentModel.deliveryMethod == DeliveryMethod.camion.name)
              //             ? FontAwesomeIcons.truckMoving
              //             : Icons.delivery_dining,
              //         size: 20,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
