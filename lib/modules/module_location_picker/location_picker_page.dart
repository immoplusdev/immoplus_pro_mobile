// part of location_picker;

// class LocationPickerPage extends StatefulWidget {
//   const LocationPickerPage({
//     super.key,
//     required this.onSeleted,
//     required this.onCurrentPositionSelected,
//     this.showCurrentPosition = false,
//   });
//   final void Function(PredictionPickerModel value, String title,
//       String subtitle, String fullName)? onSeleted;

//   final void Function(GeoJSONFeature? data)? onCurrentPositionSelected;
//   final bool showCurrentPosition;
//   @override
//   State<LocationPickerPage> createState() => _LocationPickerPageState();
// }

// class _LocationPickerPageState extends State<LocationPickerPage> {
//   final places =
//       FlutterGooglePlacesSdk("AIzaSyCflK5q24QvaR_CxlfW795PZKrE6VG6JLA");
//   bool isloading = false;
//   List<AutocompletePrediction> currenPredictions = [];
//   Map<String, PredictionPickerModel> fieldsDatails = {};

//   Future<PredictionPickerModel> getDetailsPrediction(String id) async {
//     final details = await Dio().get(
//       'https://maps.googleapis.com/maps/api/place/details/json',
//       queryParameters: {
//         "placeid": id,
//         "key": "AIzaSyCflK5q24QvaR_CxlfW795PZKrE6VG6JLA",
//       },
//     );
//     //inspect(details.data['result']);
//     PredictionPickerModel result =
//         PredictionPickerModel.fromJson(details.data['result']);
//     return result;
//   }

//   getPrediction({String? value}) async {
//     setState(() {
//       isloading = true;
//     });

//     try {
//       if (value!.isNotEmpty) {
//         FindAutocompletePredictionsResponse
//             findAutocompletePredictionsResponse =
//             await places.findAutocompletePredictions(value, countries: ['CI']);
//         currenPredictions.clear();
//         fieldsDatails.clear();

//         setState(() {
//           currenPredictions
//               .addAll(findAutocompletePredictionsResponse.predictions);
//         });
//         findAutocompletePredictionsResponse.predictions.forEach(
//           (element) async {
//             PredictionPickerModel detail =
//                 await getDetailsPrediction(element.placeId);
//             setState(() {
//               fieldsDatails[element.placeId] = detail;
//             });

//             //cinspect(fieldsDatails);
//           },
//         );
//       } else {
//         currenPredictions.clear();
//       }
//     } catch (e) {
//       log(e.toString());
//     }

//     setState(() {
//       isloading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 5,
//         elevation: 0,
//         backgroundColor: Colors.white,
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(50),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             width: double.infinity,
//             //color: Colors.red,
//             child: CupertinoSearchTextField(
//               autofocus: true,
//               onChanged: (value) {
//                 EasyDebounce.debounce(value, const Duration(milliseconds: 300),
//                     () {
//                   getPrediction(value: value);
//                 });
//               },
//             ),
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.only(top: 10),
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         child: Visibility(
//           visible: !isloading,
//           replacement: Column(
//             children: List.generate(
//                 6,
//                 (index) => Shimmer.fromColors(
//                       period: const Duration(milliseconds: 800),
//                       baseColor: CupertinoColors.tertiarySystemFill,
//                       highlightColor: Colors.grey.shade100,
//                       child: ListTile(
//                         leading: const CircleAvatar(),
//                         title: Container(
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.grey,
//                           ),
//                           width: 200,
//                           height: 20,
//                         ),
//                         subtitle: Container(
//                           margin: const EdgeInsets.only(top: 5, right: 20),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.grey,
//                           ),
//                           width: 100,
//                           height: 20,
//                         ),
//                       ),
//                     )),
//           ),
//           child: Column(children: [
//             Visibility(
//               visible: widget.showCurrentPosition,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: ListTile(
//                   onTap: () async {
//                     // isloading = true;
//                     // final a = await LocationService().getCurrentPosition();
//                     // isloading = false;
//                     // inspect(a);
//                     // widget.onCurrentPositionSelected!(a);
//                   },
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20)),
//                   trailing:
//                       const Icon(CupertinoIcons.chevron_right_circle_fill),
//                   leading: const Icon(
//                     CupertinoIcons.location_fill,
//                     color: Colors.blue,
//                   ),
//                   title: const Text('Prendre ma position actuelle'),
//                   tileColor: CupertinoColors.systemFill,
//                 ),
//               ),
//             ),
//             ...currenPredictions.map(
//               (e) => ListTile(
//                 onTap: () {
//                   widget.onSeleted!(fieldsDatails[e.placeId]!, e.primaryText,
//                       e.secondaryText, e.fullText);
//                 },
//                 leading: CircleAvatar(
//                   backgroundColor: CupertinoColors.systemFill,
//                   child: (fieldsDatails[e.placeId] != null)
//                       ? Image.network(
//                           fieldsDatails[e.placeId]!.icon!,
//                           height: 25,
//                         )
//                       : null,
//                 ),
//                 title: Text(e.primaryText),
//                 subtitle:
//                     (e.secondaryText.isNotEmpty) ? Text(e.secondaryText) : null,
//               ),
//             ),
//           ]),
//         ),
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () async {
//       //     final places =
//       //         FlutterGooglePlacesSdk("AIzaSyCflK5q24QvaR_CxlfW795PZKrE6VG6JLA");
//       //     FindAutocompletePredictionsResponse predictions = await places
//       //         .findAutocompletePredictions('Pharmatie', countries: ['CI']);

//       //     inspect(predictions.predictions.first);
//       //     final details = await Dio().get(
//       //       'https://maps.googleapis.com/maps/api/place/details/json',
//       //       queryParameters: {
//       //         "placeid": predictions.predictions.first.placeId,
//       //         "key": "AIzaSyCflK5q24QvaR_CxlfW795PZKrE6VG6JLA",
//       //       },
//       //     );
//       //     final result = PredictionPickerModel.fromJson(details.data['result']);
//       //     inspect(result);
//       //     //print('Result: $predictions');
//       //   },
//       // ),
//     );
//   }
// }
