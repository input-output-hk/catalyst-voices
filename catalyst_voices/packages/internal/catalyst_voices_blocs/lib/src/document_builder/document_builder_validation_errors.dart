import 'package:equatable/equatable.dart';

/// Contains the state of validation errors for the document builder.
final class DocumentBuilderValidationErrors<ValidationOrigin extends Object> extends Equatable {
  final DocumentBuilderValidationStatus status;
  final ValidationOrigin origin;
  final List<String> errors;

  const DocumentBuilderValidationErrors({
    required this.status,
    required this.origin,
    required this.errors,
  });

  @override
  List<Object?> get props => [status, origin, errors];

  bool get showErrors {
    switch (status) {
      case DocumentBuilderValidationStatus.notStarted:
      case DocumentBuilderValidationStatus.cleared:
        return false;
      case DocumentBuilderValidationStatus.pendingShowAll:
      case DocumentBuilderValidationStatus.pendingHideAll:
        return true;
    }
  }

  DocumentBuilderValidationErrors<ValidationOrigin> copyWith({
    DocumentBuilderValidationStatus? status,
    ValidationOrigin? origin,
    List<String>? errors,
  }) {
    return DocumentBuilderValidationErrors(
      status: status ?? this.status,
      origin: origin ?? this.origin,
      errors: errors ?? this.errors,
    );
  }

  DocumentBuilderValidationErrors<ValidationOrigin> withErrorList(
    List<String> errors,
  ) {
    return copyWith(
      status: _ensureStatusMatchesErrorList(status, errors),
      errors: errors,
    );
  }

  DocumentBuilderValidationStatus _ensureStatusMatchesErrorList(
    DocumentBuilderValidationStatus status,
    List<String> errors,
  ) {
    switch (status) {
      case DocumentBuilderValidationStatus.notStarted:
      case DocumentBuilderValidationStatus.pendingShowAll:
      case DocumentBuilderValidationStatus.pendingHideAll:
        if (errors.isEmpty) {
          return DocumentBuilderValidationStatus.cleared;
        } else {
          return status;
        }

      case DocumentBuilderValidationStatus.cleared:
        if (errors.isEmpty) {
          return status;
        } else {
          return DocumentBuilderValidationStatus.pendingShowAll;
        }
    }
  }
}

enum DocumentBuilderValidationStatus {
  notStarted,
  pendingShowAll,
  pendingHideAll,
  cleared,
}
