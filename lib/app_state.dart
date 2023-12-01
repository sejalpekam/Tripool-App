import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int selectedCategoryId = 0;
  String search = "";

  void updateCategoryId(int selectedCategoryId) {
    this.selectedCategoryId = selectedCategoryId;
    notifyListeners();
  }

  void updateSearch(String search) {
    this.search = search;
    notifyListeners();
  }
}
