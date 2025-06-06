---
    title: Flutter widgets selectors
      adr:
        author: Damian Moliński
        created: 06-Jun-2025
        status: draft
        extends:
          - 0001-flutter
          - 0005-flutter-app
      tags:
        - flutter
        - dart
        - state management
---

## Context

We're using [flutter_bloc](https://pub.dev/packages/flutter_bloc) as state management solution of
choice. Commonly we're using **Selectors** for querying given subpart of **Bloc** state in order rebuild
only widgets which are interested in that data.
This maximizes efficiency in render phase but adds complexity in widget tree and makes it harder to
read/maintain.

## Assumptions

* System will grow and UI will become more complex
* We need to make widget tree as simple to read and understand as possible in order to make it easier to maintain and modify while system grows

## Decision

We will build widgets which depend on state data (**Selectors**) in separate file under relative directory `/widgets` to where it's supposed to be used. We will also not include keyword **Selector** or **Bloc** in name of those widgets, instead we'll have public widget with appropriate name, which only selects relevant state data and second, private, widget which will know how to render that data.

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
                  spacesShortcutsActivators: SpacesShellPage._spacesShortcutsActivators,
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

* More boilerplate code and longer development time

## Consequences

* Improved widget tree and separation of responsibilities in widgets
* Longer path to pass down argument which is not part of state data

## More Information

* [Flutter Bloc](https://pub.dev/packages/flutter_bloc)
* [BlocSelector](https://pub.dev/packages/flutter_bloc#blocselector)