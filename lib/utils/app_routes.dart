import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppRoutes {
  static void push(context, Widget page) {
    Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: page));
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => page,
    //   ),
    // );
  }

  static void pop(context) {
    Navigator.of(context).pop();
  }

  static void pushAndRemoveUntil(context, Widget page) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => page,
        ),
        (Route<dynamic> route) => false
        );
  }

  static void popUntil(context) {
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
