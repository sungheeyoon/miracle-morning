import 'package:miracle_morning/features/statistics/model/streak_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miracle_morning/core/providers/box_providers.dart';
import 'package:miracle_morning/features/home/repositories/completion_repository.dart';
import 'package:miracle_morning/core/utils.dart';

part 'streak_repository.g.dart';

@riverpod
Future<StreakRepository> streakRepository(StreakRepositoryRef ref) async {
  final streakBoxInstance = await ref.watch(streakBoxProvider.future);
  final completionRepo = await ref.watch(completionRepositoryProvider.future);
  return StreakRepository(streakBoxInstance, completionRepo);
}

class StreakRepository {
  final Box<StreakModel> _streakBox;
  final CompletionRepository _completionRepo;
  static const String _streakModelKey = 'streak_model';

  StreakRepository(this._streakBox, this._completionRepo);

  StreakModel _getStreakModel() {
    return _streakBox.get(_streakModelKey) ?? StreakModel();
  }

  Future<void> _saveStreakModel(StreakModel model) async {
    await _streakBox.put(_streakModelKey, model);
  }

  // 스트릭 정보 업데이트
  Future<void> updateStreakInfo() async {
    final today = DateTime.now();
    final todayKey = getDateKey(today);
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayKey = getDateKey(yesterday);

    final streakModel = _getStreakModel();

    // 오늘 이미 체크했으면 추가 계산 필요 없음
    if (streakModel.lastCheckedDate == todayKey) {
      return;
    }

    // 현재 저장된 스트릭 값들
    final currentStreak = streakModel.currentStreak;
    final maxStreak = streakModel.maxStreak;
    final lastCompletedDateStr = streakModel.lastCompletedDate;

    // 새 스트릭 값 계산
    int newStreak = 0;
    String newLastCompletedDateStr = '';

    // 어제 완료 여부 확인
    final isYesterdayCompleted =
        await _completionRepo.isDayCompleted(yesterday);

    // 오늘 완료 여부 확인
    final isTodayCompleted = await _completionRepo.isDayCompleted(today);

    if (lastCompletedDateStr.isEmpty) {
      // 첫 실행 또는 이전 완료 기록 없음
      if (isTodayCompleted) {
        newStreak = 1;
        newLastCompletedDateStr = todayKey;
      } else if (isYesterdayCompleted) {
        newStreak = 1;
        newLastCompletedDateStr = yesterdayKey;
      }
    } else {
      // 마지막 완료일이 어제인 경우 스트릭 유지/증가
      if (lastCompletedDateStr == yesterdayKey) {
        if (isTodayCompleted) {
          // 어제 완료 + 오늘 완료 = 스트릭 증가
          newStreak = currentStreak + 1;
          newLastCompletedDateStr = todayKey;
        } else {
          // 어제 완료 + 오늘 미완료 = 스트릭 유지
          newStreak = currentStreak;
          newLastCompletedDateStr = yesterdayKey;
        }
      }
      // 마지막 완료일이 오늘인 경우 스트릭 유지
      else if (lastCompletedDateStr == todayKey) {
        newStreak = currentStreak;
        newLastCompletedDateStr = todayKey;
      }
      // 마지막 완료일이 어제도 오늘도 아닌 경우 (= 스트릭 끊김)
      else {
        if (isTodayCompleted) {
          // 오늘부터 새로운 스트릭 시작
          newStreak = 1;
          newLastCompletedDateStr = todayKey;
        } else if (isYesterdayCompleted) {
          // 어제부터 새로운 스트릭 시작
          newStreak = 1;
          newLastCompletedDateStr = yesterdayKey;
        } else {
          // 스트릭 없음
          newStreak = 0;
          newLastCompletedDateStr = '';
        }
      }
    }

    // 최대 스트릭 업데이트
    int newMaxStreak = maxStreak;
    if (newStreak > newMaxStreak) {
      newMaxStreak = newStreak;
    }

    // 결과 저장
    final updatedModel = streakModel.copyWith(
      currentStreak: newStreak,
      maxStreak: newMaxStreak,
      lastCompletedDate: newLastCompletedDateStr,
      lastCheckedDate: todayKey,
    );

    await _saveStreakModel(updatedModel);
  }

  // 모든 스트릭 데이터 처음부터 다시 계산
  Future<void> recalculateAllStreaks() async {
    final today = DateTime.now();
    final todayKey = getDateKey(today);

    // 완료된 모든 날짜를 가져오기
    final completedDates = await _completionRepo.getAllCompletedDates();

    if (completedDates.isEmpty) {
      // 완료된 날짜가 없으면 모든 값 초기화
      final resetModel = StreakModel(
        currentStreak: 0,
        maxStreak: 0,
        lastCompletedDate: '',
        lastCheckedDate: todayKey,
      );

      await _saveStreakModel(resetModel);
      return;
    }

    // 날짜순으로 정렬
    completedDates.sort();

    int maxStreakCount = 0;
    int currentStreakCount = 0;
    DateTime? lastDate;

    for (var date in completedDates) {
      if (lastDate == null) {
        // 첫 번째 완료일
        currentStreakCount = 1;
      } else {
        // 이전 날짜와 현재 날짜의 차이가 1일이면 연속
        if (date.difference(lastDate).inDays == 1) {
          currentStreakCount++;
        } else {
          // 연속이 아니면 새로 시작
          currentStreakCount = 1;
        }
      }

      // 최대 스트릭 업데이트
      if (currentStreakCount > maxStreakCount) {
        maxStreakCount = currentStreakCount;
      }

      lastDate = date;
    }

    // 마지막 완료일이 어제가 아니면 현재 스트릭은 0
    final yesterday = today.subtract(const Duration(days: 1));
    if (lastDate == null ||
        !isSameDay(lastDate, yesterday) && !isSameDay(lastDate, today)) {
      // 어제나 오늘이 완료되지 않았으면 현재 스트릭 초기화
      currentStreakCount = 0;
    }

    // 결과 저장
    final lastCompletedDateStr = lastDate != null ? getDateKey(lastDate) : '';

    final updatedModel = StreakModel(
      currentStreak: currentStreakCount,
      maxStreak: maxStreakCount,
      lastCompletedDate: lastCompletedDateStr,
      lastCheckedDate: todayKey,
    );

    await _saveStreakModel(updatedModel);
  }

  // 특정 날짜의 완료 상태가 변경되었을 때 호출
  Future<void> onCompletionStatusChanged(DateTime date) async {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));

    // 현재 또는 어제의 완료 상태가 변경된 경우 일반 업데이트
    if (isSameDay(date, today) || isSameDay(date, yesterday)) {
      await updateStreakInfo();
    }
    // 그 외 과거 날짜의 변경은 무시 (과거 데이터는 수정 불가)
    // 하지만 개발 중에는 호출할 수 있도록 메서드 노출
  }

  // 개발용: 강제로 전체 재계산 수행
  Future<void> forceRecalculateAllStreaks() async {
    await recalculateAllStreaks();
  }

  // 같은 날짜인지 확인하는 헬퍼 메서드 (시간 무시)
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// 현재 스트릭 반환 (최신 상태 반영)
  Future<int> getCurrentStreak() async {
    await updateStreakInfo(); // 호출 시 최신 정보로 업데이트
    return _getStreakModel().currentStreak;
  }

  /// 최대 스트릭 반환
  Future<int> getMaxStreak() async {
    return _getStreakModel().maxStreak;
  }

  /// 마지막 완료일 반환
  Future<DateTime?> getLastCompletedDate() async {
    final lastDateStr = _getStreakModel().lastCompletedDate;
    if (lastDateStr.isEmpty) {
      return null;
    }
    return _parseDate(lastDateStr);
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
