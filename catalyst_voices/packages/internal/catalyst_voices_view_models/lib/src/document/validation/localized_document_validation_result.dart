import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
      DocumentNumOutOfRange() => const LocalizedDocumentNumOutOfRange(),
      DocumentStringOutOfRange() => const LocalizedDocumentStringOutOfRange(),
      DocumentItemsOutOfRange() => const LocalizedDocumentItemsOutOfRange(),
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
    // TODO(dtscalac): define the text
    return 'LocalizedMissingRequiredDocumentValue';
  }

  @override
  List<Object?> get props => [];
}

final class LocalizedDocumentNumOutOfRange
    extends LocalizedDocumentValidationResult {
  const LocalizedDocumentNumOutOfRange();

  @override
  String? message(BuildContext context) {
    // TODO(dtscalac): define the text
    return 'LocalizedDocumentNumOutOfRange';
  }

  @override
  List<Object?> get props => [];
}

final class LocalizedDocumentStringOutOfRange
    extends LocalizedDocumentValidationResult {
  const LocalizedDocumentStringOutOfRange();

  @override
  String? message(BuildContext context) {
    // TODO(dtscalac): define the text
    return 'LocalizedDocumentStringOutOfRange';
  }

  @override
  List<Object?> get props => [];
}

final class LocalizedDocumentItemsOutOfRange
    extends LocalizedDocumentValidationResult {
  const LocalizedDocumentItemsOutOfRange();

  @override
  String? message(BuildContext context) {
    // TODO(dtscalac): define the text
    return 'LocalizedDocumentItemsOutOfRange';
  }

  @override
  List<Object?> get props => [];
}
