import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

sealed class DocumentValidationResult extends Equatable {
  const DocumentValidationResult();

  /// Returns `true` if the validation was successful, `false` otherwise.
  bool get isValid => this is SuccessfulDocumentValidation;

  /// Returns `true` if the validation was unsuccessful, `false` otherwise.
  bool get isInvalid => !isValid;

  /// Merges the list of validation results,
  /// returns the first failure or the [SuccessfulDocumentValidation].
  static DocumentValidationResult merge(
    List<DocumentValidationResult> results,
  ) {
    for (final result in results) {
      if (result.isInvalid) {
        return result;
      }
    }

    return const SuccessfulDocumentValidation();
  }
}

/// The validation passed successfully.
final class SuccessfulDocumentValidation extends DocumentValidationResult {
  const SuccessfulDocumentValidation();

  @override
  List<Object?> get props => [];
}

/// A required document property is missing.
final class MissingRequiredDocumentValue extends DocumentValidationResult {
  final DocumentNodeId invalidNodeId;

  const MissingRequiredDocumentValue({required this.invalidNodeId});

  @override
  List<Object?> get props => [invalidNodeId];
}

/// The numerical [actualValue] is not within [expectedRange].
final class DocumentNumOutOfRange extends DocumentValidationResult {
  final DocumentNodeId invalidNodeId;
  final Range<num> expectedRange;
  final num actualValue;

  const DocumentNumOutOfRange({
    required this.invalidNodeId,
    required this.expectedRange,
    required this.actualValue,
  });

  @override
  List<Object?> get props => [invalidNodeId, expectedRange, actualValue];
}

/// The [String]'s [actualLength] is not within [expectedRange].
final class DocumentStringOutOfRange<T extends num>
    extends DocumentValidationResult {
  final DocumentNodeId invalidNodeId;
  final Range<int> expectedRange;
  final int actualLength;

  const DocumentStringOutOfRange({
    required this.invalidNodeId,
    required this.expectedRange,
    required this.actualLength,
  });

  @override
  List<Object?> get props => [invalidNodeId, expectedRange, actualLength];
}

/// The [List]'s length is not within [expectedRange].
final class DocumentItemsOutOfRange<T extends num>
    extends DocumentValidationResult {
  final DocumentNodeId invalidNodeId;
  final Range<int> expectedRange;
  final int actualItems;

  const DocumentItemsOutOfRange({
    required this.invalidNodeId,
    required this.expectedRange,
    required this.actualItems,
  });

  @override
  List<Object?> get props => [invalidNodeId, expectedRange, actualItems];
}

final class DocumentPatternMismatch extends DocumentValidationResult {
  final RegExp pattern;
  final String? value;

  const DocumentPatternMismatch({
    required this.pattern,
    required this.value,
  });

  @override
  List<Object?> get props => [pattern, value];
}
