import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/views/estate_creation/utils/creation_estate_manager.dart';

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
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildRadioButton('Par mois'),
              _buildRadioButton('Par jours'),
              _buildRadioButton('Par heure'),
              _buildRadioButton('À vendre'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButton(String value) {
    return Card(
      color: _selectedValue == value ? Colors.white : Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Transform.scale(
              scale: 1.8, // Change the size of the radio button
              child: Radio<String>(
                value: value,
                groupValue: _selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedValue = newValue!;
                    // Récupérer le String correspondant
                    String selectedString = valueMap[_selectedValue]!;
                    print('Selected: $selectedString');
                    if (selectedString == 'vente') {
                      EstateCreationModelBuilder().aLouer = false;
                    } else {
                      EstateCreationModelBuilder().aLouer = true;
                    }
                    EstateCreationModelBuilder().typeLocation = selectedString;
                  });
                },
                activeColor: Colors.green, // Change the color when selected
                fillColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return Colors.green; // Color when selected
                    }
                    return Colors.grey; // Color when not selected
                  },
                ),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: _selectedValue == value ? Colors.green : Colors.black,
                fontWeight: _selectedValue == value
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
