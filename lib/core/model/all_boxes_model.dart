import 'package:hive_flutter/hive_flutter.dart';

/// 모든 Box 인스턴스를 담은 상태 객체
class AllBoxesModel {
  final Box todoBox;
  final Box notificationBox;
  final Box settingBox;
  final Box completionBox;
  final Box streakBox;

  AllBoxesModel({
    required this.todoBox,
    required this.notificationBox,
    required this.settingBox,
    required this.completionBox,
    required this.streakBox,
  });
}
