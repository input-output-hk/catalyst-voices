import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/src/exception/localized_exception.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

final class ProposalTitle extends FormzInput<String, ProposalTitleValidationException> {
  static const titleMinLength = 3;

  const ProposalTitle.dirty([super.value = '']) : super.dirty();

  const ProposalTitle.pure([super.value = '']) : super.pure();

  @override
  ProposalTitleValidationException? validator(String value) {
    if (value.isEmpty) {
      return const ProposalTitleEmptyValidationException();
    } else if (value.length < titleMinLength) {
      return const ProposalTitleMinLengthValidationException(minLength: titleMinLength);
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
