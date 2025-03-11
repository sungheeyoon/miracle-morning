import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/models/todos_by_month_model.dart';
import 'package:miracle_morning/features/home/repositories/todos_repository.dart';
import 'package:miracle_morning/features/home/models/todos_by_date_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<TodosByDateModel> getTodos(GetTodosRef ref, DateTime date) async {
  final todosRepository = await ref.watch(todosRepositoryProvider.future);
  final result = await todosRepository.getTodos(date);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (todosByDate) => todosByDate,
  );
}

@riverpod
Future<TodosByMonthModel> getMonthTodos(
    GetMonthTodosRef ref, int year, int month) async {
  final todosRepository = await ref.watch(todosRepositoryProvider.future);
  final result = await todosRepository.getMonthTodos(year, month);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (todosByMonth) => todosByMonth,
  );
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<TodosByDateModel> build() async {
    // 초기 상태 설정: 빈 투두 리스트 반환
    return TodosByDateModel(date: DateTime.now(), todos: []);
  }

  /// 투두 생성
  Future<void> createTodo(DateTime date, TodoModel todo) async {
    try {
      final todosRepository = await ref.watch(todosRepositoryProvider.future);
      final result = await todosRepository.createTodo(date, todo);
      result.fold(
        (failure) =>
            state = AsyncValue.error(failure.message, StackTrace.current),
        (_) {
          // 날짜별 투두 갱신
          ref.invalidate(getTodosProvider(date));
          // 해당 월 투두 갱신
          ref.invalidate(getMonthTodosProvider(date.year, date.month));
        },
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 투두 수정
  Future<void> updateTodo(DateTime date, TodoModel todo) async {
    try {
      final todosRepository = await ref.watch(todosRepositoryProvider.future);
      final result = await todosRepository.updateTodo(date, todo);
      result.fold(
        (failure) =>
            state = AsyncValue.error(failure.message, StackTrace.current),
        (_) {
          // 날짜별 투두 갱신
          ref.invalidate(getTodosProvider(date));
          // 해당 월 투두 갱신
          ref.invalidate(getMonthTodosProvider(date.year, date.month));
        },
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// 투두 삭제
  Future<void> deleteTodo(DateTime date, String todoId) async {
    try {
      final todosRepository = await ref.watch(todosRepositoryProvider.future);
      final result = await todosRepository.deleteTodo(date, todoId);
      result.fold(
        (failure) =>
            state = AsyncValue.error(failure.message, StackTrace.current),
        (_) {
          // 날짜별 투두 갱신
          ref.invalidate(getTodosProvider(date));
          // 해당 월 투두 갱신
          ref.invalidate(getMonthTodosProvider(date.year, date.month));
        },
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  bool isEditable(DateTime date) {
    // ViewModel에서 Repository 호출
    final repo = ref.read(todosRepositoryProvider).valueOrNull;
    if (repo == null) return false; // Repository 아직 로딩중이면 false
    return repo.isDateEditable(date);
  }
}
