import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'notification_model.g.dart';

enum NotificationType {
  todo,
  check,
}

@HiveType(typeId: 1)
class NotificationModel {
  @HiveField(0)
  final bool isEnabled;

  @HiveField(1)
  final TimeOfDay time;

  NotificationModel({required this.isEnabled, required this.time});

  // NotificationType에 따라 기본값 반환
  factory NotificationModel.defaultValue(NotificationType type) {
    switch (type) {
      case NotificationType.todo:
        return NotificationModel(
          isEnabled: false,
          time: const TimeOfDay(hour: 8, minute: 0),
        );
      case NotificationType.check:
        return NotificationModel(
          isEnabled: false,
          time: const TimeOfDay(hour: 21, minute: 0),
        );
    }
  }

  @override
  String toString() {
    return 'NotificationModel(isEnabled: $isEnabled, time: $time)';
  }
}
