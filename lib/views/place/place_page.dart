import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

class PlacePage extends StatefulWidget {
  const PlacePage({super.key});
  static String name = 'place_page';
  @override
  State<PlacePage> createState() => _PlacePageState();
}

class _PlacePageState extends State<PlacePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Ajoutez ici le code à exécuter lorsque le bouton est appuyé
        },
        label: Text('Ajouter'), // Texte du bouton
        icon: Icon(FontAwesomeIcons.add), // Icône optionnelle du bouton
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Forme ovale du bouton
        ),
      ),
    );
  }
}
