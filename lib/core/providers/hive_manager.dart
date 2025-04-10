import 'package:hive_flutter/hive_flutter.dart';
import 'package:miracle_morning/features/home/models/todos_by_date_model.dart';
import 'package:miracle_morning/features/setting/models/notification_model.dart';
import 'package:miracle_morning/features/statistics/model/growth_level.dart';
import 'package:miracle_morning/features/statistics/model/streak_model.dart';

class HiveManager {
  // 싱글톤 패턴
  static final HiveManager _instance = HiveManager._internal();

  factory HiveManager() {
    return _instance;
  }

  HiveManager._internal();

  // 박스 이름 상수 정의
  static const String todoBoxName = 'todoBox';
  static const String notificationBoxName = 'notificationBox';
  static const String settingBoxName = 'settingStateBox';
  static const String dailyCompletionBoxName = 'dailyCompletionBox';
  static const String streakBoxName = 'streakBox';
  static const String growthBoxName = 'growthBox';

  // 박스 캐시
  Box<TodosByDateModel>? _todoBox;
  Box<NotificationModel>? _notificationBox;
  Box<bool>? _settingBox;
  Box<bool>? _completionBox;
  Box<StreakModel>? _streakBox;
  Box<GrowthLevel>? _growthBox;

  // 박스 열기 메서드
  Future<Box<TodosByDateModel>> openTodoBox() async {
    if (_todoBox != null && _todoBox!.isOpen) {
      return _todoBox!;
    }
    _todoBox = await Hive.openBox<TodosByDateModel>(todoBoxName);
    return _todoBox!;
  }

  Future<Box<NotificationModel>> openNotificationBox() async {
    if (_notificationBox != null && _notificationBox!.isOpen) {
      return _notificationBox!;
    }
    _notificationBox =
        await Hive.openBox<NotificationModel>(notificationBoxName);
    return _notificationBox!;
  }

  Future<Box<bool>> openSettingBox() async {
    if (_settingBox != null && _settingBox!.isOpen) {
      return _settingBox!;
    }
    _settingBox = await Hive.openBox<bool>(settingBoxName);
    return _settingBox!;
  }

  Future<Box<bool>> openDailyCompletionBox() async {
    if (_completionBox != null && _completionBox!.isOpen) {
      return _completionBox!;
    }
    _completionBox = await Hive.openBox<bool>(dailyCompletionBoxName);
    return _completionBox!;
  }

  Future<Box<StreakModel>> openStreakBox() async {
    if (_streakBox != null && _streakBox!.isOpen) {
      return _streakBox!;
    }
    _streakBox = await Hive.openBox(streakBoxName);
    return _streakBox!;
  }

  Future<Box<GrowthLevel>> openGrowthBox() async {
    if (_growthBox != null && _growthBox!.isOpen) {
      return _growthBox!;
    }
    _growthBox = await Hive.openBox<GrowthLevel>(growthBoxName);
    return _growthBox!;
  }

  // 모든 박스 열기
  Future<void> openAllBoxes() async {
    await Future.wait([
      openTodoBox(),
      openNotificationBox(),
      openSettingBox(),
      openDailyCompletionBox(),
      openStreakBox(),
      openGrowthBox(),
    ]);
  }

  // 박스 닫기
  Future<void> closeAllBoxes() async {
    await Future.wait([
      if (_todoBox != null && _todoBox!.isOpen) _todoBox!.close(),
      if (_notificationBox != null && _notificationBox!.isOpen)
        _notificationBox!.close(),
      if (_settingBox != null && _settingBox!.isOpen) _settingBox!.close(),
      if (_completionBox != null && _completionBox!.isOpen)
        _completionBox!.close(),
      if (_streakBox != null && _streakBox!.isOpen) _streakBox!.close(),
      if (_growthBox != null && _growthBox!.isOpen) _growthBox!.close(),
    ]);
  }
}
