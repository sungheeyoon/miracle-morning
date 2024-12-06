import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:miracle_morning/core/failure/failure.dart';
import 'package:miracle_morning/features/setting/models/notification_model.dart';
import 'package:miracle_morning/features/setting/repositories/notification_repository.dart';
import 'package:miracle_morning/features/setting/repositories/setting_repository.dart';
import 'package:miracle_morning/features/setting/models/setting_state_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'setting_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class SettingViewModel extends _$SettingViewModel {
  late final NotificationRepository _notificationRepository;
  late final SettingRepository _settingRepository;

  @override
  Future<SettingStateModel> build() async {
    _notificationRepository = ref.watch(notificationRepositoryProvider);
    _settingRepository = ref.watch(settingRepositoryProvider);

    final initResult = await _initializeRepositories();

    // 초기화 실패 시
    if (initResult.isLeft()) {
      final failure = initResult.getLeft().toNullable();
      _setError(failure?.message ?? 'Repository initialization failed');
      throw Exception(failure?.message); // 실행 흐름 중단
    }

    return _initialize();
  }

  /// 레포지토리 초기화
  Future<Either<AppFailure, Unit>> _initializeRepositories() async {
    final notificationInit = await _notificationRepository.init();
    final settingInit = await _settingRepository.init();

    if (notificationInit.isLeft() || settingInit.isLeft()) {
      return Left(AppFailure('Repository initialization failed'));
    }

    return const Right(unit);
  }

  /// 초기 상태 로드
  Future<SettingStateModel> _initialize() async {
    bool isAllNotificationEnabled = false;

    // 전역 알림 상태 로드
    final globalStateResult =
        await _settingRepository.getGlobalNotificationState();
    globalStateResult.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (state) => isAllNotificationEnabled = state,
    );

    // TODO 알림 로드
    bool isTodoNotificationEnabled = isAllNotificationEnabled;
    TimeOfDay todoNotificationTime = const TimeOfDay(hour: 8, minute: 0);
    final todoResult =
        await _notificationRepository.getNotification(NotificationType.todo);
    todoResult.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (todoNotification) {
        isTodoNotificationEnabled = todoNotification.isEnabled;
        todoNotificationTime = todoNotification.time;
      },
    );

    // CHECK 알림 로드
    bool isCheckNotificationEnabled = isAllNotificationEnabled;
    TimeOfDay checkNotificationTime = const TimeOfDay(hour: 21, minute: 0);
    final checkResult =
        await _notificationRepository.getNotification(NotificationType.check);
    checkResult.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (checkNotification) {
        isCheckNotificationEnabled = checkNotification.isEnabled;
        checkNotificationTime = checkNotification.time;
      },
    );

    return SettingStateModel(
      isAllNotificationEnabled: isAllNotificationEnabled,
      isTodoNotificationEnabled: isTodoNotificationEnabled,
      isCheckNotificationEnabled: isCheckNotificationEnabled,
      todoNotificationTime: todoNotificationTime,
      checkNotificationTime: checkNotificationTime,
    );
  }

  /// 전역 알림 토글
  Future<void> toggleAllNotifications(bool isEnabled) async {
    final res = await _settingRepository.setGlobalNotificationState(isEnabled);
    res.fold(
      (failure) => _setError(failure.message),
      (_) {
        _setState(state.value!.copyWith(isAllNotificationEnabled: isEnabled));
      },
    );
  }

  /// TODO 알림 토글
  Future<void> toggleTodoNotification(bool isEnabled) async {
    await _toggleNotification(
      NotificationType.todo,
      isEnabled,
      state.value!.todoNotificationTime,
      (updatedState) =>
          updatedState.copyWith(isTodoNotificationEnabled: isEnabled),
    );
  }

  /// CHECK 알림 토글
  Future<void> toggleCheckNotification(bool isEnabled) async {
    await _toggleNotification(
      NotificationType.check,
      isEnabled,
      state.value!.checkNotificationTime,
      (updatedState) =>
          updatedState.copyWith(isCheckNotificationEnabled: isEnabled),
    );
  }

  /// 알림 토글 로직
  Future<void> _toggleNotification(
    NotificationType type,
    bool isEnabled,
    TimeOfDay time,
    SettingStateModel Function(SettingStateModel) updateState,
  ) async {
    final res = await _notificationRepository.setNotification(
      type,
      NotificationModel(isEnabled: isEnabled, time: time),
    );

    res.fold(
      (failure) => _setError(failure.message),
      (_) => _setState(updateState(state.value!)),
    );
  }

  /// TODO 알림 시간 업데이트
  Future<void> updateTodoNotificationTime(TimeOfDay time) async {
    await _updateNotificationTime(
      NotificationType.todo,
      time,
      (updatedState) => updatedState.copyWith(todoNotificationTime: time),
    );
  }

  /// CHECK 알림 시간 업데이트
  Future<void> updateCheckNotificationTime(TimeOfDay time) async {
    await _updateNotificationTime(
      NotificationType.check,
      time,
      (updatedState) => updatedState.copyWith(checkNotificationTime: time),
    );
  }

  /// 알림 시간 업데이트 로직
  Future<void> _updateNotificationTime(
    NotificationType type,
    TimeOfDay time,
    SettingStateModel Function(SettingStateModel) updateState,
  ) async {
    final res = await _notificationRepository.setNotification(
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

  /// 상태 변경
  void _setState(SettingStateModel newState) {
    state = AsyncValue.data(newState);
  }

  /// 에러 설정
  void _setError(String message) {
    state = AsyncValue.error(message, StackTrace.current);
  }

  /// 현재 상태 및 Hive Box 데이터 출력
  Future<void> _printCurrentState(
    NotificationRepository notificationRepository,
    SettingRepository settingRepository,
  ) async {
    final todoNotification =
        await notificationRepository.getNotification(NotificationType.todo);
    final checkNotification =
        await notificationRepository.getNotification(NotificationType.check);
    final globalState = await settingRepository.getGlobalNotificationState();

    print('--- Current State ---');
    print(state.value);

    print('--- Hive Data ---');
    todoNotification.fold(
      (failure) => print('TODO Notification Error: ${failure.message}'),
      (data) => print('TODO Notification: $data'),
    );
    checkNotification.fold(
      (failure) => print('CHECK Notification Error: ${failure.message}'),
      (data) => print('CHECK Notification: $data'),
    );
    globalState.fold(
      (failure) => print('Global State Error: ${failure.message}'),
      (data) => print('Global Notification State: $data'),
    );
  }
}
