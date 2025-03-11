import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/core/providers/selected_date_provider.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';
import 'package:miracle_morning/features/home/viewmodel/home_viewmodel.dart';

class CreateTodoPage extends ConsumerStatefulWidget {
  final TodoModel? todo;

  const CreateTodoPage({super.key, this.todo});

  @override
  ConsumerState<CreateTodoPage> createState() => _CreateTodoPageState();
}

class _CreateTodoPageState extends ConsumerState<CreateTodoPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
  }

  void _saveTodo() async {
    final selectedDate = ref.watch(selectedDateProvider);
    final String title = _titleController.text.trim();
    final String? description = _descriptionController.text.trim().isNotEmpty
        ? _descriptionController.text.trim()
        : null;

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    // 새로운 Todo 생성 or 업데이트
    final TodoModel newTodo = widget.todo != null
        ? widget.todo!.copyWith(title: title, description: description)
        : TodoModel.create(
            title: title,
            description: description,
          );

    final notifier = ref.read(homeViewModelProvider.notifier);

    // 새 항목이면 추가, 기존 항목이면 업데이트
    if (widget.todo != null) {
      await notifier.updateTodo(selectedDate, newTodo);
    } else {
      await notifier.createTodo(selectedDate, newTodo);
    }

    if (mounted) {
      Navigator.pop(context, newTodo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo != null ? 'Edit Todo' : 'Create Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _saveTodo,
                child:
                    Text(widget.todo != null ? 'Update Todo' : 'Create Todo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
