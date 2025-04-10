import 'package:miracle_morning/core/ids/hive_type_ids.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: HiveTypeIds.todoModel)
class TodoModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  String? review;

  TodoModel({
    required this.id,
    required this.title,
    this.description,
    this.review,
    this.isCompleted = false,
    required this.createdAt,
  });

  TodoModel._({
    required this.id,
    required this.title,
    this.description,
    this.review,
    this.isCompleted = false,
    required this.createdAt,
  });

  static String generateUniqueId(DateTime createdAt) {
    final timestamp = createdAt.millisecondsSinceEpoch;
    final random = const Uuid().v4();
    return 'todo_${timestamp}_$random';
  }

  factory TodoModel.create({
    required String title,
    String? description,
    String? review,
  }) {
    final createdAt = DateTime.now();
    return TodoModel._(
      id: generateUniqueId(createdAt),
      title: title,
      description: description,
      review: review,
      createdAt: createdAt,
    );
  }

  TodoModel copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    String? review,
  }) {
    return TodoModel._(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      review: review ?? this.review,
    );
  }
}
