import 'package:flutter/material.dart';

class Inherited extends InheritedWidget {
  final bool isIos;
  final Widget childs;

  const Inherited({Key? key, required this.isIos, required this.childs})
      : super(key: key, child: childs);

  static Inherited? of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Inherited>());
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
