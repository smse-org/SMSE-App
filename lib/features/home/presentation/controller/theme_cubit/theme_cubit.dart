import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/utililes/cached_sp.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  // Load theme preference from SharedPreferences
  Future<void> loadTheme() async {
    await CachedData.cachInit(); // Ensure SharedPreferences is initialized
    bool isDark = CachedData.getData('isDark') ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  // Toggle theme and save preference
  Future<void> toggleTheme() async {
    ThemeMode newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    CachedData.storeData('isDark', newMode == ThemeMode.dark);
    emit(newMode);
  }
}
