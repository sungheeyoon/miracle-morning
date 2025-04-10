import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/core/theme/app_colors.dart';
import 'package:miracle_morning/core/theme/app_text_styles.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/view/widgets/todo_sheet.dart';
import 'package:miracle_morning/features/home/viewmodel/home_viewmodel.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final bool isEnabled;
  final DateTime selectedDate;
  final WidgetRef ref;

  const TodoCard({
    super.key,
    required this.todo,
    required this.isEnabled,
    required this.selectedDate,
    required this.ref,
  });

  bool get isPastDate {
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    final compareDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    return compareDate.isBefore(today);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            showMaterialModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => TodoSheet(
                todo: todo,
                isPastDate: isPastDate,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildCheckbox(),
                const SizedBox(width: 16),
                _buildTodoContent(),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.grey400,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return GestureDetector(
      onTap: (isEnabled && !isPastDate) ? _handleTodoToggle : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _getCheckboxBorderColor(),
            width: 2,
          ),
          color: _getCheckboxFillColor(),
        ),
        child: todo.isCompleted
            ? const Icon(
                Icons.check,
                size: 16,
                color: AppColors.white,
              )
            : null,
      ),
    );
  }

  Color _getCheckboxBorderColor() {
    if (isPastDate) {
      return AppColors.grey400;
    } else if (todo.isCompleted) {
      return AppColors.success;
    } else if (isEnabled) {
      return AppColors.primary.withOpacity(0.7);
    } else {
      return AppColors.grey400;
    }
  }

  Color _getCheckboxFillColor() {
    if (todo.isCompleted) {
      return isPastDate ? AppColors.grey400 : AppColors.success;
    } else {
      return Colors.transparent;
    }
  }

  Widget _buildTodoContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            todo.title,
            style: AppTextStyles.subtitle2.copyWith(
              decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              color: todo.isCompleted ? AppColors.grey500 : AppColors.grey800,
            ),
          ),
          if (todo.description != null && todo.description!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              todo.description!,
              style: AppTextStyles.body2.copyWith(
                color: AppColors.grey600,
                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  void _handleTodoToggle() {
    final isNowCompleted = !todo.isCompleted;
    final updatedTodo = todo.copyWith(isCompleted: isNowCompleted);

    ref.read(homeViewModelProvider.notifier).updateTodo(selectedDate, updatedTodo);

    ref.invalidate(getTodosProvider(selectedDate));
    ref.invalidate(getMonthTodosProvider(selectedDate.year, selectedDate.month));
    
    ref.refresh(getMonthTodosProvider(selectedDate.year, selectedDate.month));

    if (globalCalendarRefreshCallback != null) {
      globalCalendarRefreshCallback!();
    }
  }
}