import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miracle_morning/core/failure/failure.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_repository.g.dart';

@riverpod
TodoRepository todoRepository(TodoRepositoryRef ref) {
  return TodoRepository();
}

class TodoRepository {
  late Box<TodoModel> _todoBox;

  Future<void> init() async {
    //TodoModel 의 typeId 가 0이므로 중복 등록 오류 방지
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TodoModelAdapter());
    }

    _todoBox = await Hive.openBox<TodoModel>('todoBox');
  }

  Future<Either<AppFailure, Unit>> updateTodo(TodoModel todo) async {
    try {
      await _todoBox.put(todo.id, todo);
      return const Right(unit);
    } catch (e) {
      return Left(AppFailure('Failed to update Todo: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, Unit>> deleteTodo(String todoId) async {
    try {
      await _todoBox.delete(todoId);
      return const Right(unit);
    } catch (e) {
      return Left(AppFailure('Failed to delete Todo: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, List<TodoModel>>> loadTodos() async {
    try {
      final todos = _todoBox.values.toList();
      return Right(todos);
    } catch (e) {
      return Left(AppFailure('Failed to load Todos: ${e.toString()}'));
    }
  }
}
