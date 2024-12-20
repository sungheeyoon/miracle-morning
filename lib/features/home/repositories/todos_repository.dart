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

  Future<Either<AppFailure, TodosByDateModel>> getTodos(DateTime date) async {
    try {
      final key = getDateKey(date);
      final todosByDate = _todoBox.get(key) ?? _createEmptyTodosByDate(date);
      return Right(todosByDate);
    } catch (e) {
      return Left(AppFailure('Failed to load Todos by Date: ${e.toString()}'));
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

  Future<Either<AppFailure, Unit>> saveOrUpdateTodo(
      DateTime date, TodoModel todo) async {
    try {
      if (!isDateEditable(date)) {
        return Left(AppFailure('Cannot modify past dates.'));
      }

      final key = getDateKey(date);
      final existingTodos = _todoBox.get(key) ?? _createEmptyTodosByDate(date);
      final updatedTodos =
          existingTodos.todos.where((t) => t.id != todo.id).toList()..add(todo);

      final updatedList = existingTodos.copyWith(todos: updatedTodos);
      await _todoBox.put(key, updatedList);

      await _completionRepo.updateDailyCompletion(date, updatedList.todos);

      return const Right(unit);
    } catch (e) {
      return Left(AppFailure('Failed to save or update Todo: ${e.toString()}'));
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
        await _completionRepo.updateDailyCompletion(date, updatedList.todos);
      }

      return const Right(unit);
    } catch (e) {
      return Left(AppFailure('Failed to delete Todo by Date: ${e.toString()}'));
    }
  }

  TodosByDateModel _createEmptyTodosByDate(DateTime date) {
    return TodosByDateModel(date: date, todos: []);
  }
}
