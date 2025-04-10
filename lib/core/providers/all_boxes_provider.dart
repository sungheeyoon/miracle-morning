import 'package:miracle_morning/core/providers/box_providers.dart';
import 'package:miracle_morning/features/home/models/todos_by_date_model.dart';
import 'package:miracle_morning/features/setting/models/notification_model.dart';
import 'package:miracle_morning/features/statistics/model/growth_level.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'all_boxes_provider.g.dart';

@riverpod
Future<AllBoxesModel> allBoxes(AllBoxesRef ref) async {
  try {
    final hiveManager = ref.watch(hiveManagerProvider);
    await hiveManager.openAllBoxes();

    return AllBoxesModel(
      todoBox: await ref.watch(todoBoxProvider.future),
      notificationBox: await ref.watch(notificationBoxProvider.future),
      settingBox: await ref.watch(settingBoxProvider.future),
      completionBox: await ref.watch(dailyCompletionBoxProvider.future),
      streakBox: await ref.watch(streakBoxProvider.future),
      growthBox: await ref.watch(growthBoxProvider.future),
    );
  } catch (e) {
    throw Exception('Error opening boxes: $e');
  }
}

class AllBoxesModel {
  final Box<TodosByDateModel> todoBox;
  final Box<NotificationModel> notificationBox;
  final Box<bool> settingBox;
  final Box<bool> completionBox;
  final Box streakBox;
  final Box<GrowthLevel> growthBox;

  AllBoxesModel({
    required this.todoBox,
    required this.notificationBox,
    required this.settingBox,
    required this.completionBox,
    required this.streakBox,
    required this.growthBox,
  });
}
