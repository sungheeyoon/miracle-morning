import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miracle_morning/core/providers/box_providers.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/core/utils.dart';
import 'package:miracle_morning/features/statistics/repositories/streak_repository.dart';

part 'completion_repository.g.dart';

@riverpod
Future<CompletionRepository> completionRepository(
    CompletionRepositoryRef ref) async {
  final completionBoxInstance =
      await ref.watch(dailyCompletionBoxProvider.future);
  return CompletionRepository(completionBoxInstance, ref);
}

class CompletionRepository {
  final Box<bool> _completionBox;
  final CompletionRepositoryRef _ref;

  CompletionRepository(this._completionBox, this._ref);

  // 날짜의 Todo 완료 상태 업데이트
  Future<void> updateDailyCompletion(
      DateTime date, List<TodoModel> todos) async {
    final key = getDateKey(date);

    // 이전 상태 기록
    final previousStatus = _completionBox.get(key, defaultValue: false);

    // 새로운 상태 계산
    bool newStatus = false;
    if (todos.isNotEmpty) {
      newStatus = todos.every((t) => t.isCompleted);
    }

    // 상태가 변경된 경우에만 저장 (false인 경우에는 저장하지 않음)
    if (newStatus) {
      await _completionBox.put(key, true);
    } else {
      // false인 경우 키가 존재하면 삭제
      if (_completionBox.containsKey(key)) {
        await _completionBox.delete(key);
      }
    }

    // 상태가 변경된 경우 스트릭 재계산 트리거
    if (previousStatus != newStatus) {
      try {
        final streakRepo = await _ref.read(streakRepositoryProvider.future);
        await streakRepo.onCompletionStatusChanged(date);
      } catch (e) {
        // 스트릭 업데이트 실패 시 기본 기능은 계속 동작하도록 함
      }
    }
  }

  // 특정 날짜의 완료 상태 조회
  Future<bool> isDayCompleted(DateTime date) async {
    final key = getDateKey(date);
    // Box에 키가 없으면 false 반환 (BoxBase.get의 defaultValue 사용)
    return _completionBox.get(key, defaultValue: false) ?? false;
  }

  // 완료된 날짜 목록 반환
  Future<List<DateTime>> getAllCompletedDates() async {
    final List<DateTime> completedDates = [];

    // Box의 모든 키(날짜) 순회
    for (final key in _completionBox.keys) {
      // 문자열 키인 경우만 처리
      if (key is String) {
        final isCompleted = _completionBox.get(key, defaultValue: false);
        if (isCompleted == true) {
          try {
            // 날짜 문자열을 DateTime으로 변환
            final parts = key.split('-');
            if (parts.length == 3) {
              final year = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final day = int.parse(parts[2]);
              completedDates.add(DateTime(year, month, day));
            }
          } catch (e) {
            // 오류가 있는 키는 건너뜀
          }
        }
      }
    }

    return completedDates;
  }

  // 특정 기간 내 완료된 날짜 수 반환
  Future<int> getCompletedDaysCount(DateTime start, DateTime end) async {
    int count = 0;

    for (DateTime date = start;
        !date.isAfter(end);
        date = date.add(const Duration(days: 1))) {
      final key = getDateKey(date);
      final isCompleted = _completionBox.get(key, defaultValue: false) ?? false;
      if (isCompleted) {
        count++;
      }
    }

    return count;
  }
}
