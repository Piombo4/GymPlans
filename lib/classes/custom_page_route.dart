
import 'package:flutter/material.dart';

class CustomPageRoute<T> extends MaterialPageRoute<T>{
  CustomPageRoute({ required WidgetBuilder builder})
      : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }


}