import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/document_node_id.dart';
import 'package:catalyst_voices_models/src/document/document_schema.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Validates [DocumentValueProperty].
final class DocumentValidator {
  /// Validates the property [value] against all common rules that
  /// apply to all properties.
  ///
  /// There are no specific checks for different types like [String] or [int].
  static DocumentValidationResult validateBasic(
    DocumentPropertySchema schema,
    Object? value,
  ) {
    // TODO(dtscalac): validate type
    if (schema.isRequired && value == null) {
      return MissingRequiredDocumentValue(invalidNodeId: schema.nodeId);
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateString(
    DocumentStringSchema schema,
    String? value,
  ) {
    final result = validateBasic(schema, value);
    if (result.isInvalid) {
      return result;
    }

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

  static DocumentValidationResult validateInteger(
    DocumentIntegerSchema schema,
    int? value,
  ) {
    final result = validateBasic(schema, value);
    if (result.isInvalid) {
      return result;
    }

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

  static DocumentValidationResult validateNumber(
    DocumentNumberSchema schema,
    double? value,
  ) {
    final result = validateBasic(schema, value);
    if (result.isInvalid) {
      return result;
    }

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
    DocumentListSchema schema,
    List<dynamic>? value,
  ) {
    final result = validateBasic(schema, value);
    if (result.isInvalid) {
      return result;
    }

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
    DocumentBooleanSchema schema,
    // ignore: avoid_positional_boolean_parameters
    bool? value,
  ) {
    final result = validateBasic(schema, value);

    if (result.isInvalid) {
      return result;
    }

    if (value == null) {
      return MissingRequiredDocumentValue(invalidNodeId: schema.nodeId);
    }
    return const SuccessfulDocumentValidation();
  }

  // TODO(dtscalac): move to validate string
  static DocumentValidationResult validatePattern(
    String pattern,
    String? value,
  ) {
    final regex = RegExp(pattern);
    if (value != null) {
      if (!regex.hasMatch(value)) {
        return DocumentPatternMismatch(pattern: pattern, value: value);
      }
    }
    return const SuccessfulDocumentValidation();
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
  final String pattern;
  final String? value;

  const DocumentPatternMismatch({
    required this.pattern,
    required this.value,
  });

  @override
  List<Object?> get props => [pattern, value];
}
