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

  static void _onDidReceiveNotificationResponse(NotificationResponse response) {
    // 알림 클릭 시 처리
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

  // 실제 알림 권한 확인 메서드 (개선됨)
  Future<bool> checkNotificationPermission() async {
    if (Platform.isIOS) {
      // iOS에서는 직접적인 확인이 어려워 임시 방편으로 권한 요청 시도
      final permissionStatus = await _requestIOSPermission();
      return permissionStatus ?? false;
    } else if (Platform.isAndroid) {
      // Android에서 권한 상태 확인
      final permissionStatus = await _localNotificationService
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
      return permissionStatus ?? false;
    }
    return false;
  }

  Future<bool?> requestPermission() async {
    bool? result;
    if (Platform.isIOS) {
      result = await _requestIOSPermission();
    }
    if (Platform.isAndroid) {
      result = await _requestAndroidPermission();
    }
    return result;
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

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    // 권한 확인 후 알림 예약
    final hasPermission = await checkNotificationPermission();
    if (!hasPermission) {
      return; // 권한 없으면 알림 설정 불가
    }
    
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
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

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

  // 알림 설정 화면으로 이동 (수정)
  Future<void> openNotificationSettings() async {
    AppSettings.openAppSettings(type: AppSettingsType.notification);
  }
}
