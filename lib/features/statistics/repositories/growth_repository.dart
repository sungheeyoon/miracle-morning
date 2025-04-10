import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miracle_morning/core/providers/box_providers.dart';
import 'package:miracle_morning/features/statistics/model/growth_level.dart';
import 'package:miracle_morning/features/home/repositories/completion_repository.dart';
import 'package:miracle_morning/features/statistics/repositories/streak_repository.dart';

part 'growth_repository.g.dart';

@riverpod
Future<GrowthRepository> growthRepository(GrowthRepositoryRef ref) async {
  final growthBoxInstance = await ref.watch(growthBoxProvider.future);
  final completionRepo = await ref.watch(completionRepositoryProvider.future);
  final streakRepo = await ref.watch(streakRepositoryProvider.future);
  return GrowthRepository(growthBoxInstance, completionRepo, streakRepo);
}

class GrowthRepository {
  final Box<GrowthLevel> _growthBox;
  final CompletionRepository _completionRepo;
  final StreakRepository _streakRepo;
  static const String _key = 'growth_level';

  GrowthRepository(this._growthBox, this._completionRepo, this._streakRepo);

  // 레벨업에 필요한 완료 일수 계산
  int _getRequiredDays(int level) {
    return level * (level + 1) ~/ 2; // 예: 1->2 (1일), 2->3 (2일 추가), 3->4 (3일 추가)
  }

  // 연속 완료 보너스 계산
  int _calculateBonusDays(int streak) {
    if (streak >= 30) return 5;
    if (streak >= 10) return 2;
    if (streak >= 4) return 1;
    return 0;
  }

  Future<void> updateGrowth(DateTime yesterday) async {
    final yesterdayCompleted = await _completionRepo.isDayCompleted(yesterday);
    final growth = _growthBox.get(_key) ?? GrowthLevel();

    if (yesterdayCompleted) {
      int totalDays = 1; // 기본 경험치 (1일 완료)

      // 현재 스트릭 (Future로 변경됨)
      final currentStreak = await _streakRepo.getCurrentStreak();

      // 스트릭 보너스 적용
      totalDays += _calculateBonusDays(currentStreak);

      int newDays = growth.currentExp.toInt() + totalDays;
      int newLevel = growth.level;

      while (newDays >= _getRequiredDays(newLevel) && newLevel < 5) {
        newDays -= _getRequiredDays(newLevel);
        newLevel++;
      }

      if (newLevel >= 5) {
        newLevel = 5;
        newDays = _getRequiredDays(5);
      }

      await _growthBox.put(
        _key,
        GrowthLevel(
          level: newLevel,
          currentExp: newDays.toDouble(),
          lastCheckIn: yesterday,
        ),
      );

      // updateStreak 메소드는 새 구현에서 제거됨
      // 대신 스트릭은 자동으로 업데이트됨
    }
  }

  GrowthLevel? getGrowthLevel() {
    return _growthBox.get(_key);
  }

  double getRequiredExp(int level) {
    return _getRequiredDays(level).toDouble();
  }

  double getProgress() {
    final growth = getGrowthLevel();
    if (growth == null) return 0.0;

    return growth.currentExp / _getRequiredDays(growth.level);
  }

  int getDaysRemainingForNextLevel() {
    final growth = getGrowthLevel();
    if (growth == null) return _getRequiredDays(1);

    return _getRequiredDays(growth.level) - growth.currentExp.toInt();
  }

  // 현재 스트릭 가져오기 (Future로 변경)
  Future<int> getCurrentStreak() async {
    return await _streakRepo.getCurrentStreak();
  }

  Future<int> getMaxStreak() async {
    return await _streakRepo.getMaxStreak();
  }

  // 현재 스트릭으로 인한 보너스 일수 계산 (Future로 변경)
  Future<int> getCurrentStreakBonus() async {
    final currentStreak = await _streakRepo.getCurrentStreak();
    return _calculateBonusDays(currentStreak);
  }

  // 다음 레벨까지 예상 소요일 계산 (보너스 포함) (Future로 변경)
  Future<int> getEstimatedDaysToNextLevel() async {
    final daysRemaining = getDaysRemainingForNextLevel();
    final currentStreak = await _streakRepo.getCurrentStreak();
    final dailyBonus = _calculateBonusDays(currentStreak);

    if (dailyBonus <= 0) {
      return daysRemaining;
    }

    // 매일 획득하는 경험치 (기본 1 + 보너스)
    final dailyExp = 1 + dailyBonus;
    return (daysRemaining / dailyExp).ceil();
  }
}
