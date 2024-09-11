import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'catalyst_voices_localizations_en.dart' deferred as catalyst_voices_localizations_en;
import 'catalyst_voices_localizations_es.dart' deferred as catalyst_voices_localizations_es;

// ignore_for_file: type=lint

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

  /// Text shown in cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButtonText;

  /// Text shown in edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editButtonText;

  /// Text shown in header tooltip
  ///
  /// In en, this message translates to:
  /// **'Header'**
  String get headerTooltipText;

  /// Text shown as placeholder in rich text editor
  ///
  /// In en, this message translates to:
  /// **'Start writing your text...'**
  String get placeholderRichText;

  /// Text shown as placeholder in rich text editor
  ///
  /// In en, this message translates to:
  /// **'Supporting text'**
  String get supportingTextLabelText;

  /// Text shown in save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButtonText;

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

  /// Text shown after logo in coming soon page
  ///
  /// In en, this message translates to:
  /// **'Voices'**
  String get comingSoonSubtitle;

  /// Text shown as main title in coming soon page
  ///
  /// In en, this message translates to:
  /// **'Coming'**
  String get comingSoonTitle1;

  /// Text shown as main title in coming soon page
  ///
  /// In en, this message translates to:
  /// **'soon'**
  String get comingSoonTitle2;

  /// Text shown as description in coming soon page
  ///
  /// In en, this message translates to:
  /// **'Project Catalyst is the world\'s largest decentralized innovation engine for solving real-world challenges.'**
  String get comingSoonDescription;

  /// Label text shown in the ConnectingStatus widget during re-connection.
  ///
  /// In en, this message translates to:
  /// **'re-connecting'**
  String get connectingStatusLabelText;

  /// Label text shown in the FinishAccountButton widget.
  ///
  /// In en, this message translates to:
  /// **'Finish account'**
  String get finishAccountButtonLabelText;

  /// Label text shown in the GetStartedButton widget.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedButtonLabelText;

  /// Label text shown in the UnlockButton widget.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlockButtonLabelText;

  /// Label text shown in the UserProfileButton widget when a user is not connected.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get userProfileGuestLabelText;

  /// Label text shown in the Search widget.
  ///
  /// In en, this message translates to:
  /// **'[cmd=K]'**
  String get searchButtonLabelText;

  /// Label text shown in the Snackbar widget when the message is an info message.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get snackbarInfoLabelText;

  /// Text shown in the Snackbar widget when the message is an info message.
  ///
  /// In en, this message translates to:
  /// **'This is an info message!'**
  String get snackbarInfoMessageText;

  /// Label text shown in the Snackbar widget when the message is an success message.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get snackbarSuccessLabelText;

  /// Text shown in the Snackbar widget when the message is an success message.
  ///
  /// In en, this message translates to:
  /// **'This is a success message!'**
  String get snackbarSuccessMessageText;

  /// Label text shown in the Snackbar widget when the message is an warning message.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get snackbarWarningLabelText;

  /// Text shown in the Snackbar widget when the message is an warning message.
  ///
  /// In en, this message translates to:
  /// **'This is a warning message!'**
  String get snackbarWarningMessageText;

  /// Label text shown in the Snackbar widget when the message is an error message.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get snackbarErrorLabelText;

  /// Text shown in the Snackbar widget when the message is an error message.
  ///
  /// In en, this message translates to:
  /// **'This is an error message!'**
  String get snackbarErrorMessageText;

  /// Text shown in the Snackbar widget for the refresh button.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get snackbarRefreshButtonText;

  /// Text shown in the Snackbar widget for the more button.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get snackbarMoreButtonText;

  /// Text shown in the Snackbar widget for the ok button.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get snackbarOkButtonText;

  /// When user arranges seed phrases this text is shown when phrase was not selected
  ///
  /// In en, this message translates to:
  /// **'Slot {nr}'**
  String seedPhraseSlotNr(int nr);

  /// Indicates to user that status is in ready mode
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get proposalStatusReady;

  /// Indicates to user that status is in draft mode
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get proposalStatusDraft;

  /// Label shown on a proposal card indicating that the proposal is funded.
  ///
  /// In en, this message translates to:
  /// **'Funded proposal'**
  String get fundedProposal;

  /// Label shown on a proposal card indicating that the proposal is not yet funded.
  ///
  /// In en, this message translates to:
  /// **'Published proposal'**
  String get publishedProposal;

  /// Indicates date of funding (a proposal).
  ///
  /// In en, this message translates to:
  /// **'Funded {date}'**
  String fundedProposalDate(DateTime date);

  /// Indicates a last update date.
  ///
  /// In en, this message translates to:
  /// **'Last update: {date}.'**
  String lastUpdateDate(String date);

  /// Indicates the amount of ADA requested in a fund on a proposal card.
  ///
  /// In en, this message translates to:
  /// **'Funds requested'**
  String get fundsRequested;

  /// Indicates the amount of comments on a proposal card.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =0{comments} =1{comment} other{comments}}'**
  String noOfComments(num count);

  /// Indicates the amount of comments on a proposal card.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} ({percentage}%) {total, plural, =0{segments} =1{segment} other{segments}} completed'**
  String noOfSegmentsCompleted(num completed, num total, num percentage);

  /// Refers to date which is today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// Refers to date which is yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// Refers to date which is two days ago.
  ///
  /// In en, this message translates to:
  /// **'2 days ago'**
  String get twoDaysAgo;

  /// Refers to date which is tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// Title of the voting space.
  ///
  /// In en, this message translates to:
  /// **'Active voting round 14'**
  String get activeVotingRound;

  /// Tab label for all proposals in voting space
  ///
  /// In en, this message translates to:
  /// **'All proposals ({count})'**
  String noOfAllProposals(int count);

  /// Refers to a list of favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Left panel name in treasury space
  ///
  /// In en, this message translates to:
  /// **'Campaign builder'**
  String get treasuryCampaignBuilder;

  /// Tab name in campaign builder panel
  ///
  /// In en, this message translates to:
  /// **'Segments'**
  String get treasuryCampaignBuilderSegments;

  /// Segment name
  ///
  /// In en, this message translates to:
  /// **'Setup Campaign'**
  String get treasuryCampaignSetup;

  /// Campaign title
  ///
  /// In en, this message translates to:
  /// **'Campaign title'**
  String get treasuryCampaignTitle;

  /// Button name in step
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get stepEdit;

  /// Left panel name in workspace
  ///
  /// In en, this message translates to:
  /// **'Proposal navigation'**
  String get workspaceProposalNavigation;

  /// Tab name in proposal setup panel
  ///
  /// In en, this message translates to:
  /// **'Segments'**
  String get workspaceProposalNavigationSegments;

  /// Segment name
  ///
  /// In en, this message translates to:
  /// **'Proposal setup'**
  String get workspaceProposalSetup;

  /// Name shown in spaces shell drawer
  ///
  /// In en, this message translates to:
  /// **'Treasury'**
  String get drawerSpaceTreasury;

  /// Name shown in spaces shell drawer
  ///
  /// In en, this message translates to:
  /// **'Discovery'**
  String get drawerSpaceDiscovery;

  /// Name shown in spaces shell drawer
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get drawerSpaceWorkspace;

  /// Name shown in spaces shell drawer
  ///
  /// In en, this message translates to:
  /// **'Voting'**
  String get drawerSpaceVoting;

  /// Name shown in spaces shell drawer
  ///
  /// In en, this message translates to:
  /// **'Funded projects'**
  String get drawerSpaceFundedProjects;
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
