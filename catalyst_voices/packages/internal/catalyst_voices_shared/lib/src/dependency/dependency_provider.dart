import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

/// A service locator implementation for accessing dependencies.
///
/// **Example usage:**
/// ```dart
/// DependencyProvider.instance.get<MyDependency>();
/// ```
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

  /// Clears all registered types.
  Future<void> get reset => _getIt.reset();

  /// Returns true when all async dependencies are already created.
  @protected
  Future<void> allReady() {
    return _getIt.allReady();
  }

  /// Returns the dependency if it is registered.
  ///
  /// For lazy singletons the dependency is only
  /// created when accessed for the first time.
  ///
  /// The [instanceName] can be used to distinguish between
  /// dependencies if there are multiple dependencies of the same type.
  T get<T extends Object>({String? instanceName}) => _getIt.get<T>(instanceName: instanceName);

  /// Returns async dependency registered via [registerSingletonAsync].
  Future<T> getAsync<T extends Object>() => _getIt.getAsync<T>();

  /// Returns a dependency allowing the dependency's factory to
  /// make use of the [param] when constructing the dependency.
  T getWithParam<T extends Object, P extends Object>({P? param}) {
    return _getIt.get<T>(param1: param);
  }

  /// Returns true if the dependency of type [T] is already registered.
  bool isRegistered<T extends Object>() => _getIt.isRegistered<T>();

  /// Registers a new factory that builds new instance of type [T] each time a dependency is needed.
  ///
  /// Optionally if there needs to be multiple dependencies of the same type
  /// the [instanceName] can be used to distinguish them.
  @protected
  void registerFactory<T extends Object>(
    ValueGetter<T> factoryFunc, {
    String? instanceName,
  }) {
    _getIt.registerFactory(
      factoryFunc,
      instanceName: instanceName,
    );
  }

  /// Registers a new factory that builds a new instance of type [T] only once when the dependency
  /// is needed for the first time and caches the dependency for the future calls.
  ///
  /// Optionally if there needs to be multiple dependencies of the same type
  /// the [instanceName] can be used to distinguish them.
  @protected
  void registerLazySingleton<T extends Object>(
    ValueGetter<T> factoryFunc, {
    String? instanceName,
    DisposingFunc<T>? dispose,
  }) {
    _getIt.registerLazySingleton(
      factoryFunc,
      instanceName: instanceName,
      dispose: dispose,
    );
  }

  /// Registers a new instance of dependency of type [T] that will be used each time
  /// it's needed without recreating.
  ///
  /// Optionally if there needs to be multiple dependencies of the same type
  /// the [instanceName] can be used to distinguish them.
  @protected
  void registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
  }) {
    _getIt.registerSingleton(
      instance,
      instanceName: instanceName,
    );
  }

  /// Registers a new factory that builds new instance of type [T] immediately and caches it for future usages.
  /// The dependency factory is async contrary to [registerLazySingleton].
  ///
  /// Optionally if there needs to be multiple dependencies of the same type
  /// the [instanceName] can be used to distinguish them.
  @protected
  void registerSingletonAsync<T extends Object>(
    ValueGetter<Future<T>> factoryFunc, {
    String? instanceName,
    Iterable<Type>? dependsOn,
  }) {
    _getIt.registerSingletonAsync(
      factoryFunc,
      instanceName: instanceName,
      dependsOn: dependsOn,
    );
  }

  /// Registers a new factory that builds a new instance of type [T] immediately after the [dependsOn] dependencies are ready.
  ///
  /// This is useful when the [dependsOn] dependencies are async, thus by declaring
  /// on what dependencies the [factoryFunc] depends the framework will only call
  /// the factory once these dependencies are available and ready.
  ///
  /// Optionally if there needs to be multiple dependencies of the same type
  /// the [instanceName] can be used to distinguish them.
  @protected
  void registerSingletonWithDependencies<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    String? instanceName,
    required List<Type> dependsOn,
  }) {
    _getIt.registerSingletonWithDependencies(
      factoryFunc,
      instanceName: instanceName,
      dependsOn: dependsOn,
    );
  }
}
