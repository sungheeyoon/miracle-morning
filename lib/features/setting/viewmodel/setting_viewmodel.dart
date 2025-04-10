// lib/features/setting/viewmodel/setting_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:miracle_morning/core/notification/notification_service.dart';
import 'package:miracle_morning/features/setting/models/notification_model.dart';
import 'package:miracle_morning/features/setting/models/setting_state_model.dart';
import 'package:miracle_morning/features/setting/repositories/notification_repository.dart';
import 'package:miracle_morning/features/setting/repositories/setting_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setting_viewmodel.g.dart';

// 알림 권한 상태 제공자
@riverpod
Future<bool> notificationPermission(NotificationPermissionRef ref) async {
  final notificationService = LocalNotificationService();
  return await notificationService.checkNotificationPermission();
}

@riverpod
class SettingViewModel extends _$SettingViewModel {
  late LocalNotificationService _notificationService;

  @override
  Future<SettingStateModel> build() async {
    _notificationService = LocalNotificationService();
    final notificationRepository =
        await ref.watch(notificationRepositoryProvider.future);
    final settingRepository = await ref.watch(settingRepositoryProvider.future);
    
    // 알림 권한 상태 확인
    final hasPermission = await _notificationService.checkNotificationPermission();
    
    return _initialize(notificationRepository, settingRepository, hasPermission);
  }

  Future<SettingStateModel> _initialize(
    NotificationRepository notificationRepository,
    SettingRepository settingRepository,
    bool hasPermission,
  ) async {
    // 권한이 없으면 모든 알림 설정은 비활성화
    if (!hasPermission) {
      return SettingStateModel(
        isAllNotificationEnabled: false,
        isTodoNotificationEnabled: false,
        isCheckNotificationEnabled: false,
        todoNotificationTime: const TimeOfDay(hour: 8, minute: 0),
        checkNotificationTime: const TimeOfDay(hour: 21, minute: 0),
        hasNotificationPermission: false,
      );
    }

    bool isAllNotificationEnabled = false;
    final globalStateResult = await settingRepository.getSettingState();
    globalStateResult.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (stateValue) {
        isAllNotificationEnabled = stateValue;
      },
    );

    TimeOfDay todoNotificationTime = const TimeOfDay(hour: 8, minute: 0);
    bool isTodoNotificationEnabled = false;
    
    final todoResult =
        await notificationRepository.getNotification(NotificationType.todo);
    todoResult.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (todoNotification) {
        isTodoNotificationEnabled = todoNotification.isEnabled && isAllNotificationEnabled;
        todoNotificationTime = todoNotification.time;
      },
    );

    TimeOfDay checkNotificationTime = const TimeOfDay(hour: 21, minute: 0);
    bool isCheckNotificationEnabled = false;
    
    final checkResult =
        await notificationRepository.getNotification(NotificationType.check);
    checkResult.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (checkNotification) {
        isCheckNotificationEnabled = checkNotification.isEnabled && isAllNotificationEnabled;
        checkNotificationTime = checkNotification.time;
      },
    );

    return SettingStateModel(
      isAllNotificationEnabled: isAllNotificationEnabled,
      isTodoNotificationEnabled: isTodoNotificationEnabled,
      isCheckNotificationEnabled: isCheckNotificationEnabled,
      todoNotificationTime: todoNotificationTime,
      checkNotificationTime: checkNotificationTime,
      hasNotificationPermission: true,
    );
  }

  // 알림 설정 화면으로 이동
  Future<void> openNotificationSettings() async {
    await _notificationService.openNotificationSettings();
  }

  // 알림 권한 확인
  Future<bool> checkNotificationPermission() async {
    return await _notificationService.checkNotificationPermission();
  }

  // 전체 알림 토글 (개선된 버전)
  Future<void> toggleAllNotifications(bool isEnabled) async {
    // 권한 확인
    final hasPermission = await checkNotificationPermission();
    if (!hasPermission && isEnabled) {
      // 권한이 없는데 활성화하려고 하면 상태는 변경하지 않고 false 반환
      return;
    }

    final settingRepository = await ref.watch(settingRepositoryProvider.future);
    final notificationRepository = await ref.watch(notificationRepositoryProvider.future);
    
    // 전체 설정 저장
    final res = await settingRepository.setSettingState(isEnabled);
    
    res.fold(
      (failure) => _setError(failure.message),
      (_) async {
        // 전체 알림이 꺼지면 모든 하위 알림도 꺼짐
        if (!isEnabled) {
          // TODO 알림 비활성화
          await _toggleNotification(
            NotificationType.todo,
            false,
            state.value!.todoNotificationTime,
            (s) => s.copyWith(
              isAllNotificationEnabled: false,
              isTodoNotificationEnabled: false,
            ),
            notificationRepository,
            settingRepository,
          );
          
          // CHECK 알림 비활성화
          await _toggleNotification(
            NotificationType.check,
            false,
            state.value!.checkNotificationTime,
            (s) => s.copyWith(
              isAllNotificationEnabled: false,
              isCheckNotificationEnabled: false,
            ),
            notificationRepository,
            settingRepository,
          );
        } else {
          // 전체 알림 활성화 시 하위 알림도 같이 활성화
          await _toggleNotification(
            NotificationType.todo,
            true,
            state.value!.todoNotificationTime,
            (s) => s.copyWith(
              isAllNotificationEnabled: true,
              isTodoNotificationEnabled: true,
            ),
            notificationRepository,
            settingRepository,
          );
          
          await _toggleNotification(
            NotificationType.check,
            true,
            state.value!.checkNotificationTime,
            (s) => s.copyWith(
              isAllNotificationEnabled: true,
              isCheckNotificationEnabled: true,
            ),
            notificationRepository,
            settingRepository,
          );
        }
      },
    );
  }

  // TODO 알림 토글 (개선된 버전)
  Future<bool> toggleTodoNotification(bool isEnabled) async {
    // 권한 확인
    final hasPermission = await checkNotificationPermission();
    if (!hasPermission && isEnabled) {
      return false; // 권한 없이 활성화 시도는 실패
    }

    final notificationRepository =
        await ref.watch(notificationRepositoryProvider.future);
    final settingRepository = await ref.watch(settingRepositoryProvider.future);
    
    await _toggleNotification(
      NotificationType.todo,
      isEnabled,
      state.value!.todoNotificationTime,
      (updatedState) =>
          updatedState.copyWith(isTodoNotificationEnabled: isEnabled),
      notificationRepository,
      settingRepository,
    );
    
    return true;
  }

  // CHECK 알림 토글 (개선된 버전)
  Future<bool> toggleCheckNotification(bool isEnabled) async {
    // 권한 확인
    final hasPermission = await checkNotificationPermission();
    if (!hasPermission && isEnabled) {
      return false; // 권한 없이 활성화 시도는 실패
    }

    final notificationRepository =
        await ref.watch(notificationRepositoryProvider.future);
    final settingRepository = await ref.watch(settingRepositoryProvider.future);
    
    await _toggleNotification(
      NotificationType.check,
      isEnabled,
      state.value!.checkNotificationTime,
      (updatedState) =>
          updatedState.copyWith(isCheckNotificationEnabled: isEnabled),
      notificationRepository,
      settingRepository,
    );
    
    return true;
  }

  Future<void> _toggleNotification(
    NotificationType type,
    bool isEnabled,
    TimeOfDay time,
    SettingStateModel Function(SettingStateModel) updateState,
    NotificationRepository notificationRepository,
    SettingRepository settingRepository,
  ) async {
    final res = await notificationRepository.setNotification(
      type,
      NotificationModel(isEnabled: isEnabled, time: time),
    );

    res.fold(
      (failure) => _setError(failure.message),
      (_) => _setState(updateState(state.value!)),
    );
  }

  Future<void> updateTodoNotificationTime(TimeOfDay time) async {
    final notificationRepository =
        await ref.watch(notificationRepositoryProvider.future);
    final settingRepository = await ref.watch(settingRepositoryProvider.future);
    await _updateNotificationTime(
      NotificationType.todo,
      time,
      (updatedState) => updatedState.copyWith(todoNotificationTime: time),
      notificationRepository,
      settingRepository,
    );
  }

  Future<void> updateCheckNotificationTime(TimeOfDay time) async {
    final notificationRepository =
        await ref.watch(notificationRepositoryProvider.future);
    final settingRepository = await ref.watch(settingRepositoryProvider.future);
    await _updateNotificationTime(
      NotificationType.check,
      time,
      (updatedState) => updatedState.copyWith(checkNotificationTime: time),
      notificationRepository,
      settingRepository,
    );
  }

  Future<void> _updateNotificationTime(
    NotificationType type,
    TimeOfDay time,
    SettingStateModel Function(SettingStateModel) updateState,
    NotificationRepository notificationRepository,
    SettingRepository settingRepository,
  ) async {
    final res = await notificationRepository.setNotification(
      type,
      NotificationModel(
        isEnabled: type == NotificationType.todo
            ? state.value!.isTodoNotificationEnabled
            : state.value!.isCheckNotificationEnabled,
        time: time,
      ),
    );

    res.fold(
      (failure) => _setError(failure.message),
      (_) => _setState(updateState(state.value!)),
    );
  }

  void _setState(SettingStateModel newState) {
    state = AsyncValue.data(newState);
  }

  void _setError(String message) {
    state = AsyncValue.error(message, StackTrace.current);
  }
}
