import 'package:miracle_morning/core/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miracle_morning/core/providers/box_providers.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';

part 'completion_repository.g.dart';

//일별 todos 완료 여부 관리
@riverpod
Future<CompletionRepository> completionRepository(
    CompletionRepositoryRef ref) async {
  final completionBoxInstance =
      await ref.watch(dailyCompletionBoxProvider.future);
  return CompletionRepository(completionBoxInstance);
}

class CompletionRepository {
  final Box<bool> _completionBox;

  CompletionRepository(this._completionBox);

  Future<void> updateDailyCompletion(
      DateTime date, List<TodoModel> todos) async {
    final key = getDateKey(date);
    if (todos.isEmpty) {
      // empty는 false로 처리
      await _completionBox.put(key, false);
    } else {
      final allCompleted = todos.every((t) => t.isCompleted);
      await _completionBox.put(key, allCompleted);
    }
  }

  Future<bool> isDayCompleted(DateTime date) async {
    final key = getDateKey(date);
    return _completionBox.get(key, defaultValue: false) ?? false;
  }
}
