---
icon: material/state-machine
---

# Frontend State Management

This section documents state management patterns and concepts used in the Catalyst Voices frontend
application.

## Overview

The frontend uses a combination of BLoC pattern, ViewModels, Services, Observers, and reactive
streams for state management.
This provides a clear separation of concerns and enables testable, maintainable code.

## Architecture Layers

The state management architecture consists of four main layers:

1. **Presentation Layer**: UI widgets that consume BLoC states
2. **Business Logic Layer**: BLoCs/Cubits that manage state and handle events
3. **Service Layer**: Services that merge information from different sources and handle
cross-feature communication
4. **Domain Layer**: Repositories that abstract data access

## BLoC Pattern

### BLoC vs Cubit

* **BLoC**: Use for complex state machines with multiple event types
* **Cubit**: Use for state management, not just simpler cases.
  Cubit is also handy when there is a lot of triggering of internal events of business logic,
  as methods can be private.
  In BLoC, events are public classes, and every method needs to have emitter possibilities.

### State Structure

States should be:

* Immutable
* Equatable for efficient rebuilds
* Descriptive of UI state

### Event Structure

Events should:

* Represent user actions or system events
* Be immutable
* Contain minimal data (prefer IDs over full objects)

## Service Layer Pattern

Services sit between BLoCs and repositories to merge information from different sources.
This is a common pattern where local proposals and remote proposals are merged into one stream in
ProposalService.

### Service Responsibilities

* **Data Merging**: Combine data from multiple sources (local and remote)
* **Business Logic**: Implement complex business rules
* **Cross-Feature Communication**: Coordinate between different features via observers

### Example: ProposalService

```dart
class ProposalService {
  final ProposalRepository repository;

  Stream<List<Proposal>> watchProposals() {
    // Merge local and remote proposals into one stream
    return Rx.combineLatest(
      repository.watchLocalProposals(),
      repository.watchRemoteProposals(),
      (local, remote) => _mergeProposals(local, remote),
    );
  }
}
```

## Observer Pattern for Cross-BLoC Communication

We avoid making communication directly between BLoCs as it creates a lot of coupling.
Sometimes state emission in one BLoC might be really noisy.
Instead, we make communication via the service layer using observers.

### Observers

* **UserObserver**: Tracks user state changes (e.g., StreamUserObserver)
* **ActiveCampaignObserver**: Tracks active campaign changes
* **CastedVotesObserver**: Tracks vote casting events

### How Observers Work

```dart
// Service uses observer to track state
class UserService {
  final UserObserver userObserver;

  Future<void> updateUser(User user) async {
    // Update observer, which notifies all interested services
    userObserver.user = user;
  }
}

// BLoCs listen to observers via services, not directly
class AccountCubit extends Cubit<AccountState> {
  final UserService userService;

  AccountCubit(this.userService) : super(AccountInitial()) {
    userService.watchUser.listen((user) {
      // React to user changes
      emit(AccountUpdated(user));
    });
  }
}
```

## Signal Pattern

Signals are used primarily for user event information that is not shown in UI elements directly.
For example:

* Showing success snackbars of actions
* Triggering route changes based on tab selection so the URL in the browser also updates

Signals are **not** for direct BLoC-to-BLoC communication.
They are handled in **pages**, not in other BLoCs.

### Signal Handling

```dart
// Emit signal from BLoC
class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  void _onDeleteDraft(DeleteDraftEvent event, Emitter emit) {
    // ... delete logic ...
    emitSignal(DeletedDraftWorkspaceSignal());
  }
}

// Handle signal in page (e.g., WorkspacePage.dart)
class WorkspacePage extends StatefulWidget {
  @override
  void handleSignal(WorkspaceSignal signal) {
    switch (signal) {
      case DeletedDraftWorkspaceSignal():
        _showDeleteSuccessSnackBar();
      case ImportedProposalWorkspaceSignal():
        ProposalBuilderRoute.fromRef(ref: signal.proposalRef).push(context);
      // ... other signals ...
    }
  }
}
```

### SignalHandlerStateMixin

Pages use `SignalHandlerStateMixin` to automatically subscribe to signals:

```dart
class _WorkspacePageState extends State<WorkspacePage>
    with SignalHandlerStateMixin<WorkspaceBloc, WorkspaceSignal, WorkspacePage> {
  // Automatically subscribes to signal stream
  // Calls handleSignal when signals are emitted
}
```

## ViewModel Pattern

ViewModels transform BLoC state into UI-specific data:

* Format data for display
* Handle UI-specific logic
* Abstract presentation concerns from BLoCs

## Repository Pattern

Repositories abstract data sources:

* Single source of truth for data
* Abstract API and local storage
* Enable offline-first architecture

## Best Practices

1. **One BLoC per feature domain**: Keep BLoCs focused on a single feature
2. **Service layer for data merging**: Use services to combine data from multiple sources
3. **Observer pattern for cross-feature communication**: Avoid direct BLoC-to-BLoC communication
4. **Signals for user events**: Use signals for user-facing events, handle in pages
5. **Repository abstraction**: BLoCs interact with services, services with repositories
6. **Error handling**: Use error states in BLoCs for error handling
7. **Private methods in Cubits**: Use Cubit when you need private methods for internal business logic
