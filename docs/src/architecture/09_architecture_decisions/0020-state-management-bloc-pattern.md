---
    title: 0020 State Management with BLoC Pattern
    adr:
        author: Catalyst Engineering Team
        created: 15-Jan-2024
        status: accepted
    tags:
        - flutter
        - state-management
        - bloc
        - frontend
---

## Context

The Catalyst Voices application requires a state management solution that:

* Handles complex asynchronous operations
* Supports reactive UI updates
* Enables testability
* Provides clear separation of business logic from UI
* Supports cross-feature communication

ADR 0005 established the high-level decision to use BLoC pattern.
This ADR provides detailed implementation decisions.

## Decision

We use **flutter_bloc** package with the following patterns:

1. **BLoC for Complex State**: Use `Bloc` class for state machines with multiple events
2. **Cubit for State Management**: Use `Cubit` class for state management, not just simpler cases.
   Cubit is also handy when there is a lot of triggering of internal events of business logic, as methods can be private.
   In BLoC, events are public classes, and every method needs to have emitter possibilities.
3. **Service Layer for Data Merging**: Services sit between BLoCs and repositories to merge information from different sources.
   For example, local proposals and remote proposals are merged into one stream in ProposalService.
4. **Observers for Cross-BLoC Communication**: Use observers (UserObserver, ActiveCampaignObserver) in the service layer.
   This avoids direct BLoC-to-BLoC communication, which creates coupling and noisy state emissions.
5. **Signals for User Event Information**: Signals are used primarily for user event information
   that is not shown in UI elements directly.
   For example, showing success snackbars, triggering route changes based on tab selection.
   Signals are handled in pages (e.g., WorkspacePage), not in other BLoCs.
6. **Repository Pattern**: BLoCs interact with services, which interact with repositories.
   BLoCs never directly access APIs or databases.

## Implementation Patterns

### BLoC Structure

```dart
class ProposalBloc extends Bloc<ProposalEvent, ProposalState> {
  final ProposalService service;

  ProposalBloc(this.service) : super(ProposalInitial()) {
    on<LoadProposal>(_onLoadProposal);
    on<UpdateProposal>(_onUpdateProposal);
  }

  Future<void> _onLoadProposal(
    LoadProposal event,
    Emitter<ProposalState> emit,
  ) async {
    emit(ProposalLoading());
    try {
      final proposal = await service.getProposal(event.id);
      emit(ProposalLoaded(proposal));
    } catch (e) {
      emit(ProposalError(e));
    }
  }
}
```

### Cubit Structure

```dart
class SessionCubit extends Cubit<SessionState> {
  final AuthService service;

  SessionCubit(this.service) : super(SessionInitial());

  Future<void> login(String mnemonic) async {
    emit(SessionLoading());
    try {
      final session = await service.authenticate(mnemonic);
      emit(SessionAuthenticated(session));
    } catch (e) {
      emit(SessionError(e));
    }
  }

  // Private methods can trigger internal business logic
  void _updateSessionInternal() {
    // Internal logic without needing public events
  }
}
```

### Service Layer Pattern

```dart
class ProposalService {
  final ProposalRepository repository;
  final ActiveCampaignObserver observer;

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

### Observer Pattern for Cross-BLoC Communication

```dart
// Service uses observer to track state changes
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

### Signal Pattern

```dart
// Emit signal from BLoC
class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  void _onDeleteDraft(DeleteDraftEvent event, Emitter emit) {
    // ... delete logic ...
    emitSignal(DeletedDraftWorkspaceSignal());
  }
}

// Handle signal in page, not in another BLoC
class WorkspacePage extends StatefulWidget {
  @override
  void handleSignal(WorkspaceSignal signal) {
    switch (signal) {
      case DeletedDraftWorkspaceSignal():
        _showDeleteSuccessSnackBar();
      // ... other signals ...
    }
  }
}
```

## Alternatives Considered

### Provider

* **Pros**: Simple, built into Flutter
* **Cons**: Less structured, harder to test complex flows
* **Rejected**: Not suitable for complex state machines

### Riverpod

* **Pros**: Compile-time safety, excellent testing
* **Cons**: Different paradigm, migration cost
* **Rejected**: BLoC already established, migration not justified

### Redux

* **Pros**: Predictable state management
* **Cons**: Too much boilerplate, not idiomatic for Flutter
* **Rejected**: BLoC provides better Flutter integration

## Consequences

### Positive

* Clear separation of business logic and UI
* Excellent testability with bloc_test package
* Reactive updates via Streams
* Predictable state transitions
* Good tooling support (BlocObserver for debugging)
* Service layer enables data merging from multiple sources
* Observer pattern reduces coupling between BLoCs
* Signals provide clean user event information mechanism

### Negative

* Learning curve for developers new to reactive programming
* Some boilerplate for simple state
* Requires understanding of Streams and async patterns
* Service layer adds an additional abstraction layer

### Best Practices Established

* One BLoC per feature domain
* Service layer for data merging and business logic
* Repository pattern for data access
* ViewModels for UI-specific transformations
* Observer pattern for cross-BLoC communication via services
* Signal pattern for user event information (handled in pages)
* Error handling via error states
* Cubit for internal business logic with private methods
