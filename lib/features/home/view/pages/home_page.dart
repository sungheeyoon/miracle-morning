import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/core/providers/selected_date_provider.dart';
import 'package:miracle_morning/features/home/view/widgets/confirmation_dialog.dart';
import 'package:miracle_morning/features/home/view/widgets/todo_card.dart';
import 'package:miracle_morning/features/home/viewmodel/home_viewmodel.dart';
import 'create_todo_page.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final isEnabled =
        ref.watch(homeViewModelProvider.notifier).isEditable(selectedDate);
    // 현재 포커스된 달(연, 월)을 기준으로 월 단위 Todos 데이터 가져오기
    final monthTodosAsync =
        ref.watch(getMonthTodosProvider(_focusedDay.year, _focusedDay.month));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            monthTodosAsync.when(
              data: (todosByMonthModel) {
                return TableCalendar(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    ref.read(selectedDateProvider.notifier).state = selectedDay;
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  // 페이지(월) 변화 시 현재 포커스데이 변경
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                    CalendarFormat.week: 'Week',
                  },
                  // 각 날짜에 표시할 이벤트(마커) 로딩
                  eventLoader: (day) {
                    final dayTodos = todosByMonthModel.getTodosByDate(day);
                    if (dayTodos.todos.isEmpty) {
                      return [];
                    }
                    final allCompleted =
                        dayTodos.todos.every((t) => t.isCompleted);
                    if (allCompleted) {
                      return ['completed']; // 완료 이벤트
                    } else {
                      return ['incomplete']; // 미완료 이벤트
                    }
                  },
                  calendarStyle:
                      const CalendarStyle(cellMargin: EdgeInsets.all(12)),

                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isEmpty) return const SizedBox.shrink();

                      final eventType = events.first;
                      Color markerColor;
                      if (eventType == 'completed') {
                        markerColor = Colors.green;
                      } else if (eventType == 'incomplete') {
                        markerColor = Colors.red;
                      } else {
                        return const SizedBox.shrink();
                      }

                      return Positioned(
                        bottom: 3,
                        child: Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            color: markerColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error: $error'),
              ),
            ),
            Expanded(
              child: ref.watch(getTodosProvider(selectedDate)).when(
                    data: (todosByDateModel) {
                      return ListView.builder(
                        itemCount: todosByDateModel.todos.length,
                        itemBuilder: (context, index) {
                          final todo = todosByDateModel.todos[index];
                          // final isEnabled = !isPastDate(selectedDate);
                          return TodoCard(
                            todo: todo,
                            onChanged: isEnabled
                                ? (bool? value) {
                                    final updatedTodo = todo.copyWith(
                                        isCompleted: value ?? false);
                                    ref
                                        .read(homeViewModelProvider.notifier)
                                        .saveOrUpdateTodo(
                                            selectedDate, updatedTodo);
                                  }
                                : null,
                            actions: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: isEnabled
                                      ? () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateTodoPage(todo: todo),
                                            ),
                                          ).then((editedTodo) {
                                            if (editedTodo != null) {
                                              ref
                                                  .read(homeViewModelProvider
                                                      .notifier)
                                                  .saveOrUpdateTodo(
                                                      selectedDate, editedTodo);
                                            }
                                          })
                                      : null,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: isEnabled
                                      ? () => showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ConfirmationDialog(
                                              title: 'Delete Todo',
                                              content:
                                                  'Are you sure you want to delete this todo?',
                                              confirmButtonText: 'Delete',
                                              onConfirm: () {
                                                ref
                                                    .read(homeViewModelProvider
                                                        .notifier)
                                                    .deleteTodo(
                                                        selectedDate, todo.id);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          )
                                      : null,
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text('Error: $error'),
                    ),
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: isEnabled
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateTodoPage()),
                ).then((newTodo) {
                  if (newTodo != null) {
                    ref
                        .read(homeViewModelProvider.notifier)
                        .saveOrUpdateTodo(selectedDate, newTodo);
                  }
                });
              },
              tooltip: 'Add Todo',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
