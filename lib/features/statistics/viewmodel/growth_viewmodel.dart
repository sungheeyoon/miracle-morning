import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:miracle_morning/features/statistics/repositories/growth_repository.dart';

part 'growth_viewmodel.g.dart';

/// 사용자 성장 정보 상태를 나타내는 데이터 클래스
class GrowthState {
  final int currentLevel;
  final double currentExp;
  final double requiredExp;
  final double progressPercentage;
  final int remainingExp;
  final bool isLoading;
  final bool hasError;

  const GrowthState({
    this.currentLevel = 1,
    this.currentExp = 0.0,
    this.requiredExp = 1.0,
    this.progressPercentage = 0.0,
    this.remainingExp = 0,
    this.isLoading = false,
    this.hasError = false,
  });

  // 복사 생성자
  GrowthState copyWith({
    int? currentLevel,
    double? currentExp,
    double? requiredExp,
    double? progressPercentage,
    int? remainingExp,
    bool? isLoading,
    bool? hasError,
  }) {
    return GrowthState(
      currentLevel: currentLevel ?? this.currentLevel,
      currentExp: currentExp ?? this.currentExp,
      requiredExp: requiredExp ?? this.requiredExp,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      remainingExp: remainingExp ?? this.remainingExp,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}

/// 스트릭 정보를 담는 데이터 클래스
class StreakData {
  final int currentStreak;
  final int streakBonus;
  final int estimatedDaysToNextLevel;

  const StreakData({
    this.currentStreak = 0,
    this.streakBonus = 0,
    this.estimatedDaysToNextLevel = 0,
  });
}

/// 성장 정보를 관리하는 ViewModel
@riverpod
class GrowthViewModel extends _$GrowthViewModel {
  GrowthRepository? _repository;

  @override
  GrowthState build() {
    final asyncGrowthRepo = ref.watch(growthRepositoryProvider);

    return asyncGrowthRepo.when(
      data: (repo) {
        _repository = repo;
        return _loadGrowthState(repo);
      },
      loading: () => const GrowthState(isLoading: true),
      error: (_, __) => const GrowthState(hasError: true),
    );
  }

  /// Repository로부터 성장 정보를 로드하여 상태 생성
  GrowthState _loadGrowthState(GrowthRepository repo) {
    final level = repo.getGrowthLevel()?.level ?? 1;
    final currentExp = repo.getGrowthLevel()?.currentExp ?? 0.0;
    final requiredExp = repo.getRequiredExp(level);
    final progress = repo.getProgress();
    final daysRemaining = repo.getDaysRemainingForNextLevel();

    return GrowthState(
      currentLevel: level,
      currentExp: currentExp,
      requiredExp: requiredExp,
      progressPercentage: progress,
      remainingExp: daysRemaining,
    );
  }

  /// 특정 날짜의 성장 정보 업데이트
  Future<void> updateGrowth(DateTime date) async {
    if (_repository == null) return;

    state = state.copyWith(isLoading: true);

    try {
      await _repository!.updateGrowth(date);
      state = _loadGrowthState(_repository!);
    } catch (e) {
      state = state.copyWith(hasError: true, isLoading: false);
    }
  }

  /// 스트릭 관련 데이터 로드
  Future<StreakData> loadStreakData() async {
    if (_repository == null) {
      return const StreakData();
    }

    final currentStreak = await _repository!.getCurrentStreak();
    final streakBonus = await _repository!.getCurrentStreakBonus();
    final estimatedDays = await _repository!.getEstimatedDaysToNextLevel();

    return StreakData(
      currentStreak: currentStreak,
      streakBonus: streakBonus,
      estimatedDaysToNextLevel: estimatedDays,
    );
  }

  /// 간편 메서드: 현재 스트릭 조회
  Future<int> getCurrentStreak() async {
    if (_repository == null) return 0;
    return _repository!.getCurrentStreak();
  }

  /// 간편 메서드: 맥스 스트릭 조회
  Future<int> getMaxStreak() async {
    if (_repository == null) return 0;
    return _repository!.getMaxStreak();
  }

  /// 간편 메서드: 현재 스트릭 보너스 조회
  Future<int> getStreakBonus() async {
    if (_repository == null) return 0;
    return _repository!.getCurrentStreakBonus();
  }
}

/// 스트릭 데이터 Provider (비동기)
@riverpod
Future<StreakData> streakData(StreakDataRef ref) async {
  final growthVM = ref.watch(growthViewModelProvider.notifier);
  return await growthVM.loadStreakData();
}
