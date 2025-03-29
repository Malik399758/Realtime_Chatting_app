import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isActive = false;

  bool get isActive => _isActive;

  void toggleTheme() {
    _isActive = !_isActive;
    notifyListeners();
  }
}
