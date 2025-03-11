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

  // 기본 생성자 추가
  TodoModel({
    required this.id,
    required this.title,
    this.description,
    this.review,
    this.isCompleted = false,
    required this.createdAt,
  });

  // 비공개 생성자
  TodoModel._({
    required this.id,
    required this.title,
    this.description,
    this.review,
    this.isCompleted = false,
    required this.createdAt,
  });

  // 고유한 ID를 생성하는 함수
  static String generateUniqueId(DateTime createdAt) {
    final timestamp = createdAt.millisecondsSinceEpoch;
    final random = const Uuid().v4(); // UUID를 추가하여 충돌을 방지
    return 'todo_${timestamp}_$random';
  }

  // create 메서드로만 인스턴스화 가능
  factory TodoModel.create({
    required String title,
    String? description,
    String? review,
  }) {
    final createdAt = DateTime.now();
    return TodoModel._(
      id: generateUniqueId(createdAt), // generateUniqueId를 사용
      title: title,
      description: description,
      review: review,
      createdAt: createdAt,
    );
  }

  // copyWith에서 id와 createdAt 수정금지
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
