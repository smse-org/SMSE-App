import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:smse/core/services/notification_settings_service.dart';
import 'dart:io' show Platform;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  final NotificationSettingsService _settings = NotificationSettingsService();
  static const int downloadChannelId = 1;
  static const int uploadChannelId = 2;

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/appicon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        debugPrint('Notification tapped: ${response.payload}');
      },
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  Future<void> _createNotificationChannels() async {
    const downloadChannel = AndroidNotificationChannel(
      'download_channel',
      'Downloads',
      description: 'Notifications for file downloads',
      importance: Importance.high,
    );

    const uploadChannel = AndroidNotificationChannel(
      'upload_channel',
      'Uploads',
      description: 'Notifications for file uploads',
      importance: Importance.high,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(downloadChannel);

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(uploadChannel);
  }

  Future<void> showDownloadProgress({
    required String fileName,
    required int progress,
    required int notificationId,
  }) async {
    if (!await _settings.areNotificationsEnabled()) return;

    final androidDetails = AndroidNotificationDetails(
      'download_channel',
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

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      notificationId,
      'Downloading $fileName',
      'Progress: $progress%',
      notificationDetails,
    );
  }

  Future<void> showDownloadComplete({
    required String fileName,
    required int notificationId,
  }) async {
    if (!await _settings.areNotificationsEnabled()) return;

    final androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelDescription: 'Notifications for file downloads',
      importance: Importance.high,
      priority: Priority.high,
      autoCancel: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      notificationId,
      'Download Complete',
      '$fileName has been downloaded successfully',
      notificationDetails,
    );
  }

  Future<void> showUploadProgress({
    required String fileName,
    required int progress,
    required int notificationId,
  }) async {
    if (!await _settings.areNotificationsEnabled()) return;

    final androidDetails = AndroidNotificationDetails(
      'upload_channel',
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

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      notificationId,
      'Uploading $fileName',
      'Progress: $progress%',
      notificationDetails,
    );
  }

  Future<void> showUploadComplete({
    required String fileName,
    required int notificationId,
  }) async {
    if (!await _settings.areNotificationsEnabled()) return;

    final androidDetails = AndroidNotificationDetails(
      'upload_channel',
      'Uploads',
      channelDescription: 'Notifications for file uploads',
      importance: Importance.high,
      priority: Priority.high,
      autoCancel: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      notificationId,
      'Upload Complete',
      '$fileName has been uploaded successfully',
      notificationDetails,
    );
  }

  Future<void> showError({
    required String title,
    required String message,
    required int notificationId,
  }) async {
    if (!await _settings.areNotificationsEnabled()) return;

    final androidDetails = AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelDescription: 'Notifications for file downloads',
      importance: Importance.high,
      priority: Priority.high,
      autoCancel: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      notificationId,
      title,
      message,
      notificationDetails,
    );
  }
} 