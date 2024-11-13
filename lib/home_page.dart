import 'package:flutter/material.dart';
import 'package:miracle_morning/models/todo_model.dart';
import 'package:miracle_morning/widgets/todo_card.dart';
import 'create_todo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Todo> _todos = [];

  void _editTodo(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTodoPage(todo: _todos[index]),
      ),
    ).then((editedTodo) {
      if (editedTodo != null) {
        setState(() {
          _todos[index] = editedTodo;
        });
      }
    });
  }

  void _deleteTodoConfirm(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: const Text('Are you sure you want to delete this todo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteTodo(index);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  return TodoCard(
                    todo: _todos[index],
                    onChanged: (bool? value) {
                      setState(() {
                        _todos[index] =
                            _todos[index].copyWith(isCompleted: value ?? false);
                      });
                    },
                    actions: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editTodo(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTodoConfirm(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTodoPage()),
          ).then((newTodo) {
            if (newTodo != null) {
              setState(() {
                _todos.add(newTodo);
              });
            }
          });
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
