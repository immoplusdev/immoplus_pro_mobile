import 'package:flutter/cupertino.dart';

enum LogmentType {
  villa,
  house,
  apartment,
}

class SelectionCardData<T> {
  Widget icon;
  String title;
  T state;
  SelectionCardData(
      {required this.icon, required this.title, required this.state});
}
