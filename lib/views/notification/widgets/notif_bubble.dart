import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/utils/utils.dart';

class NotifBubble extends StatelessWidget {
  const NotifBubble({super.key, required this.seen});
  // final NotificationModel notificationModel;
  final bool seen;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 10),
      child: ListTile(
        // leading: CircleAvatar(
        //   backgroundColor: Colors.transparent,
        //   child: Icon(Utils.getNotificationIcon(notificationModel.collection)),
        // ),
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // tileColor:
        //     seen ? CupertinoColors.tertiarySystemFill : AppColors.primaryLite,
        // title: Text(notificationModel.subject),
        // titleTextStyle: GoogleFonts.inter(
        //   fontWeight: FontWeight.bold,
        //   color: Colors.black,
        //   fontSize: 20,
        // ),
        // minVerticalPadding: 8,
        // subtitle: Text(notificationModel.message),
        //trailing: Text('il y a un jour'),
        //titleAlignment: ListTileTitleAlignment.threeLine,
        dense: true,
        //isThreeLine: true,
        leadingAndTrailingTextStyle: GoogleFonts.inter(
          fontSize: 12,
          color: Colors.black,
        ),
      ),
    );
  }
}
