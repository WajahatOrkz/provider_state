import 'package:flutter/foundation.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;
  bool get isdarktheme => _isDarkTheme;
  void setTheme(bool isDarkTheme) {
    _isDarkTheme = isDarkTheme;
    notifyListeners();
  }
}
