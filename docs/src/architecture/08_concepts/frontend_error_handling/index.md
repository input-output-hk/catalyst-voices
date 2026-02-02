---
icon: material/alert-circle
---

# Frontend Error Handling

This section documents error handling patterns and strategies in the Catalyst Voices
frontend application.

## Overview

The application uses a comprehensive error handling strategy with error states in BLoCs,
error boundaries, and user-friendly error messages.

## Error Handling Layers

### BLoC Error States

BLoCs emit error states for error handling:

```dart
class ProposalState extends Equatable {
  final bool loading;
  final Object? error;
  final Proposal? data;

  // Error state
  ProposalState.error(Object error) :
    loading = false,
    error = error,
    data = null;
}
```

### ErrorHandlerStateMixin

Pages use `ErrorHandlerStateMixin` for error handling:

```dart
class ProposalPage extends StatefulWidget {
  @override
  void handleError(Object error) {
    switch (error) {
      case ProposalNotFoundException():
        _showNotFoundError();
      case NetworkException():
        _showNetworkError();
      default:
        _showGenericError(error);
    }
  }
}
```

### Error Types

**LocalizedException**: User-facing errors with translations
**NetworkException**: Network-related errors
**ValidationException**: Form validation errors
**DocumentException**: Document-related errors

## Error Display

### Snackbars

User-facing errors shown via snackbars:

```dart
VoicesSnackBar(
  type: VoicesSnackBarType.error,
  title: context.l10n.errorTitle,
  message: context.l10n.errorMessage,
).show(context);
```

### Dialogs

Critical errors shown in dialogs:

```dart
ErrorDialog.show(
  context: context,
  error: error,
);
```

### Inline Errors

Form validation errors shown inline:

```dart
VoicesTextField(
  textValidator: (value) =>
    value.isEmpty
      ? VoicesTextFieldValidationResult.error('Required')
      : VoicesTextFieldValidationResult.success(),
)
```

## Error Recovery

### Retry Mechanisms

Network errors provide retry options:

```dart
if (error is NetworkException) {
  _showRetryDialog(() => _retryOperation());
}
```

### Fallback to Cache

Offline scenarios fall back to cached data:

```dart
try {
  final data = await repository.fetchFromAPI();
} catch (e) {
  final cached = await repository.fetchFromCache();
  // Use cached data with error indicator
}
```

### Error Boundaries

Error boundaries catch widget errors:

```dart
ErrorWidget.builder = (details) {
  return ErrorBoundaryWidget(details);
};
```

## Best Practices

1. **Use error states**: Emit error states in BLoCs
2. **Handle in pages**: Handle errors in page widgets
3. **User-friendly messages**: Show clear, actionable error messages
4. **Provide recovery**: Offer retry or alternative actions
5. **Log errors**: Log errors for debugging
6. **Localize errors**: Use localized error messages
7. **Handle gracefully**: Never crash on errors
