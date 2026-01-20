import 'package:catalyst_voices_models/src/document/document_model.dart';
import 'package:catalyst_voices_models/src/document/schema/property/document_property_schema.dart';
import 'package:catalyst_voices_models/src/document/validation/document_validation_result.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';

/// Validates [DocumentProperty].
final class DocumentValidator {
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

  static DocumentValidationResult validateIfRequired(
    DocumentPropertySchema schema,
    Object? value,
  ) {
    if (schema.isRequired && value == null) {
      return MissingRequiredDocumentValue(invalidNodeId: schema.nodeId);
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateIntegerMultipleOf(
    DocumentIntegerSchema schema,
    int? value,
  ) {
    final multipleOf = schema.multipleOf;
    if (multipleOf != null && value != null) {
      if (value % multipleOf != 0) {
        return DocumentNumNotMultipleOf(
          invalidNodeId: schema.nodeId,
          multipleOf: multipleOf,
          actualValue: value,
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

  static DocumentValidationResult validateMoneyMultipleOf(
    DocumentCurrencySchema schema,
    int? value,
  ) {
    final multipleOf = schema.multipleOf;
    if (multipleOf != null && value != null) {
      if (value % multipleOf != 0) {
        return DocumentMoneyNotMultipleOf(
          invalidNodeId: schema.nodeId,
          multipleOf: schema.valueToMoney(multipleOf),
          actualValue: schema.valueToMoney(value),
        );
      }
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateMoneyRange(
    DocumentCurrencySchema schema,
    int? value,
  ) {
    final numRange = schema.numRange;
    if (numRange != null && value != null) {
      if (!numRange.contains(value)) {
        final min = numRange.min;
        final max = numRange.max;

        return DocumentMoneyOutOfRange(
          invalidNodeId: schema.nodeId,
          expectedRange: Range(
            min: min != null ? schema.valueToMoney(min) : null,
            max: max != null ? schema.valueToMoney(max) : null,
          ),
          actualValue: schema.valueToMoney(value),
        );
      }
    }

    return const SuccessfulDocumentValidation();
  }

  static DocumentValidationResult validateNumberMultipleOf(
    DocumentNumberSchema schema,
    double? value,
  ) {
    final multipleOf = schema.multipleOf;
    if (multipleOf != null && value != null) {
      if (NumberUtils.isDoubleMultipleOf(value: value, multipleOf: multipleOf)) {
        return DocumentNumNotMultipleOf(
          invalidNodeId: schema.nodeId,
          multipleOf: multipleOf,
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
    DocumentPatternType patternType,
  ) {
    final pattern = schema.pattern;
    if (pattern != null && value != null) {
      if (!pattern.hasMatch(value)) {
        return DocumentPatternMismatch(
          pattern: pattern,
          value: value,
          patternType: patternType,
        );
      }
    }
    return const SuccessfulDocumentValidation();
  }
}
