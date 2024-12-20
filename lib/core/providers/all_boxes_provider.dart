import 'package:miracle_morning/core/model/all_boxes_model.dart';
import 'package:miracle_morning/core/providers/box_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'all_boxes_provider.g.dart';

@riverpod
Future<AllBoxesModel> allBoxes(AllBoxesRef ref) async {
  try {
    final todoBoxInst = await ref.watch(todoBoxProvider.future);
    final notificationBoxInst = await ref.watch(notificationBoxProvider.future);
    final settingBoxInst = await ref.watch(settingBoxProvider.future);
    final completionBoxInst =
        await ref.watch(dailyCompletionBoxProvider.future);
    final streakBoxInst = await ref.watch(streakBoxProvider.future);

    return AllBoxesModel(
      todoBox: todoBoxInst,
      notificationBox: notificationBoxInst,
      settingBox: settingBoxInst,
      completionBox: completionBoxInst,
      streakBox: streakBoxInst,
    );
  } catch (e) {
    throw Exception('Error opening boxes: $e');
  }
}
