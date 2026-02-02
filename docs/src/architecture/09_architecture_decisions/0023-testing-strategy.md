---
    title: 0023 Testing Strategy
    adr:
        author: Catalyst Engineering Team
        created: 15-Jan-2024
        status: accepted
    tags:
        - flutter
        - testing
        - frontend
---

## Context

The Catalyst Voices frontend application requires a comprehensive testing strategy that:

* Ensures code quality and reliability
* Supports rapid development cycles
* Enables confident refactoring
* Validates user-facing functionality
* Works across Web, iOS, and Android platforms

We need testing patterns for:

* Unit tests (BLoCs, services, repositories)
* Widget tests (UI components)
* Integration tests (end-to-end user flows)

## Decision

We use a **three-tier testing approach**:

1. **Unit Tests**: Test BLoCs, services, and repositories in isolation using `bloc_test` and `mocktail`
2. **Widget Tests**: Test UI components using `flutter_test` with `testWidgets`
3. **Integration Tests**: Test end-to-end user flows using Flutter's `integration_test` with Page
   Object Model (POM) and `patrol_finders`.

## Implementation Details

### Unit Testing with bloc_test

BLoCs are tested using the `bloc_test` package:

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

blocTest<WorkspaceBloc, WorkspaceState>(
  'emit loading state and loaded state when watching proposals succeeds',
  setUp: () async {
    when(() => mockProposalService.watchUserProposals())
      .thenAnswer((_) => Stream.value([proposal]));
  },
  build: () => WorkspaceBloc(
    mockCampaignService,
    mockProposalService,
    mockDocumentMapper,
    mockDownloaderService,
  ),
  act: (bloc) => bloc.add(const WatchUserProposalsEvent()),
  expect: () => [
    const WorkspaceState(loading: true),
    WorkspaceState(loading: false, proposals: [proposal]),
  ],
);
```

**Key patterns**:

* Use `mocktail` for creating mocks
* Test state transitions
* Test error handling
* Test signal emissions
* Use `setUp` and `tearDown` for test isolation

### Widget Testing

Widgets are tested using `flutter_test`:

```dart
testWidgets('renders correctly with default parameters', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeBuilder.buildTheme(),
      home: Scaffold(
        body: VoicesTextField(
          onFieldSubmitted: (value) {},
        ),
      ),
    ),
  );

  expect(find.byType(TextField), findsOneWidget);
});
```

**Key patterns**:

* Wrap widgets in `MaterialApp` with theme
* Test rendering, user interactions, and state changes
* Test validation and error states
* Use `pump` and `pumpAndSettle` for async operations

### Integration Testing with Page Object Model

Integration tests use Page Object Model (POM) for maintainability:

```dart
// Page Object
class WorkspacePage {
  final PatrolTester $;
  WorkspacePage(this.$);

  Future<void> verifyProposalCardVisible() async {
    await $.pumpAndSettle();
    expect($.find.text('Proposal Title'), findsOneWidget);
  }
}

// Test
patrolWidgetTest('user can view proposals', (PatrolTester $) async {
  await TestStateUtils.pumpApp($);
  final workspacePage = WorkspacePage($);
  await workspacePage.verifyProposalCardVisible();
});
```

**Key patterns**:

* Page Object Model for screen abstraction
* `patrol_finders` for element lookups
* Test suites organized by feature
* Setup/teardown for test isolation
* Use `TestStateUtils` for app initialization

### Test Organization

```text
test/
  ├── widgets/          # Widget tests
  ├── common/           # Common utility tests
  └── routes/           # Route tests

integration_test/
  ├── suites/           # Test suites by feature
  ├── pageobject/       # Page Object classes
  ├── utils/            # Test utilities
  └── all_test.dart     # Test runner

packages/*/test/        # Package-specific tests
```

## Testing Tools

* **bloc_test**: BLoC unit testing
* **flutter_test**: Widget and unit testing framework
* **mocktail**: Mocking library (replacement for mockito)
* **integration_test**: Flutter's integration testing framework
* **patrol_finders**: Advanced element finders for integration tests

## Alternatives Considered

### Golden Tests

* **Pros**: Visual regression testing
* **Cons**: Maintenance overhead, platform-specific
* **Status**: Not currently used, may be considered for future

### E2E Tests with Playwright

* **Pros**: Cross-browser testing, better for web
* **Cons**: Additional tooling, separate from Flutter tests
* **Status**: Used for e2e tests in `e2e_tests/` directory

### Mockito

* **Pros**: Established mocking library
* **Cons**: Code generation required
* **Rejected**: `mocktail` provides better null-safety and no code generation

## Consequences

### Positive

* Clear separation between test types
* Maintainable test code with POM
* Fast unit tests for rapid feedback
* Comprehensive coverage of user flows
* Easy to mock dependencies

### Negative

* Integration tests are slower
* Requires test infrastructure setup
* Maintenance overhead for Page Objects
* Platform-specific considerations for integration tests

### Best Practices

* Write unit tests for all BLoCs and services
* Write widget tests for reusable components
* Write integration tests for critical user flows
* Keep tests isolated and independent
* Use descriptive test names
* Mock external dependencies
* Clean up resources in tearDown
* Organize tests by feature/package

## Test Execution

### Unit and Widget Tests

```bash
flutter test
```

### Integration Tests

```bash
flutter drive \
  --dart-define=ENV_NAME=dev \
  --web-header Cross-Origin-Opener-Policy=same-origin \
  --web-header Cross-Origin-Embedder-Policy=require-corp \
  --driver=test_driver/integration_tests.dart \
  --target=integration_test/all_test.dart \
  -d chrome
```
