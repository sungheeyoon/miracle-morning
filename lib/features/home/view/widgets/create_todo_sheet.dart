import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/core/providers/selected_date_provider.dart';
import 'package:miracle_morning/core/theme/app_colors.dart';
import 'package:miracle_morning/core/theme/app_text_styles.dart';
import 'package:miracle_morning/core/widgets/common_widgets.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/viewmodel/home_viewmodel.dart';

class CreateTodoSheet extends ConsumerStatefulWidget {
  const CreateTodoSheet({super.key});

  @override
  ConsumerState<CreateTodoSheet> createState() => _CreateTodoSheetState();
}

class _CreateTodoSheetState extends ConsumerState<CreateTodoSheet> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late FocusNode titleFocusNode;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
    titleFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      titleFocusNode.requestFocus();
    });

    titleController.addListener(() {
      setState(() {}); // 제목이 변경될 때마다 상태를 업데이트
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  // 제목이 비어있지 않으면 버튼을 활성화하는 조건
  bool get isButtonEnabled {
    return titleController.text.trim().isNotEmpty;
  }

  Future<void> createTodo() async {
    final selectedDate = ref.watch(selectedDateProvider);
    if (isButtonEnabled) {
      final newTodo = TodoModel.create(
        title: titleController.text,
        description: descriptionController.text,
      );
      await ref
          .read(homeViewModelProvider.notifier)
          .createTodo(selectedDate, newTodo);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 드래그 핸들
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 날짜 표시
            DateDisplayWidget(
              date: selectedDate,
              showIcon: true,
              showWeekday: true,
              fullFormat: true,
              style: AppTextStyles.body2.copyWith(color: AppColors.grey600),
            ),

            const SizedBox(height: 24),

            // 제목 입력 필드
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: TextField(
                maxLines: null,
                controller: titleController,
                focusNode: titleFocusNode,
                decoration: const InputDecoration(
                  hintText: "할 일을 입력하세요",
                  hintStyle: TextStyle(color: AppColors.grey400),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                style: AppTextStyles.subtitle1,
              ),
            ),

            const SizedBox(height: 16),

            // 설명 입력 필드
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: TextField(
                maxLines: 3,
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: "상세 내용 또는 목표를 입력하세요",
                  hintStyle: TextStyle(color: AppColors.grey400),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                style: AppTextStyles.body1,
              ),
            ),

            const SizedBox(height: 20),

            // 추가하기 버튼
            GradientButton(
              label: '추가하기',
              icon: Icons.add_task,
              gradientColors: AppColors.primaryGradient,
              isLoading: false,
              onPressed: isButtonEnabled
                  ? () async {
                      await createTodo();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    }
                  : () {},
            ),
          ],
        ),
      ),
    );
  }
}