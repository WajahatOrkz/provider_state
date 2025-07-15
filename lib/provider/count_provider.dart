import 'package:flutter/foundation.dart';

class CountProvider with ChangeNotifier {
  int count = 100;
  int get getCount => count;

  void increment() {
    count++;
    notifyListeners();
  }

  void decrement() {
    count--;
    notifyListeners();
  }

  void reset() {
    count = 0;
    notifyListeners();
  }
}
