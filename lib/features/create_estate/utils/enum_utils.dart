import 'package:flutter/cupertino.dart';

enum EstateType {
  maison,
  appartement,
  villa,
  bureau,
  terrains,
}

class SelectionCardData<T> {
  Widget icon;
  String title;
  T state;
  SelectionCardData(
      {required this.icon, required this.title, required this.state});
}
