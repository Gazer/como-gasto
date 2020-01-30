import 'package:flutter/material.dart';

class ThemeState with ChangeNotifier {
  bool _isDarkModeEnabled = false;

  ThemeData get currentTheme => _isDarkModeEnabled
      ? ThemeData.dark().copyWith(
          accentColor: Colors.red,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.red,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          toggleableActiveColor: Colors.red,
        )
      : _getThemeLight();

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void setDarkMode(bool b) {
    _isDarkModeEnabled = b;
    notifyListeners();
  }

  ThemeData _getThemeLight() {
    final theme = ThemeData(
      primarySwatch: Colors.deepPurple,
    );

    return theme;
  }
}
