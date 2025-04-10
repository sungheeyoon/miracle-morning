import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/models/todos_by_date_model.dart';
import 'package:miracle_morning/features/home/repositories/todos_repository.dart';

part 'weekly_viewmodel.g.dart';

/// 주간 통계 데이터 모델
class WeeklyStatisticsData {
  final DateTime startDate;
  final DateTime endDate;
  final List<TodosByDateModel> dailyData;
  final int totalTodos;
  final int completedTodos;
  final double completionRate;
  final Map<int, double> completionRateByDay; // 요일별 완료율 (1: 월요일, 7: 일요일)
  final Map<DateTime, double> completionRateByDate; // 날짜별 완료율

  WeeklyStatisticsData({
    required this.startDate,
    required this.endDate,
    required this.dailyData,
    required this.totalTodos,
    required this.completedTodos,
    required this.completionRate,
    required this.completionRateByDay,
    required this.completionRateByDate,
  });

  // 가장 생산적인 요일 (1: 월요일, 7: 일요일)
  int? get mostProductiveWeekday {
    if (completionRateByDay.isEmpty) return null;
    return completionRateByDay.entries
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

/// 이번 주 데이터를 제공하는 Provider
@riverpod
Future<WeeklyStatisticsData> thisWeekStatistics(
    ThisWeekStatisticsRef ref) async {
  final todosRepo = await ref.watch(todosRepositoryProvider.future);

  // 이번 주의 시작일(월요일)과 종료일(일요일) 계산
  final today = DateTime.now();
  final weekday = today.weekday; // 1: 월요일, 7: 일요일

  // 이번 주 월요일 (주의 시작)
  final startDate = today.subtract(Duration(days: weekday - 1));
  final startDateOnly =
      DateTime(startDate.year, startDate.month, startDate.day);

  // 이번 주 일요일 (주의 끝)
  final endDate = startDateOnly.add(const Duration(days: 6));

  // 이번 주 데이터 가져오기
  final weekDataEither =
      await todosRepo.getTodosByDateRange(startDateOnly, endDate);

  return weekDataEither.fold(
    (failure) => throw Exception('주간 데이터 로드 실패: ${failure.message}'),
    (weekData) {
      // 요일별 통계 계산
      Map<int, List<TodoModel>> todosByWeekday = {};
      Map<int, int> totalByWeekday = {};
      Map<int, int> completedByWeekday = {};
      Map<DateTime, double> completionRateByDate = {};

      // 모든 요일 초기화 (1-7)
      for (int i = 1; i <= 7; i++) {
        todosByWeekday[i] = [];
        totalByWeekday[i] = 0;
        completedByWeekday[i] = 0;
      }

      // 전체 합계 계산 변수
      int totalTodos = 0;
      int completedTodos = 0;

      // 날짜별 데이터 처리
      for (final dayData in weekData) {
        final weekdayNum = dayData.date.weekday;
        final todos = dayData.todos;

        // 요일별 할일 추가
        todosByWeekday[weekdayNum]?.addAll(todos);

        // 요일별 카운트 업데이트
        totalByWeekday[weekdayNum] =
            (totalByWeekday[weekdayNum] ?? 0) + todos.length;
        completedByWeekday[weekdayNum] = (completedByWeekday[weekdayNum] ?? 0) +
            todos.where((todo) => todo.isCompleted).length;

        // 전체 합계 업데이트
        totalTodos += todos.length;
        completedTodos += todos.where((todo) => todo.isCompleted).length;

        // 날짜별 완료율 계산
        if (todos.isNotEmpty) {
          completionRateByDate[dayData.date] =
              todos.where((todo) => todo.isCompleted).length / todos.length;
        } else {
          completionRateByDate[dayData.date] = 0.0;
        }
      }

      // 요일별 완료율 계산
      Map<int, double> completionRateByDay = {};
      for (int weekdayNum = 1; weekdayNum <= 7; weekdayNum++) {
        final total = totalByWeekday[weekdayNum] ?? 0;
        if (total > 0) {
          completionRateByDay[weekdayNum] =
              (completedByWeekday[weekdayNum] ?? 0) / total;
        } else {
          completionRateByDay[weekdayNum] = 0.0;
        }
      }

      // 전체 완료율
      final completionRate = totalTodos > 0 ? completedTodos / totalTodos : 0.0;

      return WeeklyStatisticsData(
        startDate: startDateOnly,
        endDate: endDate,
        dailyData: weekData,
        totalTodos: totalTodos,
        completedTodos: completedTodos,
        completionRate: completionRate,
        completionRateByDay: completionRateByDay,
        completionRateByDate: completionRateByDate,
      );
    },
  );
}

/// 특정 주차 데이터를 제공하는 Provider
@riverpod
Future<WeeklyStatisticsData> weeklyStatistics(
  WeeklyStatisticsRef ref, {
  required DateTime baseDate,
}) async {
  final todosRepo = await ref.watch(todosRepositoryProvider.future);

  // 주어진 날짜가 속한 주의 월요일(시작일)과 일요일(종료일) 계산
  final weekday = baseDate.weekday; // 1: 월요일, 7: 일요일

  // 해당 주 월요일 (주의 시작)
  final startDate = baseDate.subtract(Duration(days: weekday - 1));
  final startDateOnly =
      DateTime(startDate.year, startDate.month, startDate.day);

  // 해당 주 일요일 (주의 끝)
  final endDate = startDateOnly.add(const Duration(days: 6));

  // 해당 주 데이터 가져오기
  final weekDataEither =
      await todosRepo.getTodosByDateRange(startDateOnly, endDate);

  return weekDataEither.fold(
    (failure) => throw Exception('주간 데이터 로드 실패: ${failure.message}'),
    (weekData) {
      // 요일별 통계 계산
      Map<int, List<TodoModel>> todosByWeekday = {};
      Map<int, int> totalByWeekday = {};
      Map<int, int> completedByWeekday = {};
      Map<DateTime, double> completionRateByDate = {};

      // 모든 요일 초기화 (1-7)
      for (int i = 1; i <= 7; i++) {
        todosByWeekday[i] = [];
        totalByWeekday[i] = 0;
        completedByWeekday[i] = 0;
      }

      // 전체 합계 계산 변수
      int totalTodos = 0;
      int completedTodos = 0;

      // 날짜별 데이터 처리
      for (final dayData in weekData) {
        final weekdayNum = dayData.date.weekday;
        final todos = dayData.todos;

        // 요일별 할일 추가
        todosByWeekday[weekdayNum]?.addAll(todos);

        // 요일별 카운트 업데이트
        totalByWeekday[weekdayNum] =
            (totalByWeekday[weekdayNum] ?? 0) + todos.length;
        completedByWeekday[weekdayNum] = (completedByWeekday[weekdayNum] ?? 0) +
            todos.where((todo) => todo.isCompleted).length;

        // 전체 합계 업데이트
        totalTodos += todos.length;
        completedTodos += todos.where((todo) => todo.isCompleted).length;

        // 날짜별 완료율 계산
        if (todos.isNotEmpty) {
          completionRateByDate[dayData.date] =
              todos.where((todo) => todo.isCompleted).length / todos.length;
        } else {
          completionRateByDate[dayData.date] = 0.0;
        }
      }

      // 요일별 완료율 계산
      Map<int, double> completionRateByDay = {};
      for (int weekdayNum = 1; weekdayNum <= 7; weekdayNum++) {
        final total = totalByWeekday[weekdayNum] ?? 0;
        if (total > 0) {
          completionRateByDay[weekdayNum] =
              (completedByWeekday[weekdayNum] ?? 0) / total;
        } else {
          completionRateByDay[weekdayNum] = 0.0;
        }
      }

      // 전체 완료율
      final completionRate = totalTodos > 0 ? completedTodos / totalTodos : 0.0;

      return WeeklyStatisticsData(
        startDate: startDateOnly,
        endDate: endDate,
        dailyData: weekData,
        totalTodos: totalTodos,
        completedTodos: completedTodos,
        completionRate: completionRate,
        completionRateByDay: completionRateByDay,
        completionRateByDate: completionRateByDate,
      );
    },
  );
}
