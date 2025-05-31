import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/profile/data/models/user_preferences.dart';
import 'package:smse/features/profile/data/repositories/preferences_repository.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final PreferencesRepository _preferencesRepository;

  ThemeCubit(this._preferencesRepository) : super(ThemeMode.light);

  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(newTheme);
    
    try {
      // Get current preferences
      final currentPreferences = await _preferencesRepository.getUserPreferences();
      
      // Update preferences with new theme
      final updatedPreferences = currentPreferences.copyWith(
        isDarkMode: newTheme == ThemeMode.dark,
      );
      
      // Save to backend
      await _preferencesRepository.updateUserPreferences(updatedPreferences);
    } catch (e) {
      print('Failed to update theme preferences: $e');
      // Revert theme if update fails
      emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
    }
  }

  Future<void> loadThemeFromPreferences() async {
    try {
      final preferences = await _preferencesRepository.getUserPreferences();
      emit(preferences.isDarkMode ? ThemeMode.dark : ThemeMode.light);
    } catch (e) {
      print('Failed to load theme preferences: $e');
      // Default to light theme if loading fails
      emit(ThemeMode.light);
    }
  }
}
