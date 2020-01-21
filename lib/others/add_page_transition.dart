import 'package:flutter/material.dart';

class AddPageTransition extends PageRouteBuilder {
  final Widget page;

  AddPageTransition({this.page})
      : super(
            transitionDuration: Duration(microseconds: 1),
            pageBuilder: (context, animation1, animation2) => page,
            transitionsBuilder: (context, animation1, animation, child) => child);

  @override
  bool get opaque => false;
}
