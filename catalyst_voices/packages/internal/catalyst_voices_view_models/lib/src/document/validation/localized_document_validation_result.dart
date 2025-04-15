import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class LocalizedDocumentConstValueMismatch
    extends LocalizedDocumentValidationResult {
  final Object constValue;

  const LocalizedDocumentConstValueMismatch({required this.constValue});

  @override
  List<Object?> get props => [constValue];

  @override
  String? message(BuildContext context) {
    final constValue = this.constValue;
    if (constValue is bool && constValue) {
      return context.l10n.errorValidationConstsValueBoolMismatch;
    } else {
      return context.l10n
          .errorValidationConstValueMismatch(constValue.toString());
    }
  }
}

final class LocalizedDocumentEnumValuesMismatch
    extends LocalizedDocumentValidationResult {
  final List<Object> enumValues;

  const LocalizedDocumentEnumValuesMismatch({required this.enumValues});

  @override
  List<Object?> get props => [enumValues];

  @override
  String? message(BuildContext context) {
    return context.l10n.errorValidationEnumValuesMismatch(
      enumValues.map((e) => '"$e"').join(', '),
    );
  }
}

final class LocalizedDocumentListItemsNotUnique
    extends LocalizedDocumentValidationResult {
  const LocalizedDocumentListItemsNotUnique();

  @override
  List<Object?> get props => [];

  @override
  String? message(BuildContext context) {
    return context.l10n.errorValidationListItemsNotUnique;
  }
}

final class LocalizedDocumentListItemsOutOfRange
    extends LocalizedDocumentValidationResult {
  final NumRange<int> range;

  const LocalizedDocumentListItemsOutOfRange({required this.range});

  @override
  List<Object?> get props => [range];

  @override
  String? message(BuildContext context) {
    final min = range.min;
    final max = range.max;

    if (min != null && max != null) {
      return context.l10n.errorValidationListItemsOutOfRange(min, max);
    } else if (min != null) {
      return context.l10n.errorValidationListItemsBelowMin(min);
    } else if (max != null) {
      return context.l10n.errorValidationListItemsAboveMax(max);
    } else {
      // the range is unconstrained, so any value is allowed
      return null;
    }
  }
}

final class LocalizedDocumentNumOutOfRange
    extends LocalizedDocumentValidationResult {
  final NumRange<num> range;

  const LocalizedDocumentNumOutOfRange({required this.range});

  @override
  List<Object?> get props => [range];

  @override
  String? message(BuildContext context) {
    final min = range.min?.toInt();
    final max = range.max?.toInt();

    if (min != null && max != null) {
      return context.l10n.errorValidationNumFieldOutOfRange(min, max);
    } else if (min != null) {
      return context.l10n.errorValidationNumFieldBelowMin(min);
    } else if (max != null) {
      return context.l10n.errorValidationNumFieldAboveMax(max);
    } else {
      // the range is unconstrained, so any value is allowed
      return null;
    }
  }
}

final class LocalizedDocumentPatternMismatch
    extends LocalizedDocumentValidationResult {
  const LocalizedDocumentPatternMismatch();

  @override
  List<Object?> get props => [];

  @override
  String? message(BuildContext context) {
    return context.l10n.errorValidationPatternMismatch;
  }
}

final class LocalizedDocumentStringOutOfRange
    extends LocalizedDocumentValidationResult {
  final NumRange<int> range;

  const LocalizedDocumentStringOutOfRange({required this.range});

  @override
  List<Object?> get props => [range];

  @override
  String? message(BuildContext context) {
    final min = range.min;
    final max = range.max;

    if (min != null && max != null) {
      return context.l10n.errorValidationStringLengthOutOfRange(min, max);
    } else if (min != null) {
      return context.l10n.errorValidationStringLengthBelowMin(min);
    } else if (max != null) {
      return context.l10n.errorValidationStringLengthAboveMax(max);
    } else {
      // the range is unconstrained, so any value is allowed
      return null;
    }
  }
}

/// A localized [DocumentValidationResult].
sealed class LocalizedDocumentValidationResult extends Equatable {
  const LocalizedDocumentValidationResult();

  /// Creates a subclass of [LocalizedDocumentValidationResult]
  /// matching the [result].
  factory LocalizedDocumentValidationResult.from(
    DocumentValidationResult result,
  ) {
    return switch (result) {
      SuccessfulDocumentValidation() =>
        const LocalizedSuccessfulDocumentValidation(),
      MissingRequiredDocumentValue() =>
        const LocalizedMissingRequiredDocumentValue(),
      DocumentNumOutOfRange() =>
        LocalizedDocumentNumOutOfRange(range: result.expectedRange),
      DocumentStringOutOfRange() =>
        LocalizedDocumentStringOutOfRange(range: result.expectedRange),
      DocumentItemsOutOfRange() =>
        LocalizedDocumentListItemsOutOfRange(range: result.expectedRange),
      DocumentItemsNotUnique() => const LocalizedDocumentListItemsNotUnique(),
      DocumentConstValueMismatch() =>
        LocalizedDocumentConstValueMismatch(constValue: result.constValue),
      DocumentEnumValueMismatch() =>
        LocalizedDocumentEnumValuesMismatch(enumValues: result.enumValues),
      DocumentPatternMismatch() => const LocalizedDocumentPatternMismatch(),
    };
  }

  /// Returns a message describing the validation result that
  /// can be shown the user.
  ///
  /// Use the [BuildContext] to get the [VoicesLocalizations]
  /// or any other context dependent formatting utilities.
  String? message(BuildContext context);
}

final class LocalizedMissingRequiredDocumentValue
    extends LocalizedDocumentValidationResult {
  const LocalizedMissingRequiredDocumentValue();

  @override
  List<Object?> get props => [];

  @override
  String? message(BuildContext context) {
    return context.l10n.errorValidationMissingRequiredField;
  }
}

final class LocalizedSuccessfulDocumentValidation
    extends LocalizedDocumentValidationResult {
  const LocalizedSuccessfulDocumentValidation();

  @override
  List<Object?> get props => [];

  @override
  String? message(BuildContext context) {
    // it's valid, no need to specify the message
    return null;
  }
}
