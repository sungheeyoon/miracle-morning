// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GrowthLevelAdapter extends TypeAdapter<GrowthLevel> {
  @override
  final int typeId = 4;

  @override
  GrowthLevel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrowthLevel(
      level: fields[0] as int,
      currentExp: fields[1] as double,
      lastCheckIn: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, GrowthLevel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.currentExp)
      ..writeByte(2)
      ..write(obj.lastCheckIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrowthLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
