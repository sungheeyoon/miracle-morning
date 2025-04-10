import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:miracle_morning/features/statistics/viewmodel/growth_viewmodel.dart';
import 'package:miracle_morning/features/statistics/viewmodel/weekly_viewmodel.dart';
import 'package:miracle_morning/features/statistics/viewmodel/monthly_viewmodel.dart';

part 'dashboard_viewmodel.g.dart';

/// 대시보드에 필요한 통합 통계 데이터 모델
class DashboardStatisticsData {
  final int currentLevel;
  final double currentExp;
  final double requiredExp;
  final double progressPercentage;
  final int remainingExp;
  final int currentStreak;
  final int maxStreak;
  final int streakBonus;
  final double weeklyCompletionRate;
  final Map<int, double> weeklyCompletionRateByDay; // 요일별 완료율 (1: 월요일, 7: 일요일)
  final double monthlyCompletionRate;
  final Map<DateTime, int> activityIntensity;
  final Set<DateTime> activeDays;
  final int totalTodosThisWeek;
  final int completedTodosThisWeek;
  final int totalTodosThisMonth;
  final int completedTodosThisMonth;

  DashboardStatisticsData({
    required this.currentLevel,
    required this.currentExp,
    required this.requiredExp,
    required this.progressPercentage,
    required this.remainingExp,
    required this.currentStreak,
    required this.maxStreak,
    required this.streakBonus,
    required this.weeklyCompletionRate,
    required this.weeklyCompletionRateByDay,
    required this.monthlyCompletionRate,
    required this.activityIntensity,
    required this.activeDays,
    required this.totalTodosThisWeek,
    required this.completedTodosThisWeek,
    required this.totalTodosThisMonth,
    required this.completedTodosThisMonth,
  });

  // 가장 생산적인 요일 (1: 월요일, 7: 일요일)
  int? get mostProductiveWeekday {
    if (weeklyCompletionRateByDay.isEmpty) return null;
    return weeklyCompletionRateByDay.entries
        .reduce((max, entry) => entry.value > max.value ? entry : max)
        .key;
  }

  // 주간 완료율 대비 월간 완료율 차이 (양수: 이번 주가 더 나음, 음수: 이번 달이 더 나음)
  double get weeklyVsMonthlyDifference {
    return weeklyCompletionRate - monthlyCompletionRate;
  }

  // 스트릭 보너스 포함 예상 레벨업까지 남은 일수
  int get estimatedDaysToNextLevel {
    if (streakBonus <= 0) {
      return remainingExp;
    }
    return (remainingExp / (1 + streakBonus)).ceil();
  }
}

/// 대시보드 통계 데이터를 제공하는 Provider
@riverpod
Future<DashboardStatisticsData> dashboardStatistics(
    DashboardStatisticsRef ref) async {
  // 현재 날짜 정보
  final now = DateTime.now();
  final currentYear = now.year;
  final currentMonth = now.month;

  // 필요한 ViewModel 데이터 로드
  final growthState = ref.watch(growthViewModelProvider);
  final streakDataAsync = await ref.watch(streakDataProvider.future);
  final thisWeekDataAsync = await ref.watch(thisWeekStatisticsProvider.future);
  final thisMonthDataAsync = await ref.watch(
    monthlyStatisticsProvider(
      year: currentYear,
      month: currentMonth,
    ).future,
  );

  // 대시보드 데이터 생성
  return DashboardStatisticsData(
    // 성장 정보
    currentLevel: growthState.currentLevel,
    currentExp: growthState.currentExp,
    requiredExp: growthState.requiredExp,
    progressPercentage: growthState.progressPercentage,
    remainingExp: growthState.remainingExp,

    // 스트릭 정보
    currentStreak: streakDataAsync.currentStreak,
    maxStreak: await ref.read(growthViewModelProvider.notifier).getMaxStreak(),
    streakBonus: streakDataAsync.streakBonus,

    // 주간 정보
    weeklyCompletionRate: thisWeekDataAsync.completionRate,
    weeklyCompletionRateByDay: thisWeekDataAsync.completionRateByDay,
    totalTodosThisWeek: thisWeekDataAsync.totalTodos,
    completedTodosThisWeek: thisWeekDataAsync.completedTodos,

    // 월간 정보
    monthlyCompletionRate: thisMonthDataAsync.monthlyCompletionRate,
    activityIntensity: thisMonthDataAsync.dailyActivityIntensity,
    activeDays: thisMonthDataAsync.activeDays,
    totalTodosThisMonth: thisMonthDataAsync.totalTodos,
    completedTodosThisMonth: thisMonthDataAsync.completedTodos,
  );
}

/// 특정 기간의 요약 통계 데이터
class SummaryStatistics {
  final int totalTodos;
  final int completedTodos;
  final double completionRate;

  SummaryStatistics({
    required this.totalTodos,
    required this.completedTodos,
    required this.completionRate,
  });
}

/// 이번 주 요약 통계
@riverpod
Future<SummaryStatistics> thisWeekSummary(ThisWeekSummaryRef ref) async {
  final weekData = await ref.watch(thisWeekStatisticsProvider.future);

  return SummaryStatistics(
    totalTodos: weekData.totalTodos,
    completedTodos: weekData.completedTodos,
    completionRate: weekData.completionRate,
  );
}

/// 이번 달 요약 통계
@riverpod
Future<SummaryStatistics> thisMonthSummary(ThisMonthSummaryRef ref) async {
  final now = DateTime.now();
  final monthData = await ref.watch(
    monthlyStatisticsProvider(
      year: now.year,
      month: now.month,
    ).future,
  );

  return SummaryStatistics(
    totalTodos: monthData.totalTodos,
    completedTodos: monthData.completedTodos,
    completionRate: monthData.monthlyCompletionRate,
  );
}
