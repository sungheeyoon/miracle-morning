import 'package:hive/hive.dart';
import 'package:miracle_morning/core/ids/hive_type_ids.dart';

part 'streak_model.g.dart';

@HiveType(typeId: HiveTypeIds.streakModel)
class StreakModel extends HiveObject {
  @HiveField(0)
  int currentStreak;

  @HiveField(1)
  int maxStreak;

  @HiveField(2)
  String lastCompletedDate;

  @HiveField(3)
  String lastCheckedDate;

  StreakModel({
    this.currentStreak = 0,
    this.maxStreak = 0,
    this.lastCompletedDate = '',
    this.lastCheckedDate = '',
  });

  StreakModel copyWith({
    int? currentStreak,
    int? maxStreak,
    String? lastCompletedDate,
    String? lastCheckedDate,
  }) {
    return StreakModel(
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      lastCheckedDate: lastCheckedDate ?? this.lastCheckedDate,
    );
  }

  @override
  String toString() {
    return 'StreakModel(currentStreak: $currentStreak, maxStreak: $maxStreak, '
        'lastCompletedDate: $lastCompletedDate, lastCheckedDate: $lastCheckedDate)';
  }
}
