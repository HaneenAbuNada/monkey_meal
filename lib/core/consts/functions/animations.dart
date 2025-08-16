import 'package:flutter/material.dart';

class NavAndAnimationsFunctions {
  const NavAndAnimationsFunctions._();

  static navToWithRTLAnimation(context, widget) => Navigator.push(context, RTLScreenAnimation(widget));

  static navToWithLTRAnimation(context, widget) => Navigator.push(context, LTRScreenAnimation(widget));

  static navAndFinish(context, widget) =>
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => widget), (route) {
        return false;
      });

  static navTo(context, widget) => Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

class RTLScreenAnimation extends PageRouteBuilder {
  final Widget page;

  RTLScreenAnimation(this.page)
    : super(
        pageBuilder: (context, animation, anotherAnimation) => page,
        transitionDuration: const Duration(milliseconds: 1000),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation = CurvedAnimation(
            curve: Curves.fastLinearToSlowEaseIn,
            parent: animation,
            reverseCurve: Curves.fastOutSlowIn,
          );
          return SlideTransition(
            position: Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
            child: page,
          );
        },
      );
}

class LTRScreenAnimation extends PageRouteBuilder {
  final Widget page;

  LTRScreenAnimation(this.page)
    : super(
        pageBuilder: (context, animation, anotherAnimation) => page,
        transitionDuration: const Duration(milliseconds: 1000),
        reverseTransitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, anotherAnimation, child) {
          animation = CurvedAnimation(
            curve: Curves.fastLinearToSlowEaseIn,
            parent: animation,
            reverseCurve: Curves.fastOutSlowIn,
          );
          return SlideTransition(
            position: Tween(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
            textDirection: TextDirection.rtl,
            child: page,
          );
        },
      );
}
