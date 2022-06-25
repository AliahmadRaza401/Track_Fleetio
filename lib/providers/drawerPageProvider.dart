import 'package:flutter/material.dart';

class DrawerPageProvider extends ChangeNotifier {
  late BuildContext context;

  init({required BuildContext context}) {
    this.context = context;
  }

  int index = 0;

  setIndex(int val) {
    index = val;
    notifyListeners();
  }
}
