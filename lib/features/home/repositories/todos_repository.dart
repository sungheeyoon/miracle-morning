import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miracle_morning/core/failure/failure.dart';
import 'package:miracle_morning/core/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/models/todos_by_date_model.dart';
import 'package:miracle_morning/features/home/models/todos_by_month_model.dart';
import 'package:miracle_morning/core/providers/box_providers.dart';
import 'package:miracle_morning/features/home/repositories/completion_repository.dart';

part 'todos_repository.g.dart';

@riverpod
Future<TodosRepository> todosRepository(TodosRepositoryRef ref) async {
  final todoBoxInstance = await ref.watch(todoBoxProvider.future);
  final completionRepo = await ref.watch(completionRepositoryProvider.future);
  return TodosRepository(todoBoxInstance, completionRepo);
}

class TodosRepository {
  final Box<TodosByDateModel> _todoBox;
  final CompletionRepository _completionRepo;

  TodosRepository(this._todoBox, this._completionRepo);

  //과거가 아니라면 수정허용
  bool isDateEditable(DateTime date) {
    return !isPastDate(date);
  }

  //date에해당하는 TodosByDateModel 반환 없다면 _createEmptyTodosByDate로 empty모델 반환
  Future<Either<AppFailure, TodosByDateModel>> getTodos(DateTime date) async {
    try {
      final key = getDateKey(date);
      final todosByDate = _todoBox.get(key) ?? _createEmptyTodosByDate(date);
      return Right(todosByDate);
    } catch (e) {
      return Left(AppFailure('Failed to load Todos by Date: ${e.toString()}'));
    }
  }

  // 특정 기간의 모든 TodosByDateModel 가져오기
  Future<Either<AppFailure, List<TodosByDateModel>>> getTodosByDateRange(
      DateTime startDate, DateTime endDate) async {
    try {
      List<TodosByDateModel> result = [];

      for (var date = startDate;
          !date.isAfter(endDate);
          date = date.add(const Duration(days: 1))) {
        final key = getDateKey(date);
        final todosByDate = _todoBox.get(key) ?? _createEmptyTodosByDate(date);
        result.add(todosByDate);
      }

      return Right(result);
    } catch (e) {
      return Left(
          AppFailure('Failed to load Todos by date range: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, TodosByMonthModel>> getMonthTodos(
      int year, int month) async {
    try {
      final lastDayOfMonth = DateTime(year, month + 1, 0);

      final List<TodosByDateModel> monthTodos = [];

      for (int day = 1; day <= lastDayOfMonth.day; day++) {
        final date = DateTime(year, month, day);
        final key = getDateKey(date);
        final todosByDate = _todoBox.get(key) ?? _createEmptyTodosByDate(date);
        monthTodos.add(todosByDate);
      }

      final todosByMonthModel = TodosByMonthModel(
        year: year,
        month: month,
        todosByDates: monthTodos,
      );
      return Right(todosByMonthModel);
    } catch (e) {
      return Left(AppFailure('Failed to load Month Todos: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, Unit>> createTodo(
      DateTime date, TodoModel todo) async {
    try {
      if (!isDateEditable(date)) {
        return Left(AppFailure('Cannot modify past dates.'));
      }

      // TodosByDateModel에 새 Todo 추가 후 저장
      await _updateTodos(date, (existingTodos) {
        final updatedTodos = List<TodoModel>.from(existingTodos.todos)
          ..add(todo);
        return existingTodos.copyWith(todos: updatedTodos);
      });

      // completion 상태 업데이트 (추가)
      final updatedTodos = (await getTodos(date))
          .getOrElse((failure) => _createEmptyTodosByDate(date));
      await _completionRepo.updateDailyCompletion(date, updatedTodos.todos);

      return const Right(unit);
    } catch (e) {
      return Left(AppFailure('Failed to create Todo: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, Unit>> updateTodo(
      DateTime date, TodoModel updatedTodo) async {
    try {
      if (!isDateEditable(date)) {
        return Left(AppFailure('Cannot modify past dates.'));
      }

      // TodosByDateModel에서 Todo 수정 후 저장
      await _updateTodos(date, (existingTodos) {
        final updatedTodos = existingTodos.todos.map((todo) {
          return todo.id == updatedTodo.id ? updatedTodo : todo;
        }).toList();
        return existingTodos.copyWith(todos: updatedTodos);
      });

      // completion 상태 업데이트 (추가)
      final updatedTodos = (await getTodos(date))
          .getOrElse((failure) => _createEmptyTodosByDate(date));
      await _completionRepo.updateDailyCompletion(date, updatedTodos.todos);

      return const Right(unit);
    } catch (e) {
      return Left(AppFailure('Failed to update Todo: ${e.toString()}'));
    }
  }

  // Todo 상태 업데이트 (isCompleted 전환)
  Future<Either<AppFailure, Unit>> toggleTodoCompletion(
      DateTime date, String todoId) async {
    try {
      if (!isDateEditable(date)) {
        return Left(AppFailure('Cannot modify past dates.'));
      }

      // 현재 Todo 가져오기
      final todosResult = await getTodos(date);

      return todosResult.fold((failure) => Left(failure), (todosByDate) async {
        final todo = todosByDate.todos.firstWhere((t) => t.id == todoId,
            orElse: () => throw Exception('Todo not found with ID: $todoId'));

        // 완료 상태 전환
        final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);

        // Todo 업데이트
        return await updateTodo(date, updatedTodo);
      });
    } catch (e) {
      return Left(
          AppFailure('Failed to toggle Todo completion: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, Unit>> deleteTodo(
      DateTime date, String todoId) async {
    try {
      if (!isDateEditable(date)) {
        return Left(AppFailure('Cannot modify past dates.'));
      }

      final key = getDateKey(date);
      final existingTodos = _todoBox.get(key) ?? _createEmptyTodosByDate(date);
      final updatedTodos =
          existingTodos.todos.where((t) => t.id != todoId).toList();

      if (updatedTodos.isEmpty) {
        await _todoBox.delete(key);
      } else {
        final updatedList = existingTodos.copyWith(todos: updatedTodos);
        await _todoBox.put(key, updatedList);
      }

      // completion 상태 업데이트
      await _completionRepo.updateDailyCompletion(date, updatedTodos);

      return const Right(unit);
    } catch (e) {
      return Left(AppFailure('Failed to delete Todo by Date: ${e.toString()}'));
    }
  }

  TodosByDateModel _createEmptyTodosByDate(DateTime date) {
    return TodosByDateModel(date: date, todos: []);
  }

  // TodosByDateModel을 업데이트하는 공통 메소드
  Future<void> _updateTodos(DateTime date,
      TodosByDateModel Function(TodosByDateModel) modifyTodos) async {
    final key = getDateKey(date);

    // 기존 TodosByDateModel을 가져오거나 새로 생성
    final existingTodos = _todoBox.get(key) ?? _createEmptyTodosByDate(date);

    // Todos 수정
    final updatedList = modifyTodos(existingTodos);

    // Hive에 업데이트된 TodosByDateModel 저장
    await _todoBox.put(key, updatedList);
  }

  // 일괄 할 일 업데이트 (스트리밍 등에 사용)
  Future<Either<AppFailure, Unit>> batchUpdateTodos(
      DateTime date, List<TodoModel> todos) async {
    try {
      if (!isDateEditable(date)) {
        return Left(AppFailure('Cannot modify past dates.'));
      }

      final key = getDateKey(date);
      final todosByDate = _createEmptyTodosByDate(date).copyWith(todos: todos);

      // 비어있는 경우 삭제
      if (todos.isEmpty) {
        await _todoBox.delete(key);
      } else {
        await _todoBox.put(key, todosByDate);
      }

      // completion 상태 업데이트
      await _completionRepo.updateDailyCompletion(date, todos);

      return const Right(unit);
    } catch (e) {
      return Left(AppFailure('Failed to batch update todos: ${e.toString()}'));
    }
  }
}
