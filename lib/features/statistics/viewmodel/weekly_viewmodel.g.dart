// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$thisWeekStatisticsHash() =>
    r'5d00bff1b27c639f3f93121dc2fcb2e5422c0ffe';

/// 이번 주 데이터를 제공하는 Provider
///
/// Copied from [thisWeekStatistics].
@ProviderFor(thisWeekStatistics)
final thisWeekStatisticsProvider =
    AutoDisposeFutureProvider<WeeklyStatisticsData>.internal(
  thisWeekStatistics,
  name: r'thisWeekStatisticsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$thisWeekStatisticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ThisWeekStatisticsRef
    = AutoDisposeFutureProviderRef<WeeklyStatisticsData>;
String _$weeklyStatisticsHash() => r'a1788aa545b46e8ae4ab847f6d34de35551b87f2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// 특정 주차 데이터를 제공하는 Provider
///
/// Copied from [weeklyStatistics].
@ProviderFor(weeklyStatistics)
const weeklyStatisticsProvider = WeeklyStatisticsFamily();

/// 특정 주차 데이터를 제공하는 Provider
///
/// Copied from [weeklyStatistics].
class WeeklyStatisticsFamily extends Family<AsyncValue<WeeklyStatisticsData>> {
  /// 특정 주차 데이터를 제공하는 Provider
  ///
  /// Copied from [weeklyStatistics].
  const WeeklyStatisticsFamily();

  /// 특정 주차 데이터를 제공하는 Provider
  ///
  /// Copied from [weeklyStatistics].
  WeeklyStatisticsProvider call({
    required DateTime baseDate,
  }) {
    return WeeklyStatisticsProvider(
      baseDate: baseDate,
    );
  }

  @override
  WeeklyStatisticsProvider getProviderOverride(
    covariant WeeklyStatisticsProvider provider,
  ) {
    return call(
      baseDate: provider.baseDate,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'weeklyStatisticsProvider';
}

/// 특정 주차 데이터를 제공하는 Provider
///
/// Copied from [weeklyStatistics].
class WeeklyStatisticsProvider
    extends AutoDisposeFutureProvider<WeeklyStatisticsData> {
  /// 특정 주차 데이터를 제공하는 Provider
  ///
  /// Copied from [weeklyStatistics].
  WeeklyStatisticsProvider({
    required DateTime baseDate,
  }) : this._internal(
          (ref) => weeklyStatistics(
            ref as WeeklyStatisticsRef,
            baseDate: baseDate,
          ),
          from: weeklyStatisticsProvider,
          name: r'weeklyStatisticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$weeklyStatisticsHash,
          dependencies: WeeklyStatisticsFamily._dependencies,
          allTransitiveDependencies:
              WeeklyStatisticsFamily._allTransitiveDependencies,
          baseDate: baseDate,
        );

  WeeklyStatisticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.baseDate,
  }) : super.internal();

  final DateTime baseDate;

  @override
  Override overrideWith(
    FutureOr<WeeklyStatisticsData> Function(WeeklyStatisticsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeeklyStatisticsProvider._internal(
        (ref) => create(ref as WeeklyStatisticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        baseDate: baseDate,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<WeeklyStatisticsData> createElement() {
    return _WeeklyStatisticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyStatisticsProvider && other.baseDate == baseDate;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, baseDate.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin WeeklyStatisticsRef
    on AutoDisposeFutureProviderRef<WeeklyStatisticsData> {
  /// The parameter `baseDate` of this provider.
  DateTime get baseDate;
}

class _WeeklyStatisticsProviderElement
    extends AutoDisposeFutureProviderElement<WeeklyStatisticsData>
    with WeeklyStatisticsRef {
  _WeeklyStatisticsProviderElement(super.provider);

  @override
  DateTime get baseDate => (origin as WeeklyStatisticsProvider).baseDate;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
