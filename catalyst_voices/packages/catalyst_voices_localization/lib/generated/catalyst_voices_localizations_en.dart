import 'catalyst_voices_localizations.dart';

/// The translations for English (`en`).
class VoicesLocalizationsEn extends VoicesLocalizations {
  VoicesLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get emailLabelText => 'Email';

  @override
  String get emailHintText => 'mail@example.com';

  @override
  String get emailErrorText => 'mail@example.com';

  @override
  String get passwordLabelText => 'Password';

  @override
  String get passwordHintText => 'My1SecretPassword';

  @override
  String get passwordErrorText => 'Password must be at least 8 characters long';

  @override
  String get loginTitleText => 'Login';

  @override
  String get loginButtonText => 'Login';

  @override
  String get loginScreenErrorMessage => 'Wrong credentials';

  @override
  String get homeScreenText => 'Catalyst Voices';
}
