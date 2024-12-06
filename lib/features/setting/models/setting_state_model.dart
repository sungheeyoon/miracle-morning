import 'package:flutter/material.dart';

class SettingStateModel {
  final bool isAllNotificationEnabled;
  final bool isTodoNotificationEnabled;
  final bool isCheckNotificationEnabled;
  final TimeOfDay todoNotificationTime;
  final TimeOfDay checkNotificationTime;

  const SettingStateModel({
    required this.isAllNotificationEnabled,
    required this.isTodoNotificationEnabled,
    required this.isCheckNotificationEnabled,
    required this.todoNotificationTime,
    required this.checkNotificationTime,
  });

  SettingStateModel copyWith({
    bool? isAllNotificationEnabled,
    bool? isTodoNotificationEnabled,
    bool? isCheckNotificationEnabled,
    TimeOfDay? todoNotificationTime,
    TimeOfDay? checkNotificationTime,
  }) {
    return SettingStateModel(
      isAllNotificationEnabled:
          isAllNotificationEnabled ?? this.isAllNotificationEnabled,
      isTodoNotificationEnabled:
          isTodoNotificationEnabled ?? this.isTodoNotificationEnabled,
      isCheckNotificationEnabled:
          isCheckNotificationEnabled ?? this.isCheckNotificationEnabled,
      todoNotificationTime: todoNotificationTime ?? this.todoNotificationTime,
      checkNotificationTime:
          checkNotificationTime ?? this.checkNotificationTime,
    );
  }

  @override
  String toString() {
    return '''
SettingState {
  isAllNotificationEnabled: $isAllNotificationEnabled,
  isTodoNotificationEnabled: $isTodoNotificationEnabled,
  isCheckNotificationEnabled: $isCheckNotificationEnabled,
  todoNotificationTime: ${todoNotificationTime.hour}:${todoNotificationTime.minute.toString().padLeft(2, '0')},
  checkNotificationTime: ${checkNotificationTime.hour}:${checkNotificationTime.minute.toString().padLeft(2, '0')}
}
''';
  }
}
