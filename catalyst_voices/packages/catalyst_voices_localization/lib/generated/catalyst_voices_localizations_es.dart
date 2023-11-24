import 'catalyst_voices_localizations.dart';

/// The translations for Spanish Castilian (`es`).
class VoicesLocalizationsEs extends VoicesLocalizations {
  VoicesLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginScreenUsernameLabelText => 'Nombre de usuario';

  @override
  String get loginScreenPasswordLabelText => 'Contraseña';

  @override
  String get loginScreenErrorMessage => 'Credenciales incorrectas';

  @override
  String get loginScreenLoginButtonText => 'Acceso';

  @override
  String get homeScreenText => 'Catalyst Voices';
}
