// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'growth_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streakDataHash() => r'30e088a561d02babcf687754196fe5c14365217c';

/// 스트릭 데이터 Provider (비동기)
///
/// Copied from [streakData].
@ProviderFor(streakData)
final streakDataProvider = AutoDisposeFutureProvider<StreakData>.internal(
  streakData,
  name: r'streakDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$streakDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StreakDataRef = AutoDisposeFutureProviderRef<StreakData>;
String _$growthViewModelHash() => r'2556c9d0cc43f152e307aaeb4c373ea4bb9dc726';

/// 성장 정보를 관리하는 ViewModel
///
/// Copied from [GrowthViewModel].
@ProviderFor(GrowthViewModel)
final growthViewModelProvider =
    AutoDisposeNotifierProvider<GrowthViewModel, GrowthState>.internal(
  GrowthViewModel.new,
  name: r'growthViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$growthViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GrowthViewModel = AutoDisposeNotifier<GrowthState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
