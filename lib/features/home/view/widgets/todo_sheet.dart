import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:miracle_morning/core/providers/selected_date_provider.dart';
import 'package:miracle_morning/core/theme/app_colors.dart';
import 'package:miracle_morning/core/theme/app_text_styles.dart';
import 'package:miracle_morning/core/utils.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/view/widgets/confirmation_dialog.dart';
import 'package:miracle_morning/features/home/viewmodel/home_viewmodel.dart';

class TodoSheet extends ConsumerStatefulWidget {
  final TodoModel todo;
  final bool isPastDate;
  
  const TodoSheet({
    super.key, 
    required this.todo,
    this.isPastDate = false,
  });

  @override
  ConsumerState<TodoSheet> createState() => _TodoSheetState();
}

class _TodoSheetState extends ConsumerState<TodoSheet> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController reviewController;
  late FocusNode titleFocusNode;
  late FocusNode descriptionFocusNode;
  late FocusNode reviewFocusNode;
  bool isEditMode = false;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController =
        TextEditingController(text: widget.todo.description ?? "");
    reviewController = TextEditingController(text: widget.todo.review ?? "");
    titleFocusNode = FocusNode();
    descriptionFocusNode = FocusNode();
    reviewFocusNode = FocusNode();

    // 완료 상태 초기화
    isCompleted = widget.todo.isCompleted;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    reviewController.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    reviewFocusNode.dispose();
    super.dispose();
  }

  void enterEditMode(FocusNode focusNode) {
    // 과거 날짜인 경우 리뷰만 편집 가능하도록 함
    if (widget.isPastDate && focusNode != reviewFocusNode) {
      // 리뷰 필드만 편집 가능
      setState(() {
        isEditMode = true;
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        reviewFocusNode.requestFocus();
      });
      return;
    }
    
    setState(() {
      isEditMode = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  Future<void> updateTodo(DateTime selectedDate) async {
    // 과거 날짜인 경우 리뷰만 업데이트
    if (widget.isPastDate) {
      final newTodo = widget.todo.copyWith(
        review: reviewController.text.trim(),
      );
      await ref
          .read(homeViewModelProvider.notifier)
          .updateTodo(selectedDate, newTodo);
    } else {
      // 현재/미래 날짜는 모든 필드 업데이트
      final newTodo = widget.todo.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        review: reviewController.text.trim(),
        isCompleted: isCompleted,
      );
      await ref
          .read(homeViewModelProvider.notifier)
          .updateTodo(selectedDate, newTodo);
    }
  }

  void toggleCompleted(DateTime selectedDate) {
    // 과거 날짜는 완료 상태 변경 불가
    if (widget.isPastDate) return;
    
    setState(() {
      isCompleted = !isCompleted;
    });
    updateTodo(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 드래그 핸들
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              // 상단 바 (편집 모드일 때와 아닐 때)
              if (isEditMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () => setState(() => isEditMode = false),
                      icon: const Icon(Icons.close, size: 20),
                      label: const Text("취소"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        "편집중",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await updateTodo(selectedDate);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check, size: 20),
                      label: const Text("저장"),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getDateKey(widget.todo.createdAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    // 삭제 버튼
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmationDialog(
                            title: '할 일 삭제',
                            content: '이 할 일을 삭제하시겠습니까?',
                            confirmButtonText: '삭제',
                            onConfirm: () {
                              ref
                                  .read(homeViewModelProvider.notifier)
                                  .deleteTodo(selectedDate, widget.todo.id);
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                          ),
                        );
                      },
                      icon: Icon(
                        Ionicons.trash_outline,
                        color: Colors.red.shade400,
                        size: 20,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              // 타이틀 섹션 - 체크박스와 제목을 포함하는 컨테이너
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // 정렬 수정: start → center
                  children: [
                    // 완료 토글 버튼 (편집 모드가 아닐 때만 표시)
                    if (!isEditMode)
                      GestureDetector(
                        onTap: widget.isPastDate ? null : () => toggleCompleted(selectedDate),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                              ? widget.isPastDate 
                                  ? Colors.grey.shade400
                                  : AppColors.success
                              : Colors.transparent,
                            border: Border.all(
                              color: isCompleted
                                ? widget.isPastDate 
                                    ? Colors.grey.shade400
                                    : AppColors.success
                                : widget.isPastDate
                                    ? Colors.grey.shade400
                                    : AppColors.primary.withOpacity(0.6),
                              width: 2,
                            ),
                          ),
                          child: isCompleted
                            ? const Center(
                                child: Icon(
                                  Icons.check,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              )
                            : null,
                        ),
                      ),
                    
                    // 제목 필드
                    Expanded(
                      child: GestureDetector(
                        onTap: !isEditMode ? () => setState(() => isEditMode = true) : null,
                        child: Container(
                          padding: isEditMode
                            ? const EdgeInsets.symmetric(vertical: 4)
                            : EdgeInsets.zero,
                          child: TextFormField(
                            controller: titleController,
                            focusNode: titleFocusNode,
                            decoration: InputDecoration(
                              border: isEditMode 
                                  ? OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.primary.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    )
                                  : InputBorder.none,
                              enabledBorder: isEditMode
                                  ? OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.primary.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    )
                                  : InputBorder.none,
                              focusedBorder: isEditMode
                                  ? OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: AppColors.primary,
                                        width: 1.5,
                                      ),
                                    )
                                  : InputBorder.none,
                              contentPadding: isEditMode
                                  ? const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    )
                                  : EdgeInsets.zero,
                              hintText: isEditMode ? "할 일 제목을 입력하세요" : null,
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                              filled: isEditMode,
                              fillColor: isEditMode ? Colors.grey.shade50 : Colors.transparent,
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: widget.isPastDate ? Colors.grey[700] : Colors.black87,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                              decorationColor: Colors.grey.shade400,
                              decorationThickness: 2.0,
                            ),
                            enabled: isEditMode && !widget.isPastDate,
                            maxLines: isEditMode ? 2 : 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 상세 내용 섹션
              if ((widget.todo.description?.isNotEmpty ?? false) || isEditMode)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "상세 내용",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: !isEditMode ? () => setState(() => isEditMode = true) : null,
                      child: TextFormField(
                        controller: descriptionController,
                        focusNode: descriptionFocusNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isEditMode 
                                  ? AppColors.primary.withOpacity(0.3)
                                  : Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isEditMode 
                                  ? AppColors.primary.withOpacity(0.3)
                                  : Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          hintText: isEditMode 
                            ? "상세 내용을 입력하세요" 
                            : (descriptionController.text.isEmpty 
                                ? "상세 내용이 없습니다" 
                                : null),
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15,
                            fontStyle: isEditMode ? FontStyle.normal : FontStyle.italic,
                          ),
                          filled: true,
                          fillColor: isEditMode ? Colors.grey.shade50 : Colors.grey.shade50,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: null,
                        minLines: 3,
                        enabled: isEditMode && !widget.isPastDate,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),

              // 리뷰 섹션
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "할일 리뷰",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: !isEditMode ? () => setState(() => isEditMode = true) : null,
                    child: TextFormField(
                      controller: reviewController,
                      focusNode: reviewFocusNode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isEditMode 
                                ? AppColors.primary.withOpacity(0.3)
                                : Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isEditMode 
                                ? AppColors.primary.withOpacity(0.3)
                                : Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        hintText: isEditMode 
                          ? "이 일에 대한 생각이나 느낌을 자유롭게 기록해보세요" 
                          : (reviewController.text.isEmpty 
                              ? "작성된 리뷰가 없습니다" 
                              : null),
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 15,
                          fontStyle: isEditMode ? FontStyle.normal : FontStyle.italic,
                        ),
                        filled: true,
                        fillColor: isEditMode ? Colors.grey.shade50 : Colors.grey.shade50,
                      ),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                      maxLines: null,
                      minLines: 4,
                      enabled: isEditMode,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
