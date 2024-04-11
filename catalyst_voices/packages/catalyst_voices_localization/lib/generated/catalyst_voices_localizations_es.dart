import 'catalyst_voices_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class VoicesLocalizationsEs extends VoicesLocalizations {
  VoicesLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get emailLabelText => 'Email';

  @override
  String get emailHintText => 'mail@example.com';

  @override
  String get emailErrorText => 'mail@example.com';

  @override
  String get passwordLabelText => 'Contraseña';

  @override
  String get passwordHintText => 'Mi1ContraseñaSecreta';

  @override
  String get passwordErrorText =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get loginTitleText => 'Acceso';

  @override
  String get loginButtonText => 'Acceso';

  @override
  String get loginScreenErrorMessage => 'Credenciales incorrectas';

  @override
  String get homeScreenText => 'Catalyst Voices';

  @override
  String get comingSoonSubtitle => 'Voices';

  @override
  String get comingSoonTitle1 => 'Coming';

  @override
  String get comingSoonTitle2 => 'soon';

  @override
  String get comingSoonDescription =>
      'Project Catalyst is the world\'s largest decentralized innovation engine for solving real-world challenges.';
}
