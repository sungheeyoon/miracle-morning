import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:miracle_morning/core/providers/selected_date_provider.dart';
import 'package:miracle_morning/core/utils.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/view/widgets/confirmation_dialog.dart';
import 'package:miracle_morning/features/home/viewmodel/home_viewmodel.dart';

const Color _primaryColor = Color(0xFF6B8AFE); // 밝은 퍼플
const Color _secondaryColor = Color(0xFF4A6CF7); // 진한 퍼플
const Color _successColor = Color(0xFF4CAF50); // 성공 초록색
const Color _errorColor = Color(0xFFE57373); // 에러 빨간색
const Color _textColor = Color(0xFF2D3142); // 텍스트 색상

class TodoSheet extends ConsumerStatefulWidget {
  final TodoModel todo;
  const TodoSheet({super.key, required this.todo});

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
    setState(() {
      isEditMode = true;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      focusNode.requestFocus();
    });
  }

  Future<void> updateTodo(DateTime selectedDate) async {
    final newTodo = widget.todo.copyWith(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      review: reviewController.text.trim(),
    );
    await ref
        .read(homeViewModelProvider.notifier)
        .updateTodo(selectedDate, newTodo);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.03),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isEditMode)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => setState(() => isEditMode = false),
                      child: Text(
                        "취소",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "편집모드",
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        await updateTodo(selectedDate);
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      child: Text(
                        "저장",
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontSize: 16,
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
                      ),
                    ),
                  ],
                ),
              GestureDetector(
                onTap: () => enterEditMode(titleFocusNode),
                child: TextField(
                  controller: titleController,
                  focusNode: titleFocusNode,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: isEditMode ? "제목을 입력하세요" : null,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 20,
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  enabled: isEditMode,
                ),
              ),
              if ((widget.todo.description?.isNotEmpty ?? false) || isEditMode)
                GestureDetector(
                  onTap: () => enterEditMode(descriptionFocusNode),
                  child: TextField(
                    controller: descriptionController,
                    focusNode: descriptionFocusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: isEditMode ? "설명을 입력하세요" : null,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    maxLines: null,
                    enabled: isEditMode,
                  ),
                ),
              if ((widget.todo.review?.isNotEmpty ?? false) || isEditMode)
                GestureDetector(
                  onTap: () => enterEditMode(reviewFocusNode),
                  child: TextField(
                    controller: reviewController,
                    focusNode: reviewFocusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: isEditMode ? "리뷰를 입력하세요" : null,
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    maxLines: null,
                    enabled: isEditMode,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
