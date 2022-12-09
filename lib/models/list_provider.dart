import 'package:flutter/foundation.dart';

class ListProvider with ChangeNotifier{
  List<String> list = [];

  void addItem(String Item)
  {
    list.add(Item);
    notifyListeners();
  }
  void deleteItem(int index)
  {
    list.removeAt(index);
    notifyListeners();
  }
}