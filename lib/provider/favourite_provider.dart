import 'package:flutter/foundation.dart';
class FavouriteProvider with ChangeNotifier {

  List<int> _selectedItems = [];
  List<int> get selectedItems => _selectedItems;

  void toggleItem(int itemId) {
    if (_selectedItems.contains(itemId)) {
      _selectedItems.remove(itemId);
    } else {
      _selectedItems.add(itemId);
    }
    notifyListeners();
  }
}