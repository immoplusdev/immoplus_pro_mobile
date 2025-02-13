// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geojson_vi/geojson_vi.dart';
// import 'package:immoplus_pro/modules/module_location_picker/lacation_picker.dart';

// class PickerocationListTile extends StatefulWidget {
//   PickerocationListTile({
//     super.key,
//     required this.placeHolder,
//     this.leading,
//     required this.onSeleted,
//     this.currentValue,
//     this.showCurrentPosition = false,
//     this.backgroundColor,
//   });
//   final String placeHolder;
//   final Widget? leading;
//   final GeoJSONFeature? currentValue;
//   final bool showCurrentPosition;
//   final void Function(GeoJSONFeature)? onSeleted;
//   final Color? backgroundColor;
//   @override
//   State<PickerocationListTile> createState() => _PickerocationListTileState();
// }

// class _PickerocationListTileState extends State<PickerocationListTile> {
//   String title = '';
//   String subtitle = '';
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(20),
//       child: CupertinoListTile(
//         backgroundColor:
//             widget.backgroundColor ?? CupertinoColors.tertiarySystemFill,
//         title: title.isEmpty
//             ? (widget.currentValue == null)
//                 ? Text(widget.placeHolder)
//                 : Text(widget.currentValue!.properties!['title'].toString())
//             : Text(title),
//         subtitle: (subtitle.isNotEmpty)
//             ? (widget.currentValue == null)
//                 ? Text(subtitle)
//                 : Text(widget.currentValue!.properties!['subtitle'].toString())
//             : (widget.currentValue != null)
//                 ? Text(widget.currentValue!.properties!['subtitle'].toString())
//                 : null,
//         leading: widget.leading,
//         trailing: const Icon(CupertinoIcons.chevron_right_circle_fill),
//         onTap: () {
//           showModalBottomSheet(
//             context: context,
//             isScrollControlled: true,
//             showDragHandle: true,
//             backgroundColor: Colors.white,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//             builder: (context) => Container(
//               height: MediaQuery.of(context).size.height * 0.8,
//               padding: const EdgeInsets.only(top: 15),
//               child: LocationPickerPage(
//                 showCurrentPosition: widget.showCurrentPosition,
//                 onSeleted: (value, titl, subtitl, fullText) {
//                   widget.onSeleted!(GeoJSONFeature(
//                       GeoJSONPoint([
//                         value.geometry!.location!.lng!,
//                         value.geometry!.location!.lat!
//                       ]),
//                       properties: {
//                         "title": titl,
//                         "subtitle": subtitl,
//                         "name": fullText,
//                       }));
//                   setState(() {
//                     title = titl;
//                     subtitle = subtitl;
//                   });

//                   Navigator.pop(context);
//                 },
//                 onCurrentPositionSelected: (value) {
//                   if (value != null) {
//                     widget.onSeleted!(value);
//                     setState(() {
//                       title = value.properties!['title'];
//                       subtitle = subtitle;
//                     });

//                     Navigator.pop(context);
//                   }
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
