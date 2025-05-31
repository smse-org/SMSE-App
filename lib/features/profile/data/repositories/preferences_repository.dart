import 'package:smse/features/profile/data/models/user_preferences.dart';

abstract class PreferencesRepository {
  Future<UserPreferences> getUserPreferences();
  Future<void> updateUserPreferences(UserPreferences preferences);
} 