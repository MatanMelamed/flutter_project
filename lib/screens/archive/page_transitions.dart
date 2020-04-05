import 'package:flutter/material.dart';

Route createRoute(Widget nextPage) {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        //var offsetAnimation = animation.drive(tween);

        //return child;
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}
