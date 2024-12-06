import 'package:miracle_morning/core/failure/failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fpdart/fpdart.dart';

part 'setting_repository.g.dart';

@riverpod
SettingRepository settingRepository(SettingRepositoryRef ref) {
  return SettingRepository();
}

class SettingRepository {
  late Box<bool> _globalStateBox;

  static const String globalNotificationKey = 'globalNotificationState';

  Future<Either<AppFailure, Unit>> init() async {
    try {
      _globalStateBox = await Hive.openBox<bool>('globalStateBox');
      return const Right(unit);
    } catch (e) {
      return Left(
        AppFailure('Failed to initialize Hive: ${e.toString()}'),
      );
    }
  }

  // 전역 알림 상태 저장
  Future<Either<AppFailure, bool>> setGlobalNotificationState(
      bool state) async {
    try {
      await _globalStateBox.put(globalNotificationKey, state);
      return Right(state);
    } catch (e) {
      return Left(
        AppFailure('Failed to set global notification state: ${e.toString()}'),
      );
    }
  }

  // 전역 알림 상태 불러오기
  Future<Either<AppFailure, bool>> getGlobalNotificationState() async {
    try {
      return Right(
          _globalStateBox.get(globalNotificationKey, defaultValue: false) ??
              false);
    } catch (e) {
      return Left(AppFailure(
          'Failed to get global notification state: ${e.toString()}'));
    }
  }
}
