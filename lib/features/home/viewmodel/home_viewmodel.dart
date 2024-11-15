import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/repositories/home_local_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<TodoModel>> getAllTodos(GetAllTodosRef ref) async {
  final repository = ref.watch(homeLocalRepositoryProvider);
  final res = await repository.loadTodos();
  return res.match(
    (l) => throw l.message,
    (r) => r,
  );
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late final HomeLocalRepository _homeLocalRepository;

  @override
  AsyncValue<List<TodoModel>> build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return const AsyncData([]);
  }

  Future<void> initSharedPreferences() async {
    await _homeLocalRepository.init();
  }

  Future<void> loadTodos() async {
    final result = await _homeLocalRepository.loadTodos();

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (todos) => state = AsyncValue.data(todos), // 성공 시 state 업데이트
    );
  }

  Future<void> updateTodo(TodoModel todo) async {
    final result = await _homeLocalRepository.updateTodo(todo);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        // 성공 시 state에서 해당 Todo 업데이트
        state = state.whenData((todos) {
          final updatedTodos =
              todos.map((t) => t.id == todo.id ? todo : t).toList();
          ref.invalidate(getAllTodosProvider);
          return updatedTodos;
        });
      },
    );
  }

  Future<void> deleteTodo(String todoId) async {
    final result = await _homeLocalRepository.deleteTodo(todoId);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        // 성공 시 state에서 해당 Todo 삭제
        state = state.whenData((todos) {
          final updatedTodos = todos.where((t) => t.id != todoId).toList();
          ref.invalidate(getAllTodosProvider);
          return updatedTodos;
        });
      },
    );
  }
}
