import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings darwinInitializationSettings =
        const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings);

    await _localNotificationService.initialize(settings,
        onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse);
  }

  /// 알림 클릭 시 처리
  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    print('알림 클릭: ${response.payload}');
    // 필요시 여기에 클릭 시 로직 추가
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_name',
            channelDescription: 'description',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true);

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
  }

  Future<bool> checkNotificationPermission() async {
    final settings =
        await _localNotificationService.getNotificationAppLaunchDetails();
    return settings?.didNotificationLaunchApp ?? false;
  }

  Future<bool?> requestPermission() async {
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    if (Platform.isAndroid) {
      _requestAndroidPermission();
    }
    return null;
  }

  Future<bool?> _requestIOSPermission() async {
    return await _localNotificationService
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<bool?> _requestAndroidPermission() async {
    return await _localNotificationService
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // 반복 알림 예약
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    final tz.TZDateTime scheduleTime = _convertToNextInstance(time);

    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      await _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 같은 시간 반복
    );
  }

  // 시간 변환
  tz.TZDateTime _convertToNextInstance(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    return scheduledTime;
  }

  // 알림 취소
  Future<void> cancelNotification(int id) async {
    await _localNotificationService.cancel(id);
  }

  Future<void> showNotificaion({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    return await _localNotificationService.show(id, title, body, details);
  }

  Future<void> openNotificationSettings() async {
    AppSettings.openAppSettings(type: AppSettingsType.location);
  }
}
