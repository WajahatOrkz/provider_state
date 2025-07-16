import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SliderProvider with ChangeNotifier {
   double _opacity = 1.0;
  double get opacity => _opacity;

  void setSlider(double value) {

    _opacity = value;
      notifyListeners();
    }
  }


