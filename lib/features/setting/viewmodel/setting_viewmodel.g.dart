// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$notificationPermissionHash() =>
    r'bc80ef8322955fd4347614ed4b5250f7ea3c0557';

/// See also [notificationPermission].
@ProviderFor(notificationPermission)
final notificationPermissionProvider = AutoDisposeFutureProvider<bool>.internal(
  notificationPermission,
  name: r'notificationPermissionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$notificationPermissionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NotificationPermissionRef = AutoDisposeFutureProviderRef<bool>;
String _$settingViewModelHash() => r'abb95a730eda8619dd4053a403d7a005ba06c9c9';

/// See also [SettingViewModel].
@ProviderFor(SettingViewModel)
final settingViewModelProvider = AutoDisposeAsyncNotifierProvider<
    SettingViewModel, SettingStateModel>.internal(
  SettingViewModel.new,
  name: r'settingViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$settingViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SettingViewModel = AutoDisposeAsyncNotifier<SettingStateModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
