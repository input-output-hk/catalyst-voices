import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'catalyst_voices_localizations_en.dart' deferred as catalyst_voices_localizations_en;
import 'catalyst_voices_localizations_es.dart' deferred as catalyst_voices_localizations_es;

/// Callers can lookup localized strings with an instance of VoicesLocalizations
/// returned by `VoicesLocalizations.of(context)`.
///
/// Applications need to include `VoicesLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/catalyst_voices_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: VoicesLocalizations.localizationsDelegates,
///   supportedLocales: VoicesLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the VoicesLocalizations.supportedLocales
/// property.
abstract class VoicesLocalizations {
  VoicesLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static VoicesLocalizations? of(BuildContext context) {
    return Localizations.of<VoicesLocalizations>(context, VoicesLocalizations);
  }

  static const LocalizationsDelegate<VoicesLocalizations> delegate = _VoicesLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// Text shown in email field
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabelText;

  /// Text shown in email field when empty
  ///
  /// In en, this message translates to:
  /// **'mail@example.com'**
  String get emailHintText;

  /// Text shown in email field when input is invalid
  ///
  /// In en, this message translates to:
  /// **'mail@example.com'**
  String get emailErrorText;

  /// Text shown in password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabelText;

  /// Text shown in password field when empty
  ///
  /// In en, this message translates to:
  /// **'My1SecretPassword'**
  String get passwordHintText;

  /// Text shown in  password field when input is invalid
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get passwordErrorText;

  /// Text shown in the login screen title
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitleText;

  /// Text shown in the login screen for the login button
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButtonText;

  /// Text shown in the login screen when the user enters wrong credentials
  ///
  /// In en, this message translates to:
  /// **'Wrong credentials'**
  String get loginScreenErrorMessage;

  /// Text shown in the home screen
  ///
  /// In en, this message translates to:
  /// **'Catalyst Voices'**
  String get homeScreenText;
}

class _VoicesLocalizationsDelegate extends LocalizationsDelegate<VoicesLocalizations> {
  const _VoicesLocalizationsDelegate();

  @override
  Future<VoicesLocalizations> load(Locale locale) {
    return lookupVoicesLocalizations(locale);
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_VoicesLocalizationsDelegate old) => false;
}

Future<VoicesLocalizations> lookupVoicesLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return catalyst_voices_localizations_en.loadLibrary().then((dynamic _) => catalyst_voices_localizations_en.VoicesLocalizationsEn());
    case 'es': return catalyst_voices_localizations_es.loadLibrary().then((dynamic _) => catalyst_voices_localizations_es.VoicesLocalizationsEs());
  }

  throw FlutterError(
    'VoicesLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
