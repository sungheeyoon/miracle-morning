// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardStatisticsHash() =>
    r'5b5ec5e922915e530708c79a3baee7aa1b9fe08e';

/// 대시보드 통계 데이터를 제공하는 Provider
///
/// Copied from [dashboardStatistics].
@ProviderFor(dashboardStatistics)
final dashboardStatisticsProvider =
    AutoDisposeFutureProvider<DashboardStatisticsData>.internal(
  dashboardStatistics,
  name: r'dashboardStatisticsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dashboardStatisticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardStatisticsRef
    = AutoDisposeFutureProviderRef<DashboardStatisticsData>;
String _$thisWeekSummaryHash() => r'37cf42fa31efa6257147385bc30d01bbfbebb49b';

/// 이번 주 요약 통계
///
/// Copied from [thisWeekSummary].
@ProviderFor(thisWeekSummary)
final thisWeekSummaryProvider =
    AutoDisposeFutureProvider<SummaryStatistics>.internal(
  thisWeekSummary,
  name: r'thisWeekSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$thisWeekSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThisWeekSummaryRef = AutoDisposeFutureProviderRef<SummaryStatistics>;
String _$thisMonthSummaryHash() => r'62035dc5dcf520d82917d06a64dd3f1aecff68af';

/// 이번 달 요약 통계
///
/// Copied from [thisMonthSummary].
@ProviderFor(thisMonthSummary)
final thisMonthSummaryProvider =
    AutoDisposeFutureProvider<SummaryStatistics>.internal(
  thisMonthSummary,
  name: r'thisMonthSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$thisMonthSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThisMonthSummaryRef = AutoDisposeFutureProviderRef<SummaryStatistics>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
