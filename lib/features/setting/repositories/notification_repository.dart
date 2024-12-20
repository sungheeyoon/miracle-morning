import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:miracle_morning/core/failure/failure.dart';
import 'package:miracle_morning/core/notification/notification_service.dart';
import 'package:miracle_morning/core/providers/box_providers.dart';
import 'package:miracle_morning/features/setting/models/notification_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_repository.g.dart';

@riverpod
Future<NotificationRepository> notificationRepository(
    NotificationRepositoryRef ref) async {
  final box = await ref.watch(notificationBoxProvider.future);
  final localNotificationService = LocalNotificationService();
  return NotificationRepository(localNotificationService, box);
}

class NotificationRepository {
  final LocalNotificationService _notificationService;
  final Box<NotificationModel> _notificationBox;

  static const String todoNotificationKey = 'todoNotification';
  static const String checkNotificationKey = 'checkNotification';

  NotificationRepository(this._notificationService, this._notificationBox);

  // 알림 데이터 저장 및 알림 활성화/비활성화 처리
  Future<Either<AppFailure, Unit>> setNotification(
      NotificationType type, NotificationModel model) async {
    try {
      final key = type == NotificationType.todo
          ? todoNotificationKey
          : checkNotificationKey;

      // Hive에 알림 데이터 저장
      await _notificationBox.put(key, model);

      if (model.isEnabled) {
        // 알림 활성화
        await _notificationService.scheduleDailyNotification(
          id: type.index,
          title: type == NotificationType.todo
              ? 'Todo Reminder'
              : 'Check Reminder',
          body: 'Reminder set for ${model.time.hour}:${model.time.minute}',
          time: model.time,
        );
      } else {
        // 알림 비활성화
        await _notificationService.cancelNotification(type.index);
      }

      return const Right(unit);
    } catch (e) {
      return Left(AppFailure('Failed to set Notification: ${e.toString()}'));
    }
  }

  // 알림 데이터 불러오기
  Future<Either<AppFailure, NotificationModel>> getNotification(
      NotificationType type) async {
    try {
      final key = type == NotificationType.todo
          ? todoNotificationKey
          : checkNotificationKey;

      final notification = _notificationBox.get(key);

      // null 체크 및 기본값 반환
      return Right(notification ?? NotificationModel.defaultValue(type));
    } catch (e) {
      return Left(AppFailure('Failed to get Notification: ${e.toString()}'));
    }
  }
}
