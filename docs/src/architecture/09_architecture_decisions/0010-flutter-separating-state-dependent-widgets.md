---
    title: Separation of concerns for bloc state-dependent widgets
      adr:
        author: Damian Moliński
        created: 06-Jun-2025
        status: proposed
        extends:
          - 0001-flutter
          - 0005-flutter-app
      tags:
        - flutter
        - dart
        - state management
---

## Context

We use [flutter_bloc](https://pub.dev/packages/flutter_bloc) as our state management solution. Commonly, we use **BlocSelector** to retrieve specific parts of **Bloc** state. This allows us to rebuild only widgets when data, which they depend on, changes.

However, embedding **BlocSelector** directly within large widgets clutters the widget tree with state-selection logic. While this maximizes rendering efficiency, it increases visual complexity and reduces maintainability.

## Assumptions

* System will grow and UI will become more complex
* We need to make widget tree as simple to read and understand as possible in order to make it easier to maintain and modify while system grows

## Decision

We will extract widgets that depend on **Bloc** state (via **BlocSelector**) into dedicated files, placed in the corresponding `/widgets` subdirectory.

The public widget will act as the interface, encapsulating the state selection logic. It will delegate rendering to a private, internal widget that is unaware of the Bloc and simply receives the selected data as parameters.

### Example

Simple example but it quickly becomes more complex

#### Before

`spaces/spaces_shell_page.dart`

```dart
    return BlocSelector<SessionCubit, SessionState, _SessionStateData>(
      selector: (state) =>
          (isActive: state.isActive, isProposer: state.account?.isProposer ?? false),
      builder: (context, state) {
        return Scaffold(
          appBar: VoicesAppBar(
            leading: state.isActive ? const DrawerToggleButton() : null,
            automaticallyImplyLeading: false,
            actions: _getActions(widget.space, state.isProposer),
          ),
          drawer: state.isActive
              ? SpacesDrawer(
                  space: widget.space,
                  spacesShortcutsActivators: _spacesShortcutsActivators,
                  isUnlocked: state.isActive,
                )
              : null,
          endDrawer: const OpportunitiesDrawer(),
          body: widget.child,
        );
      },
    );
```

#### After

`spaces/widgets/spaces_scaffold.dart`

```dart
class SpacesScaffold extends StatelessWidget {
  final Space space;
  final Widget child;

  const SpacesScaffold({
    super.key,
    required this.space,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, _SessionStateData>(
      selector: (state) => (
        isActive: state.isActive,
        isProposer: state.account?.isProposer ?? false,
      ),
      builder: (context, state) {
        return _SpacesScaffold(
          isActive: state.isActive,
          isProposer: state.isProposer,
          space: space,
          child: child,
        );
      },
    );
  }
}

class _SpacesScaffold extends StatelessWidget {
  final bool isActive;
  final bool isProposer;
  final Space space;
  final Widget child;

  const _SpacesScaffold({
    required this.isActive,
    required this.isProposer,
    required this.space,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoicesAppBar(
        leading: isActive ? const DrawerToggleButton() : null,
        automaticallyImplyLeading: false,
        actions: _getActions(space, isProposer),
      ),
      drawer: isActive
          ? SpacesDrawer(
              space: space,
              spacesShortcutsActivators: _spacesShortcutsActivators,
              isUnlocked: isActive,
            )
          : null,
      endDrawer: const OpportunitiesDrawer(),
      body: child,
    );
  }
}

```

`spaces/spaces_shell_page.dart`

```dart
return SpacesScaffold(
  space: widget.space,
  child: widget.child,
);
```

## Risks

* While this introduces more files and a slight increase in initial development effort due to the two-widget pattern, we believe the long-term gains in maintainability and readability outweigh this overhead
* Risk of over-abstraction if used for trivial selections

## Consequences

* Improved widget tree and separation of responsibilities in widgets
* Longer path to pass down argument which is not part of state data

## More Information

* [Flutter Bloc](https://pub.dev/packages/flutter_bloc)
* [BlocSelector](https://pub.dev/packages/flutter_bloc#blocselector)