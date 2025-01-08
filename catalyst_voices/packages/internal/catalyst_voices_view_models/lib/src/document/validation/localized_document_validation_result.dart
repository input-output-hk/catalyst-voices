import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
        LocalizedDocumentItemsOutOfRange(range: result.expectedRange),
    };
  }

  /// Returns a message describing the validation result that
  /// can be shown the user.
  ///
  /// Use the [BuildContext] to get the [VoicesLocalizations]
  /// or any other context dependent formatting utilities.
  String? message(BuildContext context);
}

final class LocalizedSuccessfulDocumentValidation
    extends LocalizedDocumentValidationResult {
  const LocalizedSuccessfulDocumentValidation();

  @override
  String? message(BuildContext context) {
    // it's valid, no need to specify the message
    return null;
  }

  @override
  List<Object?> get props => [];
}

final class LocalizedMissingRequiredDocumentValue
    extends LocalizedDocumentValidationResult {
  const LocalizedMissingRequiredDocumentValue();

  @override
  String? message(BuildContext context) {
    return context.l10n.errorValidationMissingRequiredField;
  }

  @override
  List<Object?> get props => [];
}

final class LocalizedDocumentNumOutOfRange
    extends LocalizedDocumentValidationResult {
  final Range<int> range;

  const LocalizedDocumentNumOutOfRange({required this.range});

  @override
  String? message(BuildContext context) {
    final min = range.min;
    final max = range.max;

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

  @override
  List<Object?> get props => [range];
}

final class LocalizedDocumentStringOutOfRange
    extends LocalizedDocumentValidationResult {
  final Range<int> range;

  const LocalizedDocumentStringOutOfRange({required this.range});

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

  @override
  List<Object?> get props => [range];
}

final class LocalizedDocumentItemsOutOfRange
    extends LocalizedDocumentValidationResult {
  final Range<int> range;

  const LocalizedDocumentItemsOutOfRange({required this.range});

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

  @override
  List<Object?> get props => [range];
}
