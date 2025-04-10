// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StreakModelAdapter extends TypeAdapter<StreakModel> {
  @override
  final int typeId = 5;

  @override
  StreakModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StreakModel(
      currentStreak: fields[0] as int,
      maxStreak: fields[1] as int,
      lastCompletedDate: fields[2] as String,
      lastCheckedDate: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StreakModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.currentStreak)
      ..writeByte(1)
      ..write(obj.maxStreak)
      ..writeByte(2)
      ..write(obj.lastCompletedDate)
      ..writeByte(3)
      ..write(obj.lastCheckedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
