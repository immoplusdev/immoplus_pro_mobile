import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PlaningBookingCard extends StatelessWidget {
  PlaningBookingCard({
    super.key,
  });
  //final RequestServiceModel requestServiceModel;
  final DateFormat formatDate = DateFormat('d MMMM yyyy');
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: ListTile(
              dense: true,
              title: Text('ARRIVÉE'),
              titleTextStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.bold, color: Colors.black),
              subtitle: Text('13 MAI 2025'),
            ),
          ),
          VerticalDivider(
            thickness: 1,
            color: Colors.grey,
          ),
          Flexible(
            child: ListTile(
              dense: true,
              title: Text('DÉPART'),
              titleTextStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.bold, color: Colors.black),
              subtitle: Text('13 MAI 2025'),
            ),
          ),
        ],
      ),
    );
  }
}
