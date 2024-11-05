import 'package:formz/formz.dart';

final class Password extends FormzInput<String, PasswordValidationError> {
  static final _passwordRegex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');

  const Password.dirty([super.value = '']) : super.dirty();

  const Password.pure([super.value = '']) : super.pure();

  @override
  PasswordValidationError? validator(String value) {
    return _passwordRegex.hasMatch(value)
        ? null
        : PasswordValidationError.invalid;
  }
}

enum PasswordValidationError {
  invalid;

  String description(String text) {
    switch (this) {
      case PasswordValidationError.invalid:
        return text;
    }
  }
}
