import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:smse/core/services/notification_settings_service.dart';
import 'dart:io' show Platform;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:uuid/uuid.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final NotificationSettingsService _settings = NotificationSettingsService();
  static const int downloadChannelId = 1;
  static const int uploadChannelId = 2;

  Future<void> initialize() async {
    if (kIsWeb) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/appicon');
    
    final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final WindowsInitializationSettings windowsSettings = WindowsInitializationSettings(
      appName: 'SMSE',
      appUserModelId: 'com.smse.app',
      guid: const Uuid().v4(),
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
      windows: windowsSettings,
    );

    await _notifications.initialize(initSettings);

    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  Future<void> _createNotificationChannels() async {
    const androidChannel = AndroidNotificationChannel(
      'downloads',
      'Downloads',
      description: 'Notifications for file downloads',
      importance: Importance.high,
    );

    const androidChannel2 = AndroidNotificationChannel(
      'uploads',
      'Uploads',
      description: 'Notifications for file uploads',
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel2);
  }

  Future<void> showDownloadProgress({
    required int id,
    required String title,
    required int progress,
  }) async {
    if (kIsWeb) return;

    final androidDetails = AndroidNotificationDetails(
      'downloads',
      'Downloads',
      channelDescription: 'Notifications for file downloads',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      ongoing: true,
      autoCancel: false,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      windows: const WindowsNotificationDetails(),
    );

    await _notifications.show(
      id,
      title,
      'Downloading... $progress%',
      notificationDetails,
    );
  }

  Future<void> showDownloadComplete({
    required int id,
    required String title,
    required String message,
  }) async {
    if (kIsWeb) return;

    final androidDetails = AndroidNotificationDetails(
      'downloads',
      'Downloads',
      channelDescription: 'Notifications for file downloads',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      windows: const WindowsNotificationDetails(),
    );

    await _notifications.show(id, title, message, notificationDetails);
  }

  Future<void> showUploadProgress({
    required int id,
    required String title,
    required int progress,
  }) async {
    if (kIsWeb) return;

    final androidDetails = AndroidNotificationDetails(
      'uploads',
      'Uploads',
      channelDescription: 'Notifications for file uploads',
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      ongoing: true,
      autoCancel: false,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      windows: const WindowsNotificationDetails(),
    );

    await _notifications.show(
      id,
      title,
      'Uploading... $progress%',
      notificationDetails,
    );
  }

  Future<void> showUploadComplete({
    required int id,
    required String title,
    required String message,
  }) async {
    if (kIsWeb) return;

    final androidDetails = AndroidNotificationDetails(
      'uploads',
      'Uploads',
      channelDescription: 'Notifications for file uploads',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      windows: const WindowsNotificationDetails(),
    );

    await _notifications.show(id, title, message, notificationDetails);
  }

  Future<void> showError({
    required int id,
    required String title,
    required String message,
  }) async {
    if (kIsWeb) return;

    final androidDetails = AndroidNotificationDetails(
      'downloads',
      'Downloads',
      channelDescription: 'Notifications for file downloads',
      importance: Importance.high,
      priority: Priority.high,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
      windows: const WindowsNotificationDetails(),
    );

    await _notifications.show(id, title, message, notificationDetails);
  }
} 