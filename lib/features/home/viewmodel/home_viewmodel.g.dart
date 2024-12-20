// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getTodosHash() => r'f819c2ebf300e467014dbf1eb2722d19cc758f39';

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

/// See also [getTodos].
@ProviderFor(getTodos)
const getTodosProvider = GetTodosFamily();

/// See also [getTodos].
class GetTodosFamily extends Family<AsyncValue<TodosByDateModel>> {
  /// See also [getTodos].
  const GetTodosFamily();

  /// See also [getTodos].
  GetTodosProvider call(
    DateTime date,
  ) {
    return GetTodosProvider(
      date,
    );
  }

  @override
  GetTodosProvider getProviderOverride(
    covariant GetTodosProvider provider,
  ) {
    return call(
      provider.date,
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
  String? get name => r'getTodosProvider';
}

/// See also [getTodos].
class GetTodosProvider extends AutoDisposeFutureProvider<TodosByDateModel> {
  /// See also [getTodos].
  GetTodosProvider(
    DateTime date,
  ) : this._internal(
          (ref) => getTodos(
            ref as GetTodosRef,
            date,
          ),
          from: getTodosProvider,
          name: r'getTodosProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getTodosHash,
          dependencies: GetTodosFamily._dependencies,
          allTransitiveDependencies: GetTodosFamily._allTransitiveDependencies,
          date: date,
        );

  GetTodosProvider._internal(
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
    FutureOr<TodosByDateModel> Function(GetTodosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetTodosProvider._internal(
        (ref) => create(ref as GetTodosRef),
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
  AutoDisposeFutureProviderElement<TodosByDateModel> createElement() {
    return _GetTodosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetTodosProvider && other.date == date;
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
mixin GetTodosRef on AutoDisposeFutureProviderRef<TodosByDateModel> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _GetTodosProviderElement
    extends AutoDisposeFutureProviderElement<TodosByDateModel>
    with GetTodosRef {
  _GetTodosProviderElement(super.provider);

  @override
  DateTime get date => (origin as GetTodosProvider).date;
}

String _$getMonthTodosHash() => r'aa2d61cdb86ca73c0c8f6b43b5f7e0a9dc356d45';

/// See also [getMonthTodos].
@ProviderFor(getMonthTodos)
const getMonthTodosProvider = GetMonthTodosFamily();

/// See also [getMonthTodos].
class GetMonthTodosFamily extends Family<AsyncValue<TodosByMonthModel>> {
  /// See also [getMonthTodos].
  const GetMonthTodosFamily();

  /// See also [getMonthTodos].
  GetMonthTodosProvider call(
    int year,
    int month,
  ) {
    return GetMonthTodosProvider(
      year,
      month,
    );
  }

  @override
  GetMonthTodosProvider getProviderOverride(
    covariant GetMonthTodosProvider provider,
  ) {
    return call(
      provider.year,
      provider.month,
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
  String? get name => r'getMonthTodosProvider';
}

/// See also [getMonthTodos].
class GetMonthTodosProvider
    extends AutoDisposeFutureProvider<TodosByMonthModel> {
  /// See also [getMonthTodos].
  GetMonthTodosProvider(
    int year,
    int month,
  ) : this._internal(
          (ref) => getMonthTodos(
            ref as GetMonthTodosRef,
            year,
            month,
          ),
          from: getMonthTodosProvider,
          name: r'getMonthTodosProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getMonthTodosHash,
          dependencies: GetMonthTodosFamily._dependencies,
          allTransitiveDependencies:
              GetMonthTodosFamily._allTransitiveDependencies,
          year: year,
          month: month,
        );

  GetMonthTodosProvider._internal(
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
    FutureOr<TodosByMonthModel> Function(GetMonthTodosRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetMonthTodosProvider._internal(
        (ref) => create(ref as GetMonthTodosRef),
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
  AutoDisposeFutureProviderElement<TodosByMonthModel> createElement() {
    return _GetMonthTodosProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetMonthTodosProvider &&
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
mixin GetMonthTodosRef on AutoDisposeFutureProviderRef<TodosByMonthModel> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _GetMonthTodosProviderElement
    extends AutoDisposeFutureProviderElement<TodosByMonthModel>
    with GetMonthTodosRef {
  _GetMonthTodosProviderElement(super.provider);

  @override
  int get year => (origin as GetMonthTodosProvider).year;
  @override
  int get month => (origin as GetMonthTodosProvider).month;
}

String _$homeViewModelHash() => r'68bc8c74f7233d431c4172cf49642ac16503d628';

/// See also [HomeViewModel].
@ProviderFor(HomeViewModel)
final homeViewModelProvider =
    AutoDisposeAsyncNotifierProvider<HomeViewModel, TodosByDateModel>.internal(
  HomeViewModel.new,
  name: r'homeViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewModel = AutoDisposeAsyncNotifier<TodosByDateModel>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
