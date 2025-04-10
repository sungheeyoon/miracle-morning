import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/core/providers/selected_date_provider.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/models/todos_by_month_model.dart';
import 'package:miracle_morning/features/home/repositories/todos_repository.dart';
import 'package:miracle_morning/features/home/models/todos_by_date_model.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@Riverpod(keepAlive: true)
Future<TodosByDateModel> getTodos(GetTodosRef ref, DateTime date) async {
  final normalizedDate = DateTime(date.year, date.month, date.day);
  final todosRepository = await ref.watch(todosRepositoryProvider.future);
  final result = await todosRepository.getTodos(normalizedDate);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (todosByDate) => todosByDate,
  );
}

@Riverpod(keepAlive: true)
Future<TodosByMonthModel> getMonthTodos(
    GetMonthTodosRef ref, int year, int month) async {
  final todosRepository = await ref.watch(todosRepositoryProvider.future);
  final result = await todosRepository.getMonthTodos(year, month);

  return result.fold(
    (failure) => throw Exception(failure.message),
    (todosByMonth) => todosByMonth,
  );
}

typedef CalendarRefreshCallback = void Function();
CalendarRefreshCallback? globalCalendarRefreshCallback;

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<TodosByDateModel> build() async {
    return TodosByDateModel(date: DateTime.now(), todos: []);
  }

  void notifyChange() {
    state = AsyncValue.data(
        state.value ?? TodosByDateModel(date: DateTime.now(), todos: []));
  }

  Future<void> createTodo(DateTime date, TodoModel todo) async {
    try {
      final todosRepository = await ref.watch(todosRepositoryProvider.future);
      final result = await todosRepository.createTodo(date, todo);
      result.fold(
        (failure) =>
            state = AsyncValue.error(failure.message, StackTrace.current),
        (_) {
          ref.invalidate(getTodosProvider(date));
          ref.invalidate(getMonthTodosProvider(date.year, date.month));
          _invalidateCalendarData(date);
        },
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> updateTodo(DateTime date, TodoModel todo) async {
    try {
      final todosRepository = await ref.watch(todosRepositoryProvider.future);
      final result = await todosRepository.updateTodo(date, todo);

      result.fold(
        (failure) {
          state = AsyncValue.error(failure.message, StackTrace.current);
        },
        (_) {
          final now = DateTime.now();
          final currentMonth = now.month;
          final currentYear = now.year;

          ref.invalidate(getTodosProvider(date));
          ref.invalidate(getMonthTodosProvider(date.year, date.month));
          
          if (date.year != currentYear || date.month != currentMonth) {
            ref.invalidate(getMonthTodosProvider(currentYear, currentMonth));
          }
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            try {
              ref.refresh(getTodosProvider(date));
              ref.refresh(getMonthTodosProvider(date.year, date.month));
              
              if (date.year != currentYear || date.month != currentMonth) {
                ref.refresh(getMonthTodosProvider(currentYear, currentMonth));
              }
            } catch (e) {
              state = AsyncValue.error(e, StackTrace.current);
            }
          });
        },
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> deleteTodo(DateTime date, String todoId) async {
    try {
      final todosRepository = await ref.watch(todosRepositoryProvider.future);
      final result = await todosRepository.deleteTodo(date, todoId);
      result.fold(
        (failure) =>
            state = AsyncValue.error(failure.message, StackTrace.current),
        (_) {
          ref.invalidate(getTodosProvider(date));
          ref.invalidate(getMonthTodosProvider(date.year, date.month));
          _invalidateCalendarData(date);
        },
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _invalidateCalendarData(DateTime date) {
    ref.invalidate(getTodosProvider(date));
    ref.invalidate(getMonthTodosProvider(date.year, date.month));
    
    final selectedDate = ref.read(selectedDateProvider);
    final focusedDate = ref.read(focusedDateProvider);
    
    if (!_isSameDate(selectedDate, date)) {
      ref.invalidate(getTodosProvider(selectedDate));
      
      if (selectedDate.year != date.year || selectedDate.month != date.month) {
        ref.invalidate(getMonthTodosProvider(selectedDate.year, selectedDate.month));
      }
    }
    
    if (focusedDate.year != date.year || focusedDate.month != date.month) {
      ref.invalidate(getMonthTodosProvider(focusedDate.year, focusedDate.month));
    }
    
    if (globalCalendarRefreshCallback != null) {
      globalCalendarRefreshCallback!();
    }
  }

  bool isEditable(DateTime date) {
    final repo = ref.read(todosRepositoryProvider).valueOrNull;
    if (repo == null) return false;
    return repo.isDateEditable(date);
  }
}
