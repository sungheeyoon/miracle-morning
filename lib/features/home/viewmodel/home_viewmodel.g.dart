// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAllTodosHash() => r'8674fae2af99a5d4c6043964cfad6124ea73c290';

/// See also [getAllTodos].
@ProviderFor(getAllTodos)
final getAllTodosProvider = AutoDisposeFutureProvider<List<TodoModel>>.internal(
  getAllTodos,
  name: r'getAllTodosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getAllTodosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAllTodosRef = AutoDisposeFutureProviderRef<List<TodoModel>>;
String _$homeViewModelHash() => r'c83862967a5aa0f5cce67c0e49b46661c63d0825';

/// See also [HomeViewModel].
@ProviderFor(HomeViewModel)
final homeViewModelProvider = AutoDisposeNotifierProvider<HomeViewModel,
    AsyncValue<List<TodoModel>>>.internal(
  HomeViewModel.new,
  name: r'homeViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewModel = AutoDisposeNotifier<AsyncValue<List<TodoModel>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
