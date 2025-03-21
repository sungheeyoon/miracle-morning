import 'package:miracle_morning/core/failure/failure.dart';
import 'package:miracle_morning/core/providers/box_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fpdart/fpdart.dart';

part 'setting_repository.g.dart';

@riverpod
Future<SettingRepository> settingRepository(SettingRepositoryRef ref) async {
  final box = await ref.watch(settingBoxProvider.future);
  return SettingRepository(box);
}

class SettingRepository {
  final Box<bool> _settingStateBox;

  static const String settingKey = 'settingState';

  SettingRepository(this._settingStateBox);

  // 전역 알림 상태 저장
  Future<Either<AppFailure, bool>> setSettingState(bool state) async {
    try {
      await _settingStateBox.put(settingKey, state);
      return Right(state);
    } catch (e) {
      return Left(
        AppFailure('Failed to set global notification state: ${e.toString()}'),
      );
    }
  }

  // 전역 알림 상태 불러오기
  Future<Either<AppFailure, bool>> getSettingState() async {
    try {
      return Right(
          _settingStateBox.get(settingKey, defaultValue: false) ?? false);
    } catch (e) {
      return Left(AppFailure(
          'Failed to get global notification state: ${e.toString()}'));
    }
  }
}
