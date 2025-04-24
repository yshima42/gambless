import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

@riverpod
class Theme extends _$Theme {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_key);
    if (themeString != null) {
      state = ThemeMode.values.firstWhere(
        (e) => e.toString() == themeString,
        orElse: () => ThemeMode.system,
      );
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.toString());
    state = mode;
  }

  bool get isDarkMode {
    if (state == ThemeMode.system) {
      final window = WidgetsBinding.instance.window;
      return window.platformBrightness == Brightness.dark;
    }
    return state == ThemeMode.dark;
  }

  void toggleTheme() {
    setThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }
}
