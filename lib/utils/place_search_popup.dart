// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:google_maps_webapi/places.dart';

// class PlaceSearchPopup extends StatelessWidget {
//   final String googleMapsApiKey;

//   PlaceSearchPopup({required this.googleMapsApiKey});

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       navigationBar: CupertinoNavigationBar(
//         middle: Text('Rechercher un lieu'),
//         trailing: CupertinoButton(
//           padding: EdgeInsets.zero,
//           child: Text(
//             'Fermer',
//             style: TextStyle(color: CupertinoColors.destructiveRed),
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       child: SafeArea(
//         child: Center(
//           child: CupertinoButton.filled(
//             child: Text("Rechercher un lieu"),
//             onPressed: () async {
//               Prediction? prediction = await PlacesAutocomplete.show(
//                 context: context,
//                 apiKey: googleMapsApiKey,
//                 onError: (PlacesAutocompleteResponse response) {
//                   debugPrint("Erreur: ${response.errorMessage}");
//                 },
//                 mode: Mode.overlay, // Mode de l'interface
//                 language: "fr", // Langue des résultats
//                 components: [
//                   Component(Component.country, "ci")
//                 ], // Côte d'Ivoire
//                 decoration: InputDecoration(
//                   hintText: "Rechercher un lieu",
//                   contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                 ),
//               );

//               if (prediction != null) {
//                 await _getPlaceDetails(prediction.placeId!, context);
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _getPlaceDetails(String placeId, BuildContext context) async {
//     final places = GoogleMapsPlaces(
//       apiKey: googleMapsApiKey,
//     );

//     final response = await places.getDetailsByPlaceId(placeId);

//     if (response.status == "OK") {
//       final result = response.result;
//       final location = result.geometry?.location;

//       if (location != null) {
//         String placeName = result.name;
//         double latitude = location.lat;
//         double longitude = location.lng;

//         // Passez les informations à une action spécifique
//         debugPrint("Lieu sélectionné : $placeName");
//         debugPrint("Coordonnées : Latitude $latitude, Longitude $longitude");

//         // Exemple d'action personnalisée :
//         Navigator.of(context).pop({
//           'name': placeName,
//           'latitude': latitude,
//           'longitude': longitude,
//         });
//       }
//     } else {
//       debugPrint("Erreur : ${response.errorMessage}");
//     }
//   }
// }
