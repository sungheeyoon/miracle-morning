import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miracle_morning/features/home/view/pages/error_page.dart';
import 'package:miracle_morning/features/home/view/widgets/confirmation_dialog.dart';
import 'package:miracle_morning/features/home/view/widgets/todo_card.dart';
import 'package:miracle_morning/features/home/viewmodel/home_viewmodel.dart';
import 'create_todo_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Duration duration = const Duration(hours: 1, minutes: 23);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Home'),
      ),
      body: ref.watch(homeViewModelProvider).when(
            data: (todos) {
              // todos 리스트가 비어 있는 경우 처리
              if (todos.isEmpty) {
                return Center(
                  child: Text(
                    'No todos available.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                );
              }

              return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  // Todo 항목
                  final todo = todos[index];
                  return TodoCard(
                    todo: todo,
                    onChanged: (bool? value) {
                      final updatedTodo =
                          todos[index].copyWith(isCompleted: value ?? false);
                      ref
                          .read(homeViewModelProvider.notifier)
                          .updateTodo(updatedTodo);
                    },
                    actions: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateTodoPage(todo: todos[index]),
                            ),
                          ).then((editedTodo) {
                            if (editedTodo != null) {
                              ref
                                  .read(homeViewModelProvider.notifier)
                                  .updateTodo(editedTodo);
                            }
                          }),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => ConfirmationDialog(
                              title: 'Delete Todo',
                              content:
                                  'Are you sure you want to delete this todo?',
                              confirmButtonText: 'Delete',
                              onConfirm: () {
                                ref
                                    .read(homeViewModelProvider.notifier)
                                    .deleteTodo(todos[index].id);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => ErrorPage(
              errorMessage: error.toString(),
              onRetry: () async => await ref.read(homeViewModelProvider),
            ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTodoPage()),
          ).then((newTodo) {
            if (newTodo != null) {
              ref.read(homeViewModelProvider.notifier).updateTodo(newTodo);
            }
          });
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
