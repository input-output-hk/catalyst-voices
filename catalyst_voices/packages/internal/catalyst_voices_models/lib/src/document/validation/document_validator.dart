import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/schema/property/document_property_schema.dart';
import 'package:catalyst_voices_models/src/document/validation/document_validation_result.dart';

/// Validates [DocumentProperty].
final class DocumentValidator {
  static DocumentValidationResult validateIfRequired(
    DocumentPropertySchema schema,
    Object? value,
  ) {
    if (schema.isRequired && value == null) {
      return MissingRequiredDocumentValue(invalidNodeId: schema.nodeId);
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateStringLength(
    DocumentStringSchema schema,
    String? value,
  ) {
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

  static DocumentValidationResult validateStringPattern(
    DocumentStringSchema schema,
    String? value,
  ) {
    final pattern = schema.pattern;
    if (pattern != null && value != null) {
      if (!pattern.hasMatch(value)) {
        return DocumentPatternMismatch(
          pattern: pattern,
          value: value,
        );
      }
    }
    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateIntegerRange(
    DocumentIntegerSchema schema,
    int? value,
  ) {
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

  static DocumentValidationResult validateNumberRange(
    DocumentNumberSchema schema,
    double? value,
  ) {
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

  static DocumentValidationResult validateListItemsRange(
    DocumentListSchema schema,
    List<dynamic>? value,
  ) {
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

  static DocumentValidationResult validateListItemsUnique(
    DocumentListSchema schema,
    List<dynamic>? value,
  ) {
    if (schema.uniqueItems && value != null) {
      final unique = value.length == value.toSet().length;
      if (!unique) {
        return DocumentItemsNotUnique(invalidNodeId: schema.nodeId);
      }
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateConstValue(
    DocumentValueSchema schema,
    Object? value,
  ) {
    final constValue = schema.constValue;
    if (constValue != null && value != null) {
      final isValid = value == constValue;
      if (!isValid) {
        return DocumentConstValueMismatch(
          invalidNodeId: schema.nodeId,
          constValue: constValue,
        );
      }
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateEnumValues(
    DocumentValueSchema schema,
    Object? value,
  ) {
    final enumValues = schema.enumValues;
    if (enumValues != null && value != null) {
      final isValid = enumValues.contains(value);
      if (!isValid) {
        return DocumentEnumValueMismatch(
          invalidNodeId: schema.nodeId,
          enumValues: enumValues,
        );
      }
    }

    return const SuccessfulDocumentValidation();
  }
}
