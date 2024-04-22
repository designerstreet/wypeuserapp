import 'package:flutter/material.dart';

class UserLang extends ChangeNotifier {
  bool isAr = false;
  void changeLanguage(String newLanguage) {
    if (newLanguage == "ar") {
      isAr = true;
    } else {
      isAr = false;
    }
    notifyListeners();
  }
}
