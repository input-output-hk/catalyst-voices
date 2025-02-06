import 'package:catalyst_voices_models/src/document/document.dart';
import 'package:catalyst_voices_models/src/document/schema/property/document_property_schema.dart';
import 'package:catalyst_voices_models/src/document/validation/document_validation_result.dart';
import 'package:collection/collection.dart';

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
    List<dynamic>? values,
  ) {
    final itemsRange = schema.itemsRange;
    if (itemsRange != null && values != null) {
      if (!itemsRange.contains(values.length)) {
        return DocumentItemsOutOfRange(
          invalidNodeId: schema.nodeId,
          expectedRange: itemsRange,
          actualItems: values.length,
        );
      }
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateListItemsUnique(
    DocumentListSchema schema,
    List<dynamic>? values,
  ) {
    if (schema.uniqueItems && values != null) {
      const equality = DeepCollectionEquality();
      for (var i = 0; i < values.length; i++) {
        // for every list item lets check if there
        // are duplicates further in the list
        for (var j = i + 1; j < values.length; j++) {
          if (equality.equals(values[i], values[j])) {
            return DocumentItemsNotUnique(invalidNodeId: schema.nodeId);
          }
        }
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
