import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:miracle_morning/core/ids/hive_type_ids.dart';

class TimeOfDayAdapter extends TypeAdapter<TimeOfDay> {
  @override
  final int typeId = HiveTypeIds.timeOfDay;

  @override
  TimeOfDay read(BinaryReader reader) {
    final hour = reader.readInt();
    final minute = reader.readInt();
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  void write(BinaryWriter writer, TimeOfDay obj) {
    writer.writeInt(obj.hour);
    writer.writeInt(obj.minute);
  }
}
