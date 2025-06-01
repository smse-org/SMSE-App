import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smse/features/profile/data/repositories/preferences_repository_impl.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final PreferencesRepositoryImpl _preferencesRepository;
  static const ThemeMode _defaultTheme = ThemeMode.light;

  ThemeCubit(this._preferencesRepository) : super(_defaultTheme) {
    _initializeTheme();
  }

  Future<void> _initializeTheme() async {
    try {
      final isDarkMode = await _preferencesRepository.getThemeMode();
      emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      print('Error initializing theme: $e');
      emit(_defaultTheme);
    }
  }

  Future<void> toggleTheme() async {
    try {
      final newThemeMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      await _preferencesRepository.setThemeMode(newThemeMode == ThemeMode.dark);
      emit(newThemeMode);
    } catch (e) {
      print('Error toggling theme: $e');
      // If saving fails, revert to the previous theme
      emit(state);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      await _preferencesRepository.setThemeMode(mode == ThemeMode.dark);
      emit(mode);
    } catch (e) {
      print('Error setting theme: $e');
      emit(state);
    }
  }

  Future<void> resetToDefault() async {
    try {
      await _preferencesRepository.setThemeMode(_defaultTheme == ThemeMode.dark);
      emit(_defaultTheme);
    } catch (e) {
      print('Error resetting theme: $e');
      emit(state);
    }
  }
}
