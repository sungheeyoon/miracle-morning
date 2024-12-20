import 'package:hive/hive.dart';
import 'package:miracle_morning/core/ids/hive_type_ids.dart';
import 'package:miracle_morning/features/home/models/todo_model.dart';

part 'todos_by_date_model.g.dart';

@HiveType(typeId: HiveTypeIds.todosByDateModel)
class TodosByDateModel extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final List<TodoModel> todos;

  TodosByDateModel({
    required this.date,
    List<TodoModel>? todos,
  }) : todos = todos ?? const [];

  TodosByDateModel copyWith({
    DateTime? date,
    List<TodoModel>? todos,
  }) {
    return TodosByDateModel(
      date: date ?? this.date,
      todos: todos ?? this.todos,
    );
  }
}
