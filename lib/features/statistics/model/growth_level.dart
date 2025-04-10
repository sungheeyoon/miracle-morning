import 'package:hive/hive.dart';
import 'package:miracle_morning/core/ids/hive_type_ids.dart';

part 'growth_level.g.dart';

@HiveType(typeId: HiveTypeIds.growthLevel)
class GrowthLevel extends HiveObject {
  @HiveField(0)
  int level;

  @HiveField(1)
  double currentExp;

  @HiveField(2)
  DateTime lastCheckIn;

  GrowthLevel({
    this.level = 1,
    this.currentExp = 0,
    DateTime? lastCheckIn,
  }) : lastCheckIn = lastCheckIn ?? DateTime.now();
}
