---
icon: material/navigation
---

# Frontend Navigation

This section documents navigation patterns and routing concepts used in the Catalyst Voices
frontend application.

## GoRouter Architecture

GoRouter is used as the routing solution for the application.
GoRouter started as an external library created by a community member.
The author did such an excellent job that Flutter team recognized it and declared it as the
standard navigation solution for Flutter.
Originally, Flutter introduced Navigator and Navigator 2.0 as routing solutions.
From experience, most production apps use external route libraries rather than the
built-in Navigator.

### Route Definition

Routes are defined declaratively with type safety:

* Path parameters for dynamic routes
* Query parameters for filters/search
* Route guards for authentication

### Type-Safe Navigation

Navigation is performed using type-safe route classes:

```dart
// Navigate to a proposal
ProposalRoute.fromRef(ref: proposalRef).push(context);

// Navigate with parameters
ProposalBuilderRoute.fromRef(ref: draftRef).push(context);

// Replace current route
ProposalRoute.fromRef(ref: ref).replace(context);
```

### Deep Linking

Support for:

* Web URLs
* Mobile deep links
* Route restoration

### Route Guards

Route guards are used for:

* Authentication checks
* Authorization validation
* Feature flag checks

### Navigation Patterns

* Type-safe navigation via generated code
* Route guards for protected routes
* Nested routing for complex flows
* URL updates based on tab selection (via signals)

### Signal-Based Route Updates

Signals can trigger route changes to keep the URL in sync with UI state:

```dart
// In VotingPage
@override
void handleSignal(VotingSignal signal) {
  switch (signal) {
    case ChangeTabVotingSignal(:final tab):
      _updateRoute(tab: tab); // Updates URL
    // ... other signals ...
  }
}
```
