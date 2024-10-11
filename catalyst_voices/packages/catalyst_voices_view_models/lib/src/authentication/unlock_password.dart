import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:formz/formz.dart';

final class UnlockPassword extends FormzInput<String, UnlockPasswordError> {
  const UnlockPassword.dirty([super.value = '']) : super.dirty();

  const UnlockPassword.pure([super.value = '']) : super.pure();

  PasswordStrength strength() {
    return PasswordStrength.calculate(value);
  }

  @override
  UnlockPasswordError? validator(String value) {
    if (value.length < PasswordStrength.minimumLength) {
      return UnlockPasswordError.tooShort;
    }

    return null;
  }
}

enum UnlockPasswordError { tooShort }
