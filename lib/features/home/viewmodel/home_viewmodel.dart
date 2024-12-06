import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/repositories/todo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late final TodoRepository _todoRepository;

  @override
  AsyncValue<List<TodoModel>> build() {
    _initialize();
    return const AsyncLoading();
  }

  Future<void> _initialize() async {
    _todoRepository = ref.watch(todoRepositoryProvider);
    await _todoRepository.init();
    await loadTodos();
  }

  Future<void> loadTodos() async {
    final result = await _todoRepository.loadTodos();
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (todos) => state = AsyncValue.data(todos),
    );
  }

  Future<void> updateTodo(TodoModel todo) async {
    final result = await _todoRepository.updateTodo(todo);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        state = state.whenData((todos) {
          final updatedTodos =
              todos.map((t) => t.id == todo.id ? todo : t).toList();
          return updatedTodos;
        });
      },
    );
  }

  Future<void> addTodo(TodoModel todo) async {
    final result = await _todoRepository.updateTodo(todo);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        state = state.whenData((todos) {
          final updatedTodos = [...todos, todo];
          return updatedTodos;
        });
      },
    );
  }

  Future<void> deleteTodo(String todoId) async {
    final result = await _todoRepository.deleteTodo(todoId);
    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        state = state.whenData((todos) {
          final updatedTodos = todos.where((t) => t.id != todoId).toList();
          return updatedTodos;
        });
      },
    );
  }
}
