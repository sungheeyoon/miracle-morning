import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/core/providers/selected_date_provider.dart';
import 'package:miracle_morning/features/home/view/widgets/create_todo_sheet.dart';
import 'package:miracle_morning/features/home/view/widgets/todo_card.dart';
import 'package:miracle_morning/features/home/view/widgets/todo_status_calendar.dart'; // 수정된 import
import 'package:miracle_morning/features/home/viewmodel/home_viewmodel.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // 현재 선택된 날짜 상태 관리
    final selectedDate = ref.watch(selectedDateProvider);

    // 선택된 날짜가 수정 가능한지 여부 확인 (과거 날짜는 수정 불가능)
    final isEnabled =
        ref.watch(homeViewModelProvider.notifier).isEditable(selectedDate);

    // 현재 포커스된 달의 모든 Todo 데이터를 비동기로 가져오기
    final monthTodosAsync =
        ref.watch(getMonthTodosProvider(_focusedDay.year, _focusedDay.month));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            monthTodosAsync.when(
              data: (todosByMonthModel) {
                return TodoStatusCalendar(
                  todosByMonthModel: todosByMonthModel,
                  onFocusedDayChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
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
                              isEnabled: isEnabled,
                              selectedDate: selectedDate,
                              ref: ref);
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
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade400,
                    Colors.blue.shade600,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () => showMaterialModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => const CreateTodoSheet(),
                ),
                tooltip: '할 일 추가하기',
                backgroundColor: Colors.transparent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            )
          : null,
    );
  }
}
