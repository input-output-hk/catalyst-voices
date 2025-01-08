import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Validates [DocumentProperty].
final class DocumentValidator {
  /// Validates the [property] against all common rules that
  /// apply to all properties.
  ///
  /// There are no specific checks for different types like [String] or [int].
  static DocumentValidationResult validateBasic(
    DocumentProperty<Object> property,
  ) {
    final schema = property.schema;
    if (schema.isRequired && property.value == null) {
      return MissingRequiredDocumentValue(invalidNodeId: schema.nodeId);
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateString(
    DocumentProperty<String> property,
  ) {
    final result = validateBasic(property);
    if (result.isInvalid) {
      return result;
    }

    final schema = property.schema;
    final value = property.value;
    final strRange = schema.strLengthRange;

    if (strRange != null && value != null) {
      if (!strRange.contains(value.length)) {
        return DocumentStringOutOfRange(
          invalidNodeId: schema.nodeId,
          expectedRange: strRange,
          actualLength: value.length,
        );
      }
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateNum(DocumentProperty<num> property) {
    final result = validateBasic(property);
    if (result.isInvalid) {
      return result;
    }

    final schema = property.schema;
    final value = property.value;
    final numRange = schema.numRange;

    if (numRange != null && value != null) {
      if (!numRange.contains(value)) {
        return DocumentNumOutOfRange(
          invalidNodeId: schema.nodeId,
          expectedRange: numRange,
          actualValue: value,
        );
      }
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateList(
    DocumentProperty<List<dynamic>> property,
  ) {
    final result = validateBasic(property);
    if (result.isInvalid) {
      return result;
    }

    final schema = property.schema;
    final value = property.value;
    final itemsRange = schema.itemsRange;

    if (itemsRange != null && value != null) {
      if (!itemsRange.contains(value.length)) {
        return DocumentItemsOutOfRange(
          invalidNodeId: schema.nodeId,
          expectedRange: itemsRange,
          actualItems: value.length,
        );
      }
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateBool(
    DocumentProperty<bool> property,
  ) {
    return validateBasic(property);
  }
}

sealed class DocumentValidationResult extends Equatable {
  const DocumentValidationResult();

  /// Returns `true` if the validation was successful, `false` otherwise.
  bool get isValid => this is SuccessfulDocumentValidation;

  /// Returns `true` if the validation was unsuccessful, `false` otherwise.
  bool get isInvalid => !isValid;
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
  final Range<int> expectedRange;
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
