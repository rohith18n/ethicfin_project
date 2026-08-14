import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String _themeKey = 'app_theme_mode';
  final SharedPreferences sharedPreferences;

  ThemeCubit({required this.sharedPreferences}) : super(const ThemeState()) {
    _loadTheme();
  }

  void _loadTheme() {
    final isDark = sharedPreferences.getBool(_themeKey);
    if (isDark != null) {
      emit(ThemeState(themeMode: isDark ? ThemeMode.dark : ThemeMode.light));
    }
  }

  Future<void> toggleTheme() async {
    final nextMode = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(ThemeState(themeMode: nextMode));
    await sharedPreferences.setBool(_themeKey, nextMode == ThemeMode.dark);
  }
}
