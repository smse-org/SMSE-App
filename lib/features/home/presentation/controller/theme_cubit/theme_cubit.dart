import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/utililes/cachedSP.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  // Load theme preference from SharedPreferences
  void loadTheme() {
    bool? isDark = CachedData.getData('isDark');
    emit(isDark == true ? ThemeMode.dark : ThemeMode.light);
  }

  // Toggle theme and save preference
  void toggleTheme() async {
    ThemeMode newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
     CachedData.storeData('isDark', newMode == ThemeMode.dark);
    emit(newMode);
  }
}
