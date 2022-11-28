import 'package:flutter/material.dart';

class priceCounter with ChangeNotifier {
  int sum;

  priceCounter(this.sum);
  void increasePrice(int price) {
    sum = sum + price;
    notifyListeners();
  }

  int notify() {
    notifyListeners();
    return sum;
  }

  void decreasePrice(int price) {
    this.sum = this.sum - price;
    notifyListeners();
  }
}
