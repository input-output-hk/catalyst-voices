import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';

/// Form input validator for email
final class Email extends FormzInput<String, EmailValidationException> {
  static const NumRange<int> lengthRange = NumRange(min: 0, max: 100);

  const Email.dirty([super.value = '']) : super.dirty();

  const Email.pure([super.value = '']) : super.pure();

  @override
  EmailValidationException? validator(String value) {
    if (!lengthRange.contains(value.length)) {
      return const OutOfRangeEmailException();
    }

    if (value.isNotEmpty && !EmailValidator.validate(value)) {
      return const EmailPatternInvalidException();
    }

    return null;
  }
}

/// Exception thrown when an email pattern is invalid.
final class EmailPatternInvalidException extends EmailValidationException {
  const EmailPatternInvalidException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorEmailValidationPattern;
  }
}

/// Base class for email validation exceptions.
sealed class EmailValidationException extends LocalizedException {
  const EmailValidationException();
}

/// Exception thrown when an email is out of range.
final class OutOfRangeEmailException extends EmailValidationException {
  const OutOfRangeEmailException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorEmailValidationOutOfRange;
  }
}
