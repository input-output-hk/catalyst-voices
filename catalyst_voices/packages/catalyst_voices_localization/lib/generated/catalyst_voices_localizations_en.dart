import 'catalyst_voices_localizations.dart';

/// The translations for English (`en`).
class VoicesLocalizationsEn extends VoicesLocalizations {
  VoicesLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginScreenUsernameLabelText => 'Username';

  @override
  String get loginScreenPasswordLabelText => 'Password';

  @override
  String get loginScreenErrorMessage => 'Wrong credentials';

  @override
  String get loginScreenLoginButtonText => 'Login';

  @override
  String get homeScreenText => 'Catalyst Voices';
}
