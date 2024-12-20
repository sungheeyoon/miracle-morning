import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miracle_morning/core/ids/hive_type_ids.dart';
import 'package:miracle_morning/features/home/models/todos_by_date_model.dart';
import 'package:miracle_morning/features/setting/models/notification_model.dart';
import 'package:miracle_morning/features/setting/repositories/time_of_day_adapter.dart';

part 'box_providers.g.dart';

// Todos Box
@riverpod
Future<Box<TodosByDateModel>> todoBox(TodoBoxRef ref) async {
  if (!Hive.isAdapterRegistered(HiveTypeIds.todoModel)) {
    Hive.registerAdapter(TodoModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveTypeIds.todosByDateModel)) {
    Hive.registerAdapter(TodosByDateModelAdapter());
  }
  return await Hive.openBox<TodosByDateModel>('todoBox');
}

// Notification Box
@riverpod
Future<Box<NotificationModel>> notificationBox(NotificationBoxRef ref) async {
  if (!Hive.isAdapterRegistered(HiveTypeIds.notificationModel)) {
    Hive.registerAdapter(NotificationModelAdapter());
  }
  return await Hive.openBox<NotificationModel>('notificationBox');
}

// Setting Box
@riverpod
Future<Box<bool>> settingBox(SettingBoxRef ref) async {
  if (!Hive.isAdapterRegistered(HiveTypeIds.timeOfDay)) {
    Hive.registerAdapter(TimeOfDayAdapter());
  }
  return await Hive.openBox<bool>('settingStateBox');
}

// 날짜별 완료 여부 box (true/false)
@riverpod
Future<Box<bool>> dailyCompletionBox(DailyCompletionBoxRef ref) async {
  return await Hive.openBox<bool>('dailyCompletionBox');
}

// 스트릭 정보 box (currentStreak, maxStreak, lastCompletedDate)
@riverpod
Future<Box> streakBox(StreakBoxRef ref) async {
  return await Hive.openBox('streakBox');
}
