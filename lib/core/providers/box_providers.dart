import 'package:miracle_morning/core/providers/hive_manager.dart';
import 'package:miracle_morning/features/home/models/todos_by_date_model.dart';
import 'package:miracle_morning/features/setting/models/notification_model.dart';
import 'package:miracle_morning/features/statistics/model/growth_level.dart';
import 'package:miracle_morning/features/statistics/model/streak_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'box_providers.g.dart';

@riverpod
HiveManager hiveManager(HiveManagerRef ref) {
  return HiveManager();
}

@riverpod
Future<Box<TodosByDateModel>> todoBox(TodoBoxRef ref) async {
  final hiveManager = ref.watch(hiveManagerProvider);
  return await hiveManager.openTodoBox();
}

@riverpod
Future<Box<NotificationModel>> notificationBox(NotificationBoxRef ref) async {
  final hiveManager = ref.watch(hiveManagerProvider);
  return await hiveManager.openNotificationBox();
}

@riverpod
Future<Box<bool>> settingBox(SettingBoxRef ref) async {
  final hiveManager = ref.watch(hiveManagerProvider);
  return await hiveManager.openSettingBox();
}

@riverpod
Future<Box<bool>> dailyCompletionBox(DailyCompletionBoxRef ref) async {
  final hiveManager = ref.watch(hiveManagerProvider);
  return await hiveManager.openDailyCompletionBox();
}

@riverpod
Future<Box<StreakModel>> streakBox(StreakBoxRef ref) async {
  final hiveManager = ref.watch(hiveManagerProvider);
  return await hiveManager.openStreakBox();
}

@riverpod
Future<Box<GrowthLevel>> growthBox(GrowthBoxRef ref) async {
  final hiveManager = ref.watch(hiveManagerProvider);
  return await hiveManager.openGrowthBox();
}
