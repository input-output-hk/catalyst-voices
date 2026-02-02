---
    title: 0022 Dependency Injection Strategy
    adr:
        author: Catalyst Engineering Team
        created: 15-Jan-2024
        status: accepted
    tags:
        - flutter
        - dependency-injection
        - frontend
---

## Context

The Catalyst Voices frontend application requires a dependency injection solution that:

* Supports constructor injection
* Enables testability by allowing mock dependencies
* Provides clear dependency registration
* Works across all Flutter platforms
* Supports both singleton and factory patterns
* Allows for lazy initialization

We evaluated several DI approaches:

* Manual constructor injection without a framework
* GetIt service locator
* Injectable (code generation)
* Riverpod (state management with DI)
* Provider (Flutter's built-in)

## Decision

We use **GetIt** as a service locator with a **DependencyProvider** abstraction layer for manual dependency injection.
Dependencies are registered manually in a centralized `Dependencies` class using constructor injection.

Key aspects:

1. **Service Locator Pattern**: GetIt provides the underlying service locator
2. **Abstraction Layer**: `DependencyProvider` abstracts GetIt for better testability
3. **Manual Registration**: All dependencies registered in `Dependencies` class
4. **Constructor Injection**: Dependencies passed via constructors
5. **Registration Patterns**: Support for singletons, lazy singletons, and factories

## Implementation Details

### DependencyProvider Abstraction

```dart
abstract class DependencyProvider {
  static DependencyProvider get instance;

  T get<T extends Object>();
  void registerSingleton<T extends Object>(T instance);
  void registerLazySingleton<T extends Object>(ValueGetter<T> factoryFunc);
  void registerFactory<T extends Object>(ValueGetter<T> factoryFunc);
}
```

### Dependencies Registration

```dart
final class Dependencies extends DependencyProvider {
  static final Dependencies instance = Dependencies._();

  Future<void> init({...}) async {
    DependencyProvider.instance = this;

    _registerStorages();
    _registerNetwork();
    _registerRepositories();
    _registerServices();
    _registerBlocsWithDependencies();
  }

  void _registerServices() {
    registerLazySingleton<ProposalService>(() {
      return ProposalService(
        get<ProposalRepository>(),
        get<DocumentRepository>(),
        get<UserService>(),
        // ... other dependencies
      );
    });
  }
}
```

### Usage in BLoCs

```dart
// Factory registration for BLoCs
registerFactory<ProposalsCubit>(() {
  return ProposalsCubit(
    get<UserService>(),
    get<CampaignService>(),
    get<ProposalService>(),
  );
});

// Usage in widgets
final cubit = context.read<ProposalsCubit>();
```

## Alternatives Considered

### Injectable (Code Generation)

* **Pros**: Less boilerplate, compile-time safety
* **Cons**: Code generation step, less explicit, harder to debug
* **Rejected**: Manual registration provides better visibility and control

### Riverpod

* **Pros**: Excellent DI with state management
* **Cons**: Different paradigm, migration cost, overkill for DI-only needs
* **Rejected**: BLoC already established, migration not justified

### Provider

* **Pros**: Built into Flutter, simple
* **Cons**: Widget tree coupling, less flexible
* **Rejected**: Service locator pattern provides better separation

### Pure Manual DI (No Framework)

* **Pros**: No dependencies, full control
* **Cons**: More boilerplate, manual lifecycle management
* **Rejected**: GetIt provides good balance of control and convenience

## Consequences

### Positive

* Clear dependency registration in one place
* Easy to test with mock dependencies
* Constructor injection ensures dependencies are explicit
* Service locator pattern enables static access when needed
* Abstraction layer allows swapping implementations

### Negative

* Manual registration requires maintenance
* Service locator can hide dependencies (mitigated by constructor injection)
* GetIt dependency adds to project dependencies

### Best Practices

* Always use constructor injection
* Register dependencies in logical groups (storages, services, repositories, BLoCs)
* Use factories for BLoCs (new instance per use)
* Use lazy singletons for services and repositories
* Use singletons for configuration and infrastructure
* Provide dispose functions for resources that need cleanup
