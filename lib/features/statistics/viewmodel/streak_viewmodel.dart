import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:miracle_morning/features/statistics/repositories/streak_repository.dart';

part 'streak_viewmodel.g.dart';

/// StreakViewModel:
/// - build()에서 StreakRepository를 호출해 currentStreak와 maxStreak를 가져온 뒤 상태에 반영
@riverpod
class StreakViewModel extends _$StreakViewModel {
  @override
  Future<Map<String, int>> build() async {
    final streakRepo = await ref.watch(streakRepositoryProvider.future);
    final current = streakRepo.getCurrentStreak();
    final max = streakRepo.getMaxStreak();

    return {
      "currentStreak": current,
      "maxStreak": max,
    };
  }
}
