// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$monthlyStatisticsHash() => r'442f1ef811996dd0af81c87459b89583088c2a13';

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

/// 월간 통계 데이터를 제공하는 Provider
///
/// Copied from [monthlyStatistics].
@ProviderFor(monthlyStatistics)
const monthlyStatisticsProvider = MonthlyStatisticsFamily();

/// 월간 통계 데이터를 제공하는 Provider
///
/// Copied from [monthlyStatistics].
class MonthlyStatisticsFamily
    extends Family<AsyncValue<MonthlyStatisticsData>> {
  /// 월간 통계 데이터를 제공하는 Provider
  ///
  /// Copied from [monthlyStatistics].
  const MonthlyStatisticsFamily();

  /// 월간 통계 데이터를 제공하는 Provider
  ///
  /// Copied from [monthlyStatistics].
  MonthlyStatisticsProvider call({
    required int year,
    required int month,
  }) {
    return MonthlyStatisticsProvider(
      year: year,
      month: month,
    );
  }

  @override
  MonthlyStatisticsProvider getProviderOverride(
    covariant MonthlyStatisticsProvider provider,
  ) {
    return call(
      year: provider.year,
      month: provider.month,
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
  String? get name => r'monthlyStatisticsProvider';
}

/// 월간 통계 데이터를 제공하는 Provider
///
/// Copied from [monthlyStatistics].
class MonthlyStatisticsProvider
    extends AutoDisposeFutureProvider<MonthlyStatisticsData> {
  /// 월간 통계 데이터를 제공하는 Provider
  ///
  /// Copied from [monthlyStatistics].
  MonthlyStatisticsProvider({
    required int year,
    required int month,
  }) : this._internal(
          (ref) => monthlyStatistics(
            ref as MonthlyStatisticsRef,
            year: year,
            month: month,
          ),
          from: monthlyStatisticsProvider,
          name: r'monthlyStatisticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$monthlyStatisticsHash,
          dependencies: MonthlyStatisticsFamily._dependencies,
          allTransitiveDependencies:
              MonthlyStatisticsFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  MonthlyStatisticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<MonthlyStatisticsData> Function(MonthlyStatisticsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyStatisticsProvider._internal(
        (ref) => create(ref as MonthlyStatisticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<MonthlyStatisticsData> createElement() {
    return _MonthlyStatisticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyStatisticsProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyStatisticsRef
    on AutoDisposeFutureProviderRef<MonthlyStatisticsData> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthlyStatisticsProviderElement
    extends AutoDisposeFutureProviderElement<MonthlyStatisticsData>
    with MonthlyStatisticsRef {
  _MonthlyStatisticsProviderElement(super.provider);

  @override
  int get year => (origin as MonthlyStatisticsProvider).year;
  @override
  int get month => (origin as MonthlyStatisticsProvider).month;
}

String _$dailyStatisticsHash() => r'abea66a6d11ca203cac8ff224766ca98f652b41c';

/// 월간 특정 날짜 통계 데이터 제공 Provider
///
/// Copied from [dailyStatistics].
@ProviderFor(dailyStatistics)
const dailyStatisticsProvider = DailyStatisticsFamily();

/// 월간 특정 날짜 통계 데이터 제공 Provider
///
/// Copied from [dailyStatistics].
class DailyStatisticsFamily extends Family<AsyncValue<TodosByDateModel?>> {
  /// 월간 특정 날짜 통계 데이터 제공 Provider
  ///
  /// Copied from [dailyStatistics].
  const DailyStatisticsFamily();

  /// 월간 특정 날짜 통계 데이터 제공 Provider
  ///
  /// Copied from [dailyStatistics].
  DailyStatisticsProvider call({
    required DateTime date,
  }) {
    return DailyStatisticsProvider(
      date: date,
    );
  }

  @override
  DailyStatisticsProvider getProviderOverride(
    covariant DailyStatisticsProvider provider,
  ) {
    return call(
      date: provider.date,
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
  String? get name => r'dailyStatisticsProvider';
}

/// 월간 특정 날짜 통계 데이터 제공 Provider
///
/// Copied from [dailyStatistics].
class DailyStatisticsProvider
    extends AutoDisposeFutureProvider<TodosByDateModel?> {
  /// 월간 특정 날짜 통계 데이터 제공 Provider
  ///
  /// Copied from [dailyStatistics].
  DailyStatisticsProvider({
    required DateTime date,
  }) : this._internal(
          (ref) => dailyStatistics(
            ref as DailyStatisticsRef,
            date: date,
          ),
          from: dailyStatisticsProvider,
          name: r'dailyStatisticsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$dailyStatisticsHash,
          dependencies: DailyStatisticsFamily._dependencies,
          allTransitiveDependencies:
              DailyStatisticsFamily._allTransitiveDependencies,
          date: date,
        );

  DailyStatisticsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<TodosByDateModel?> Function(DailyStatisticsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyStatisticsProvider._internal(
        (ref) => create(ref as DailyStatisticsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<TodosByDateModel?> createElement() {
    return _DailyStatisticsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyStatisticsProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DailyStatisticsRef on AutoDisposeFutureProviderRef<TodosByDateModel?> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _DailyStatisticsProviderElement
    extends AutoDisposeFutureProviderElement<TodosByDateModel?>
    with DailyStatisticsRef {
  _DailyStatisticsProviderElement(super.provider);

  @override
  DateTime get date => (origin as DailyStatisticsProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
