import 'package:flutter/material.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final void Function(bool?)? onChanged;
  final Widget? actions;

  const TodoCard({
    super.key,
    required this.todo,
    this.onChanged,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Checkbox(
              value: todo.isCompleted,
              onChanged: onChanged,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  if (todo.description != null &&
                      todo.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      todo.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    'Created at: ${todo.createdAt.toLocal()}'.split('.')[0],
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (actions != null) ...[
              const SizedBox(width: 8),
              actions!,
            ],
          ],
        ),
      ),
    );
  }
}
