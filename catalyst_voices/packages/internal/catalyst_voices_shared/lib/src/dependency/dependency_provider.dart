import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

abstract class DependencyProvider {
  static final _getIt = GetIt.instance;
  static DependencyProvider? _instance;

  /// A static instance of [DependencyProvider] that helps
  /// to access dependencies in static contexts.
  static DependencyProvider get instance {
    assert(
      _instance != null,
      'Ensure that an instance of DependencyProvider is set before using it.',
    );

    return _instance!;
  }

  /// Sets an instance of [DependencyProvider].
  ///
  /// Must be called before the instance could be accessed.
  static set instance(DependencyProvider instance) {
    _instance = instance;
  }

  Future<void> get reset => _getIt.reset();

  @protected
  Future<void> allReady() {
    return _getIt.allReady();
  }

  T get<T extends Object>() => _getIt.get<T>();

  Future<T> getAsync<T extends Object>() => _getIt.getAsync<T>();

  T getWithParam<T extends Object, P extends Object>({P? param}) {
    return _getIt.get<T>(param1: param);
  }

  @protected
  void registerFactory<T extends Object>(ValueGetter<T> factoryFunc) {
    _getIt.registerFactory(factoryFunc);
  }

  @protected
  void registerLazySingleton<T extends Object>(
    ValueGetter<T> factoryFunc, {
    DisposingFunc<T>? dispose,
  }) {
    _getIt.registerLazySingleton(
      factoryFunc,
      dispose: dispose,
    );
  }

  @protected
  void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton(instance);
  }

  @protected
  void registerSingletonAsync<T extends Object>(
    ValueGetter<Future<T>> factoryFunc, {
    Iterable<Type>? dependsOn,
  }) {
    _getIt.registerSingletonAsync(
      factoryFunc,
      dependsOn: dependsOn,
    );
  }

  @protected
  void registerSingletonWithDependencies<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    required List<Type> dependsOn,
  }) {
    _getIt.registerSingletonWithDependencies(
      factoryFunc,
      dependsOn: dependsOn,
    );
  }
}
