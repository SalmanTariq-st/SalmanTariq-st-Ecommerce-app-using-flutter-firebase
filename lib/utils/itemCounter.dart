import 'package:flutter/material.dart';

class itemCount with ChangeNotifier {
  int counter = 1;

  void increaseCount() {
    this.counter++;
    notifyListeners();
  }

  void decreaseCount() {
    this.counter--;
    notifyListeners();
  }
}
