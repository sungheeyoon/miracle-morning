import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/core/providers/selected_date_provider.dart';
import 'package:miracle_morning/core/theme/app_colors.dart';
import 'package:miracle_morning/core/widgets/common_widgets.dart';
import 'package:miracle_morning/features/home/models/todos_by_month_model.dart';
import 'package:miracle_morning/features/home/view/widgets/create_todo_sheet.dart';
import 'package:miracle_morning/features/home/view/widgets/todo_card.dart';
import 'package:miracle_morning/features/home/view/widgets/todo_status_calendar.dart';
import 'package:miracle_morning/features/home/viewmodel/home_viewmodel.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final focusedDate = ref.watch(focusedDateProvider);
    final isEnabled = ref.watch(homeViewModelProvider.notifier).isEditable(selectedDate);
    final monthTodosAsync = ref.watch(getMonthTodosProvider(focusedDate.year, focusedDate.month));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildCalendar(monthTodosAsync, selectedDate, focusedDate),
            _buildTodoList(selectedDate, isEnabled),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(isEnabled),
    );
  }

  Widget _buildCalendar(AsyncValue<TodosByMonthModel> monthTodosAsync, DateTime selectedDate, DateTime focusedDate) {
    return monthTodosAsync.when(
      data: (monthData) {
        return TodoStatusCalendar(
          monthData: monthData,
          selectedDate: selectedDate,
          focusedDate: focusedDate,
          isLoading: false,
        );
      },
      loading: () => TodoStatusCalendar(
        monthData: TodosByMonthModel.empty(
          year: focusedDate.year,
          month: focusedDate.month,
        ),
        selectedDate: selectedDate,
        focusedDate: focusedDate,
        isLoading: true,
      ),
      error: (error, stack) => TodoStatusCalendar(
        monthData: TodosByMonthModel.empty(
          year: focusedDate.year,
          month: focusedDate.month,
        ),
        selectedDate: selectedDate,
        focusedDate: focusedDate,
        isLoading: false,
        hasError: true,
        errorMessage: error.toString(),
      ),
    );
  }

  Widget _buildTodoList(DateTime selectedDate, bool isEnabled) {
    return Expanded(
      child: ref.watch(getTodosProvider(selectedDate)).when(
        data: (todosByDateModel) {
          if (todosByDateModel.todos.isEmpty) {
            return _buildEmptyState(selectedDate);
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: todosByDateModel.todos.length,
            itemBuilder: (context, index) {
              final todo = todosByDateModel.todos[index];
              return TodoCard(
                todo: todo,
                isEnabled: isEnabled,
                selectedDate: selectedDate,
                ref: ref,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(DateTime selectedDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    IconData emptyStateIcon;
    String titleMessage;
    String subtitleMessage;
    Color iconColor;

    if (selectedDay.isAtSameMomentAs(today)) {
      emptyStateIcon = Icons.task_alt;
      titleMessage = '오늘의 할 일을 추가해보세요!';
      subtitleMessage = '아래 + 버튼을 눌러 하루를 계획해보세요';
      iconColor = AppColors.primary;
    } else if (selectedDay.isAfter(today)) {
      emptyStateIcon = Icons.event_note;
      titleMessage = '${selectedDate.month}월 ${selectedDate.day}일의 할 일을 추가해보세요!';
      subtitleMessage = '미리 계획하고 준비하세요';
      iconColor = AppColors.secondary;
    } else {
      emptyStateIcon = Icons.history;
      titleMessage = '이 날의 기록이 없습니다';
      subtitleMessage = '과거의 할 일은 추가할 수 없습니다';
      iconColor = AppColors.grey500;
    }

    return EmptyStateWidget(
      icon: emptyStateIcon,
      title: titleMessage,
      subtitle: subtitleMessage,
      iconColor: iconColor,
    );
  }

  Widget? _buildFloatingActionButton(bool isEnabled) {
    if (!isEnabled) return null;
    
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow,
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
          color: AppColors.white,
          size: 28,
        ),
      ),
    );
  }
}
