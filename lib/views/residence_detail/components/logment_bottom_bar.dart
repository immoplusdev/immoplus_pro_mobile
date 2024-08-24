import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/views/shared_widgets/custom_button.dart';

class LogmentBottomBar extends StatelessWidget {
  const LogmentBottomBar({super.key, required this.logmentModel});
  final ResidenceModel logmentModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10).copyWith(bottom: 20),
      height: 80,
      //color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              flex: 2,
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text:
                        '${Utils.formatCurrency(logmentModel.prixReservation)}',
                    style: Theme.of(context).textTheme.headlineSmall),
                TextSpan(
                    text: ' par jours',
                    style: TextStyle(color: Colors.grey.shade700))
              ]))),
          Flexible(
            child: CustomButtom(
              onClick: () {
                // if (UserModel.singleton.id!.isNotEmpty) {
                //   // Navigator.push(
                //   //     context,
                //   //     CupertinoPageRoute(
                //   //         builder: (context) => BookingFormularAction(
                //   //             productDetailModel: productDetailModel)));
                // } else {
                //   Utils.authentificationPopup(context: context);
                // }
              },
              text: 'MODIFIER',
            ),
          ),
        ],
      ),
    );
  }
}
