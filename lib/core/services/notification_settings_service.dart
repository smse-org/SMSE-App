
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsService {
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static final NotificationSettingsService _instance = NotificationSettingsService._internal();

  factory NotificationSettingsService() => _instance;
  NotificationSettingsService._internal();

  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true; // Default to true
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }
}