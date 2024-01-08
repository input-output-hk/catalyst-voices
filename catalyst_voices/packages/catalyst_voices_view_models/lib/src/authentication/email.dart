import 'package:formz/formz.dart';

final class Email extends FormzInput<String, EmailValidationError> {
  static final _emailRegExp = RegExp(
    r'^[a-zA-Z\d.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z\d-]+(?:\.[a-zA-Z\d-]+)*$',
  );

  const Email.dirty([super.value = '']) : super.dirty();

  const Email.pure([super.value = '']) : super.pure();

  @override
  EmailValidationError? validator(String value) {
    return _emailRegExp.hasMatch(value) ? null : EmailValidationError.invalid;
  }
}

enum EmailValidationError {
  invalid;

  String description(String text) {
    switch (this) {
      case EmailValidationError.invalid:
        return text;
    }
  }
}
