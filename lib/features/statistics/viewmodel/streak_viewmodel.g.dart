// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streakViewModelHash() => r'3bf9349bd8b5eea600481c3087d42cc1b416d700';

/// StreakViewModel:
/// - build()에서 StreakRepository를 호출해 currentStreak와 maxStreak를 가져온 뒤 상태에 반영
///
/// Copied from [StreakViewModel].
@ProviderFor(StreakViewModel)
final streakViewModelProvider = AutoDisposeAsyncNotifierProvider<
    StreakViewModel, Map<String, int>>.internal(
  StreakViewModel.new,
  name: r'streakViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streakViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StreakViewModel = AutoDisposeAsyncNotifier<Map<String, int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
