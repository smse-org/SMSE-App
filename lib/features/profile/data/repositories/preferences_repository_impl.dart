import 'package:dio/dio.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/profile/data/models/user_preferences.dart';
import 'package:smse/features/profile/data/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final ApiService _apiService;

  PreferencesRepositoryImpl(this._apiService);

  @override
  Future<UserPreferences> getUserPreferences() async {
    try {
      final response = await _apiService.get(endpoint: 'user/preferences');
      // The response is already a Map, no need to access .data
      return UserPreferences.fromJson(response['preferences'] ?? {});
    } catch (e) {
      throw Exception('Failed to get user preferences: $e');
    }
  }

  @override
  Future<void> updateUserPreferences(UserPreferences preferences) async {
    try {
      await _apiService.put(
        endpoint: 'user/preferences',
        token: true,
        data: preferences.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update user preferences: $e');
    }
  }

  @override
  Future<bool> getThemeMode() async {
    try {
      final response = await _apiService.get(endpoint: 'user/preferences');
      // The response is already a Map, no need to access .data
      return response['preferences']['isDarkMode'] ?? false;
    } catch (e) {
      return false; // Default to light theme if there's an error
    }
  }

  @override
  Future<void> setThemeMode(bool isDarkMode) async {
    try {
      final currentPreferences = await getUserPreferences();
      final updatedPreferences = currentPreferences.copyWith(isDarkMode: isDarkMode);
      await updateUserPreferences(updatedPreferences);
    } catch (e) {
      throw Exception('Failed to set theme mode: $e');
    }
  }
} 