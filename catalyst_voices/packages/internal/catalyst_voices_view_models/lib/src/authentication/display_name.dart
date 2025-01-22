import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';

final class DisplayName
    extends FormzInput<String, DisplayNameValidationException> {
  const DisplayName.dirty([super.value = '']) : super.dirty();

  const DisplayName.pure([super.value = '']) : super.pure();

  static const Range<int> lengthRange = Range(min: 1, max: 30);

  @override
  DisplayNameValidationException? validator(String value) {
    if (value.isEmpty) {
      return const EmptyDisplayNameException();
    }

    if (!lengthRange.contains(value.length)) {
      return const OutOfRangeDisplayNameException();
    }

    return null;
  }
}

sealed class DisplayNameValidationException extends LocalizedException {
  const DisplayNameValidationException();
}

final class EmptyDisplayNameException extends DisplayNameValidationException {
  const EmptyDisplayNameException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorDisplayNameValidationEmpty;
  }
}

final class OutOfRangeDisplayNameException
    extends DisplayNameValidationException {
  const OutOfRangeDisplayNameException();

  @override
  String message(BuildContext context) {
    return context.l10n.errorDisplayNameValidationOutOfRange;
  }
}
