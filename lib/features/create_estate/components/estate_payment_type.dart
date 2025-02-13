import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';

class EstatePayementType extends StatefulWidget {
  const EstatePayementType({super.key});

  @override
  _EstatePayementTypeState createState() => _EstatePayementTypeState();
}

class _EstatePayementTypeState extends State<EstatePayementType> {
  String _selectedValue = 'Par mois';

  final Map<String, String> valueMap = {
    'Par mois': 'mois',
    'Par jours': 'jour',
    'Par heure': 'heure',
    'À vendre': 'vente',
    'Par année': 'vente',
  };

  final Map<String, IconData> iconMap = {
    'Par mois': Icons.calendar_month,
    'Par jours': Icons.calendar_today,
    'Par heure': Icons.access_time,
    'Par année': Icons.date_range_rounded,
    'À vendre': Icons.sell,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Type de paiement',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
            ),
            itemCount: valueMap.keys.length,
            itemBuilder: (context, index) {
              final key = valueMap.keys.elementAt(index);
              return _buildOptionCard(key);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String value) {
    final bool isSelected = _selectedValue == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedValue = value;
          String selectedString = valueMap[_selectedValue]!;

          print('Selected: $selectedString');
          if (selectedString == 'vente') {
            // Custom logic here
            log('À vendre sélectionné');
            EstateCreationModelBuilder().aLouer = false;
            log(EstateCreationModelBuilder().aLouer.toString());
            EstateCreationModelBuilder().typeLocation = selectedString;
          } else {
            EstateCreationModelBuilder().aLouer = true;
            EstateCreationModelBuilder().typeLocation = selectedString;
          }
        });
      },
      child: Card(
        elevation: isSelected ? 5 : 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: isSelected ? Colors.green.shade100 : Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconMap[value],
              size: 40,
              color: isSelected ? Colors.green : Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
                color: isSelected ? Colors.green : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
