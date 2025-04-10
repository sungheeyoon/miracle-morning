import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:miracle_morning/features/home/models/todos_by_date_model.dart';
import 'package:miracle_morning/features/home/repositories/todos_repository.dart';

part 'monthly_viewmodel.g.dart';

/// 월간 통계 데이터 모델
class MonthlyStatisticsData {
  final int year;
  final int month;
  final Map<DateTime, double> dailyCompletionRates;
  final Map<DateTime, int> dailyActivityIntensity;
  final Set<DateTime> activeDays;
  final double monthlyCompletionRate;
  final int totalTodos;
  final int completedTodos;
  final List<TodosByDateModel> dailyTodosData;
  final Map<int, double> completionRateByWeekday; // 요일별 완료율 (1: 월요일, 7: 일요일)

  MonthlyStatisticsData({
    required this.year,
    required this.month,
    required this.dailyCompletionRates,
    required this.dailyActivityIntensity,
    required this.activeDays,
    required this.monthlyCompletionRate,
    this.totalTodos = 0,
    this.completedTodos = 0,
    required this.dailyTodosData,
    required this.completionRateByWeekday,
  });

  // 완료된 항목의 비율 (0.0-1.0)
  double get completionPercentage =>
      totalTodos > 0 ? completedTodos / totalTodos : 0.0;

  // 가장 활동적인 날짜
  DateTime? get mostActiveDay {
    if (dailyActivityIntensity.isEmpty) return null;
    return dailyActivityIntensity.entries
        .reduce((max, entry) => entry.value > max.value ? entry : max)
        .key;
  }

  // 평균 할일 개수
  double get averageDailyTodos {
    if (activeDays.isEmpty) return 0.0;
    return totalTodos / activeDays.length;
  }

  // 가장 생산적인 요일 (1: 월요일, 7: 일요일)
  int? get mostProductiveWeekday {
    if (completionRateByWeekday.isEmpty) return null;
    return completionRateByWeekday.entries
        .reduce((max, entry) => entry.value > max.value ? entry : max)
        .key;
  }

  // 요일 이름 가져오기
  String getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return '월요일';
      case 2:
        return '화요일';
      case 3:
        return '수요일';
      case 4:
        return '목요일';
      case 5:
        return '금요일';
      case 6:
        return '토요일';
      case 7:
        return '일요일';
      default:
        return '';
    }
  }
}

/// 월간 통계 데이터를 제공하는 Provider
@riverpod
Future<MonthlyStatisticsData> monthlyStatistics(
  MonthlyStatisticsRef ref, {
  required int year,
  required int month,
}) async {
  final todosRepo = await ref.watch(todosRepositoryProvider.future);
  final monthDataEither = await todosRepo.getMonthTodos(year, month);

  return monthDataEither.fold(
    (failure) => throw Exception('월간 데이터 로드 실패: ${failure.message}'),
    (todosByMonth) {
      // 일별 TodosByDateModel 목록
      final List<TodosByDateModel> dailyTodosData = todosByMonth.todosByDates;

      // 전체 투두 및 완료된 투두 카운트
      int totalTodos = 0;
      int completedTodos = 0;

      // 요일별 통계 계산을 위한 변수
      Map<int, int> totalByWeekday = {};
      Map<int, int> completedByWeekday = {};

      // 모든 요일 초기화 (1-7)
      for (int i = 1; i <= 7; i++) {
        totalByWeekday[i] = 0;
        completedByWeekday[i] = 0;
      }

      for (final dayData in dailyTodosData) {
        // 총 투두 및 완료된 투두 카운트
        totalTodos += dayData.todos.length;
        completedTodos +=
            dayData.todos.where((todo) => todo.isCompleted).length;

        // 요일별 통계 업데이트
        final weekdayNum = dayData.date.weekday;
        totalByWeekday[weekdayNum] =
            (totalByWeekday[weekdayNum] ?? 0) + dayData.todos.length;
        completedByWeekday[weekdayNum] = (completedByWeekday[weekdayNum] ?? 0) +
            dayData.todos.where((todo) => todo.isCompleted).length;
      }

      // 요일별 완료율 계산
      Map<int, double> completionRateByWeekday = {};
      for (int weekdayNum = 1; weekdayNum <= 7; weekdayNum++) {
        final total = totalByWeekday[weekdayNum] ?? 0;
        if (total > 0) {
          completionRateByWeekday[weekdayNum] =
              (completedByWeekday[weekdayNum] ?? 0) / total;
        } else {
          completionRateByWeekday[weekdayNum] = 0.0;
        }
      }

      final monthlyData = MonthlyStatisticsData(
        year: year,
        month: month,
        // 일별 완료율
        dailyCompletionRates: _calculateDailyCompletionRates(dailyTodosData),
        // 일별 활동 강도 (0-3)
        dailyActivityIntensity:
            _calculateDailyActivityIntensity(dailyTodosData),
        // 할 일이 있는 날짜
        activeDays: _getActiveDays(dailyTodosData),
        // 월간 전체 완료율
        monthlyCompletionRate: _calculateMonthlyCompletionRate(dailyTodosData),
        // 전체 투두 개수
        totalTodos: totalTodos,
        // 완료된 투두 개수
        completedTodos: completedTodos,
        // 일별 투두 데이터
        dailyTodosData: dailyTodosData,
        // 요일별 완료율
        completionRateByWeekday: completionRateByWeekday,
      );

      return monthlyData;
    },
  );
}

/// 월간 특정 날짜 통계 데이터 제공 Provider
@riverpod
Future<TodosByDateModel?> dailyStatistics(
  DailyStatisticsRef ref, {
  required DateTime date,
}) async {
  final monthlyData = await ref.watch(
    monthlyStatisticsProvider(year: date.year, month: date.month).future,
  );

  // 해당 날짜의 데이터 찾기
  for (final dayData in monthlyData.dailyTodosData) {
    if (_isSameDate(dayData.date, date)) {
      return dayData;
    }
  }

  return null;
}

// 일별 완료율 계산 함수
Map<DateTime, double> _calculateDailyCompletionRates(
    List<TodosByDateModel> dailyData) {
  final Map<DateTime, double> rates = {};

  for (final dayData in dailyData) {
    if (dayData.todos.isEmpty) {
      rates[dayData.date] = 0.0;
    } else {
      final completedCount =
          dayData.todos.where((todo) => todo.isCompleted).length;
      rates[dayData.date] = completedCount / dayData.todos.length;
    }
  }

  return rates;
}

// 일별 활동 강도 계산 함수 (할일 개수에 따라 0-3 강도 부여)
Map<DateTime, int> _calculateDailyActivityIntensity(
    List<TodosByDateModel> dailyData) {
  final Map<DateTime, int> intensity = {};

  for (final dayData in dailyData) {
    final count = dayData.todos.length;
    if (count == 0) {
      intensity[dayData.date] = 0;
    } else if (count <= 2) {
      intensity[dayData.date] = 1;
    } else if (count <= 5) {
      intensity[dayData.date] = 2;
    } else {
      intensity[dayData.date] = 3;
    }
  }

  return intensity;
}

// 활동한 날짜 계산 함수 (할일이 하나라도 있는 날)
Set<DateTime> _getActiveDays(List<TodosByDateModel> dailyData) {
  return dailyData
      .where((dayData) => dayData.todos.isNotEmpty)
      .map((dayData) => dayData.date)
      .toSet();
}

// 월간 완료율 계산 함수
double _calculateMonthlyCompletionRate(List<TodosByDateModel> dailyData) {
  int totalTodos = 0;
  int completedTodos = 0;

  for (final dayData in dailyData) {
    totalTodos += dayData.todos.length;
    completedTodos += dayData.todos.where((todo) => todo.isCompleted).length;
  }

  if (totalTodos == 0) return 0.0;
  return completedTodos / totalTodos;
}

// 날짜 비교 helper 함수
bool _isSameDate(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
