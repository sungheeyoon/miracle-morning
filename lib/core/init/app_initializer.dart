import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:miracle_morning/core/ids/hive_type_ids.dart';
import 'package:miracle_morning/core/notification/notification_service.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/models/todos_by_date_model.dart';
import 'package:miracle_morning/features/setting/models/notification_model.dart';
import 'package:miracle_morning/features/setting/repositories/time_of_day_adapter.dart';
import 'package:miracle_morning/features/statistics/model/growth_level.dart';
import 'package:miracle_morning/features/statistics/model/streak_model.dart';
import 'package:timezone/data/latest.dart' as tz;

class AppInitializer {
  static Future<void> initialize() async {
    // 필요한 모든 초기화 작업
    await initializeDateFormatting('ko_KR', '');
    await Hive.initFlutter();
    tz.initializeTimeZones();

    // 하이브 어댑터 등록을 한 곳에서 처리
    _registerHiveAdapters();

    // 알림 초기화
    final localNotificationService = LocalNotificationService();
    await localNotificationService.initialize();
  }

  static void _registerHiveAdapters() {
    // Todo 관련 어댑터
    if (!Hive.isAdapterRegistered(HiveTypeIds.todoModel)) {
      Hive.registerAdapter(TodoModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTypeIds.todosByDateModel)) {
      Hive.registerAdapter(TodosByDateModelAdapter());
    }

    // 알림 관련 어댑터
    if (!Hive.isAdapterRegistered(HiveTypeIds.notificationModel)) {
      Hive.registerAdapter(NotificationModelAdapter());
    }

    // 설정 관련 어댑터
    if (!Hive.isAdapterRegistered(HiveTypeIds.timeOfDay)) {
      Hive.registerAdapter(TimeOfDayAdapter());
    }

    // 성장 관련 어댑터
    if (!Hive.isAdapterRegistered(HiveTypeIds.growthLevel)) {
      Hive.registerAdapter(GrowthLevelAdapter());
    }

    // 성장 관련 어댑터
    if (!Hive.isAdapterRegistered(HiveTypeIds.streakModel)) {
      Hive.registerAdapter(StreakModelAdapter());
    }
  }
}
