import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

abstract class DependencyProvider {
  static final getIt = GetIt.instance;

  static Future<void> get reset => getIt.reset();

  @protected
  Future<void> allReady() {
    return getIt.allReady();
  }

  T get<T extends Object>() => getIt.get<T>();

  Future<T> getAsync<T extends Object>() => getIt.getAsync<T>();

  T getWithParam<T extends Object, P extends Object>({P? param}) {
    return getIt.get<T>(param1: param);
  }

  @protected
  void registerFactory<T extends Object>(ValueGetter<T> factoryFunc) {
    getIt.registerFactory(factoryFunc);
  }

  @protected
  void registerLazySingleton<T extends Object>(
    ValueGetter<T> factoryFunc, {
    DisposingFunc<T>? dispose,
  }) {
    getIt.registerLazySingleton(
      factoryFunc,
      dispose: dispose,
    );
  }

  @protected
  void registerSingleton<T extends Object>(T instance) {
    getIt.registerSingleton(instance);
  }

  @protected
  void registerSingletonAsync<T extends Object>(
    ValueGetter<Future<T>> factoryFunc, {
    Iterable<Type>? dependsOn,
  }) {
    getIt.registerSingletonAsync(
      factoryFunc,
      dependsOn: dependsOn,
    );
  }

  @protected
  void registerSingletonWithDependencies<T extends Object>(
    FactoryFunc<T> factoryFunc, {
    required List<Type> dependsOn,
  }) {
    getIt.registerSingletonWithDependencies(
      factoryFunc,
      dependsOn: dependsOn,
    );
  }
}
