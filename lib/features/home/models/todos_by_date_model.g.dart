// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todos_by_date_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodosByDateModelAdapter extends TypeAdapter<TodosByDateModel> {
  @override
  final int typeId = 1;

  @override
  TodosByDateModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodosByDateModel(
      date: fields[0] as DateTime,
      todos: (fields[1] as List?)?.cast<TodoModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TodosByDateModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.todos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodosByDateModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
