import 'package:miracle_morning/core/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miracle_morning/core/providers/box_providers.dart';
import 'package:miracle_morning/features/home/repositories/completion_repository.dart';

part 'streak_repository.g.dart';

@riverpod
Future<StreakRepository> streakRepository(StreakRepositoryRef ref) async {
  final streakBoxInstance = await ref.watch(streakBoxProvider.future);
  final completionRepo = await ref.watch(completionRepositoryProvider.future);
  return StreakRepository(streakBoxInstance, completionRepo);
}

class StreakRepository {
  final Box _streakBox;
  final CompletionRepository _completionRepo;

  StreakRepository(this._streakBox, this._completionRepo);

  Future<void> updateStreak(DateTime yesterday) async {
    // 전날 완료 여부 조회
    final yesterdayCompleted = await _completionRepo.isDayCompleted(yesterday);

    final currentStreak =
        _streakBox.get('currentStreak', defaultValue: 0) as int;
    final maxStreak = _streakBox.get('maxStreak', defaultValue: 0) as int;
    final lastCompletedDate =
        _streakBox.get('lastCompletedDate', defaultValue: '') as String;
    final maxStreakLastDate =
        _streakBox.get('maxStreakLastDate', defaultValue: '') as String;

    int newStreak = 0;
    int newMax = maxStreak;
    String newLastCompletedDate = lastCompletedDate;
    String newMaxStreakLastDate = maxStreakLastDate;

    if (yesterdayCompleted) {
      // 연속성 체크
      if (lastCompletedDate.isEmpty) {
        // 첫 완료 시작
        newStreak = 1;
      } else {
        final lastDate = _parseDate(lastCompletedDate);
        // 연속인지 확인: 전 마지막 완료일+1일 == yesterday
        if (yesterday.difference(lastDate).inDays == 1) {
          newStreak = currentStreak + 1;
        } else {
          // 연속 끊긴 뒤 다시 시작
          newStreak = 1;
        }
      }

      // maxStreak 갱신 필요성 체크
      if (newStreak > maxStreak) {
        newMax = newStreak;
        newMaxStreakLastDate = _getDateKey(yesterday);
      }

      newLastCompletedDate = _getDateKey(yesterday);
    } else {
      // 어제 미완료 => streak 리셋
      newStreak = 0;
      // maxStreak 변동 없음
      // lastCompletedDate, maxStreakLastDate 변동 없음
    }

    // 업데이트 결과 저장
    await _streakBox.put('currentStreak', newStreak);
    await _streakBox.put('maxStreak', newMax);
    await _streakBox.put('lastCompletedDate', newLastCompletedDate);
    await _streakBox.put('maxStreakLastDate', newMaxStreakLastDate);
  }

  /// 현재 스트릭 반환 (이미 저장된 값)
  int getCurrentStreak() {
    return _streakBox.get('currentStreak', defaultValue: 0) as int;
  }

  /// 최대 스트릭 반환 (이미 저장된 값)
  int getMaxStreak() {
    return _streakBox.get('maxStreak', defaultValue: 0) as int;
  }

  /// 날짜 키 변환
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 저장한 문자열 날짜를 DateTime으로 파싱
  DateTime _parseDate(String key) {
    final parts = key.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    return DateTime(year, month, day);
  }
}
