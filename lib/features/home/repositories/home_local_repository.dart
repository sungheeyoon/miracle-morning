import 'package:fpdart/fpdart.dart';
import 'package:miracle_morning/core/failure/failure.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:convert';

part 'home_local_repository.g.dart';

@Riverpod(keepAlive: true)
HomeLocalRepository homeLocalRepository(HomeLocalRepositoryRef ref) {
  return HomeLocalRepository();
}

class HomeLocalRepository {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<Either<AppFailure, Unit>> updateTodo(TodoModel todo) async {
    try {
      await _prefs.setString(todo.id, json.encode(todo.toJson()));
      return const Right(unit);
    } catch (e) {
      return Left(AppFailure('Failed to upload Todo: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, Unit>> deleteTodo(String todoId) async {
    try {
      await _prefs.remove(todoId);
      return const Right(unit);
    } catch (e) {
      return Left(AppFailure('Failed to delete Todo: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, List<TodoModel>>> loadTodos() async {
    try {
      await _prefs.reload();
      final keys = _prefs.getKeys();
      List<TodoModel> todos = [];
      for (String key in keys) {
        final String? todoString = _prefs.getString(key);
        if (todoString != null) {
          todos.add(TodoModel.fromJson(json.decode(todoString)));
        }
      }
      return Right(todos);
    } catch (e) {
      return Left(AppFailure('Failed to load Todos: ${e.toString()}'));
    }
  }
}
