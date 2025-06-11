import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

final class ProposalTitle extends FormzInput<String, ProposalTitleValidationException> {
  final NumRange<int>? titleLengthRange;

  const ProposalTitle.dirty([super.value = '', this.titleLengthRange]) : super.dirty();

  const ProposalTitle.pure([super.value = '', this.titleLengthRange]) : super.pure();

  @override
  ProposalTitleValidationException? validator(String value) {
    if (value.isEmpty) {
      return const ProposalTitleEmptyValidationException();
    }

    if (titleLengthRange != null) {
      final min = titleLengthRange!.min;
      final max = titleLengthRange!.max;

      if (min != null && value.length < min) {
        return ProposalTitleMinLengthValidationException(minLength: min);
      }

      if (max != null && value.length > max) {
        return ProposalTitleMaxLengthValidationException(maxLength: max);
      }
    }

    return null;
  }
}

final class ProposalTitleEmptyValidationException extends ProposalTitleValidationException {
  const ProposalTitleEmptyValidationException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorValidationStringEmpty;
  }
}

final class ProposalTitleMaxLengthValidationException extends ProposalTitleValidationException {
  final int maxLength;

  const ProposalTitleMaxLengthValidationException({required this.maxLength});

  @override
  String message(BuildContext context) {
    return context.l10n.errorValidationStringLengthAboveMax(maxLength);
  }
}

final class ProposalTitleMinLengthValidationException extends ProposalTitleValidationException {
  final int minLength;

  const ProposalTitleMinLengthValidationException({required this.minLength});

  @override
  String message(BuildContext context) {
    return context.l10n.errorValidationStringLengthBelowMin(minLength);
  }
}

sealed class ProposalTitleValidationException extends LocalizedException {
  const ProposalTitleValidationException();
}
