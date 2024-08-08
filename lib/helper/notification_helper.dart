import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static ValueNotifier<String> payload = ValueNotifier("");

  void setPayload(String newPayload) {
    payload.value = newPayload;
  }

  static AndroidNotificationDetails androidNotificationDetails =
      const AndroidNotificationDetails(
    "Local Notif",
    'Sanber Local Notif',
    channelDescription: 'Untuk percobaan Local Notif',
    importance: Importance.max,
    priority: Priority.high,
    icon: '@mipmap/ic_launcher',
    playSound: true,
    enableVibration: true,
  );

  /// Inisialisasikan Setting Channel Notifikasi untuk iOS/MacOS
  static DarwinNotificationDetails iOSNotificationDetails =
      const DarwinNotificationDetails(
    threadIdentifier: 'local_notif',
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  /// Notifications Details untuk multi platform
  static NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: iOSNotificationDetails,
  );

  /// Inisialisasi flutter_local_notifications
  Future<void> initLocalNotifications() async {
    /// Config for Android
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    /// Config for iOS & MacOS
    const initializationSettingsIOS = DarwinInitializationSettings();

    /// Initializations.
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    /// Inisialisasikan Konfigurasi dari Local Notification.
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        /// Handle ketika notifikasi ditekan.
        debugPrint("Notifikasi Ditekan ${details.payload}");
        setPayload(details.payload ?? '');
      },
    );

    /// Request Permission untuk Android 13 ke atas.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    /// Request Permission untuk iOS
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }
}