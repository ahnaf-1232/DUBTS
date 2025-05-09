import 'package:dubts/core/services/storage_service.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  final StorageService _storageService;
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeProvider(this._storageService) {
    _loadTheme();
  }
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  Future<void> _loadTheme() async {
    final themeString = await _storageService.read('theme');
    if (themeString != null) {
      _themeMode = themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }
  
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _storageService.write('theme', mode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
  
  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    await _storageService.write('theme', _themeMode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}