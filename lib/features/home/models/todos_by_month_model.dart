import 'package:miracle_morning/features/home/models/todos_by_date_model.dart';

class TodosByMonthModel {
  final int year;
  final int month;
  final List<TodosByDateModel> todosByDates;

  TodosByMonthModel({
    required this.year,
    required this.month,
    List<TodosByDateModel>? todosByDates,
  }) : todosByDates = todosByDates ?? [];

  TodosByMonthModel copyWith({
    int? year,
    int? month,
    List<TodosByDateModel>? todosByDates,
  }) {
    return TodosByMonthModel(
      year: year ?? this.year,
      month: month ?? this.month,
      todosByDates: todosByDates ?? this.todosByDates,
    );
  }

  /// 한 달 동안의 모든 TODO 개수
  int get totalTodosCount =>
      todosByDates.fold(0, (sum, e) => sum + e.todos.length);

  /// 한 달 동안 완료된 TODO 개수
  int get completedTodosCount => todosByDates.fold(
      0, (sum, e) => sum + e.todos.where((t) => t.isCompleted).length);

  /// 완료율 (0.0 ~ 1.0)
  double get completionRate {
    final total = totalTodosCount;
    if (total == 0) return 0.0;
    return completedTodosCount / total;
  }

  /// 특정 날짜에 해당하는 TodosByDateModel 반환
  /// 해당 날짜 데이터가 없다면 null 반환
  TodosByDateModel getTodosByDate(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    return todosByDates.firstWhere(
      (element) => _isSameDate(element.date, targetDate),
      orElse: () => TodosByDateModel(date: targetDate, todos: []),
    );
  }

  /// 주어진 날짜가 이 모델의 연월과 같은지 확인
  bool isSameMonth(DateTime date) {
    return date.year == year && date.month == month;
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
