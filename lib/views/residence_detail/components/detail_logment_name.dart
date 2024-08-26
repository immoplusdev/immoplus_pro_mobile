import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';

class DetailLogmentName extends StatelessWidget {
  const DetailLogmentName({super.key, required this.residenceModel});
  final ResidenceModel residenceModel;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
        child: AutoSizeText(
          residenceModel.nom,
          style: GoogleFonts.inter(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
