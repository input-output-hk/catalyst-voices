import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';

final class EmptyUsernameException extends UsernameValidationException {
  const EmptyUsernameException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorDisplayNameValidationEmpty;
  }
}

final class OutOfRangeUsernameException extends UsernameValidationException {
  const OutOfRangeUsernameException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorDisplayNameValidationOutOfRange;
  }
}

final class Username extends FormzInput<String, UsernameValidationException> {
  static const NumRange<int> lengthRange = NumRange(min: 1, max: 30);

  const Username.dirty([super.value = '']) : super.dirty();

  const Username.pure([super.value = '']) : super.pure();

  @override
  UsernameValidationException? validator(String value) {
    if (value.isEmpty) {
      return const EmptyUsernameException();
    }

    if (!lengthRange.contains(value.trim().length)) {
      return const OutOfRangeUsernameException();
    }

    return null;
  }
}

sealed class UsernameValidationException extends LocalizedException {
  const UsernameValidationException();
}
