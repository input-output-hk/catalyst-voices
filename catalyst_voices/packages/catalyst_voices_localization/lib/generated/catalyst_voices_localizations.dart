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

  /// Indicates to user that status is in progress
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get proposalStatusInProgress;

  /// Indicates to user that status is in private mode
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get proposalStatusPrivate;

  /// Indicates to user that status is in live mode
  ///
  /// In en, this message translates to:
  /// **'LIVE'**
  String get proposalStatusLive;

  /// Indicates to user that status is completed
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get proposalStatusCompleted;

  /// Indicates to user that status is in open mode
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get proposalStatusOpen;

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

  /// Title of the funded project space
  ///
  /// In en, this message translates to:
  /// **'Funded project space'**
  String get fundedProjectSpace;

  /// Tab label for funded proposals in funded projects space
  ///
  /// In en, this message translates to:
  /// **'Funded proposals ({count})'**
  String noOfFundedProposals(int count);

  /// Refers to a list of followed items.
  ///
  /// In en, this message translates to:
  /// **'Followed'**
  String get followed;

  /// Overall spaces search brands tile name
  ///
  /// In en, this message translates to:
  /// **'Search Brands'**
  String get overallSpacesSearchBrands;

  /// Overall spaces tasks tile name
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get overallSpacesTasks;

  /// In different places update popup title
  ///
  /// In en, this message translates to:
  /// **'Voices update ready'**
  String get voicesUpdateReady;

  /// In different places update popup body
  ///
  /// In en, this message translates to:
  /// **'Click to restart'**
  String get clickToRestart;

  /// Name of space shown in different spaces that indicates its origin
  ///
  /// In en, this message translates to:
  /// **'Treasury space'**
  String get spaceTreasuryName;

  /// Name of space shown in different spaces that indicates its origin
  ///
  /// In en, this message translates to:
  /// **'Discovery space'**
  String get spaceDiscoveryName;

  /// Name of space shown in different spaces that indicates its origin
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get spaceWorkspaceName;

  /// Name of space shown in different spaces that indicates its origin
  ///
  /// In en, this message translates to:
  /// **'Voting space'**
  String get spaceVotingName;

  /// Name of space shown in different spaces that indicates its origin
  ///
  /// In en, this message translates to:
  /// **'Funded project space'**
  String get spaceFundedProjects;

  /// Refers to a lock action, i.e. to lock the session.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get lock;

  /// Refers to a unlock action, i.e. to unlock the session.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// Refers to a get started action, i.e. to register.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// Refers to guest user.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// Refers to user that created keychain but is locked
  ///
  /// In en, this message translates to:
  /// **'Visitor'**
  String get visitor;

  /// Text shown in the No Internet Connection Banner widget for the refresh button.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get noConnectionBannerRefreshButtonText;

  /// Text shown in the No Internet Connection Banner widget for the title.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noConnectionBannerTitle;

  /// Text shown in the No Internet Connection Banner widget for the description below the title.
  ///
  /// In en, this message translates to:
  /// **'Your internet is playing hide and seek. Check your internet connection, or try again in a moment.'**
  String get noConnectionBannerDescription;

  /// Describes a password that is weak
  ///
  /// In en, this message translates to:
  /// **'Weak password strength'**
  String get weakPasswordStrength;

  /// Describes a password that has medium strength.
  ///
  /// In en, this message translates to:
  /// **'Normal password strength'**
  String get normalPasswordStrength;

  /// Describes a password that is strong.
  ///
  /// In en, this message translates to:
  /// **'Good password strength'**
  String get goodPasswordStrength;

  /// A button label to select a cardano wallet.
  ///
  /// In en, this message translates to:
  /// **'Choose Cardano Wallet'**
  String get chooseCardanoWallet;

  /// A button label to select another cardano wallet.
  ///
  /// In en, this message translates to:
  /// **'Choose other wallet'**
  String get chooseOtherWallet;

  /// A label on a clickable element that can show more content.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// A header in link wallet flow in registration.
  ///
  /// In en, this message translates to:
  /// **'Link keys to your Catalyst Keychain'**
  String get walletLinkHeader;

  /// A subheader in link wallet flow in registration for wallet connection.
  ///
  /// In en, this message translates to:
  /// **'Link your Cardano wallet'**
  String get walletLinkWalletSubheader;

  /// A subheader in link wallet flow in registration for role chooser state.
  ///
  /// In en, this message translates to:
  /// **'Select your Catalyst roles'**
  String get walletLinkRolesSubheader;

  /// A subheader in link wallet flow in registration for RBAC transaction.
  ///
  /// In en, this message translates to:
  /// **'Sign your Catalyst roles to the\nCardano mainnet'**
  String get walletLinkTransactionSubheader;

  /// A title in link wallet flow on intro screen.
  ///
  /// In en, this message translates to:
  /// **'Link Cardano Wallet & Catalyst Roles to you Catalyst Keychain.'**
  String get walletLinkIntroTitle;

  /// A message (content) in link wallet flow on intro screen.
  ///
  /// In en, this message translates to:
  /// **'You\'re almost there! This is the final and most important step in your account setup.\n\nWe\'re going to link a Cardano Wallet to your Catalyst Keychain, so you can start collecting Role Keys.\n\nRole Keys allow you to enter new spaces, discover new ways to participate, and unlock new ways to earn rewards.\n\nWe\'ll start with your Voter Key by default. You can decide to add a Proposer Key and Drep key if you want, or you can always add them later.'**
  String get walletLinkIntroContent;

  /// A title in link wallet flow on select wallet screen.
  ///
  /// In en, this message translates to:
  /// **'Select the Cardano wallet to link\nto your Catalyst Keychain.'**
  String get walletLinkSelectWalletTitle;

  /// A message (content) in link wallet flow on select wallet screen.
  ///
  /// In en, this message translates to:
  /// **'To complete this action, you\'ll submit a signed transaction to Cardano. There will be an ADA transaction fee.'**
  String get walletLinkSelectWalletContent;

  /// A title in link wallet flow on wallet details screen.
  ///
  /// In en, this message translates to:
  /// **'Cardano wallet detection'**
  String get walletLinkWalletDetailsTitle;

  /// A message in link wallet flow on wallet details screen.
  ///
  /// In en, this message translates to:
  /// **'{wallet} connected successfully!'**
  String walletLinkWalletDetailsContent(String wallet);

  /// A message in link wallet flow on wallet details screen when a user wallet doesn't have enough balance.
  ///
  /// In en, this message translates to:
  /// **'Wallet and role registrations require a minimal transaction fee. You can setup your default dApp connector wallet in your browser extension settings.'**
  String get walletLinkWalletDetailsNotice;

  /// A message recommending the user to top up ADA in wallet link on wallet details screen.
  ///
  /// In en, this message translates to:
  /// **'Top up ADA'**
  String get walletLinkWalletDetailsNoticeTopUp;

  /// A link to top-up provide when the user doesn't have enough balance on wallet link screen
  ///
  /// In en, this message translates to:
  /// **'Link to top-up provider'**
  String get walletLinkWalletDetailsNoticeTopUpLink;

  /// A title in link wallet flow on transaction screen.
  ///
  /// In en, this message translates to:
  /// **'Let\'s make sure everything looks right.'**
  String get walletLinkTransactionTitle;

  /// A subtitle in link wallet flow on transaction screen.
  ///
  /// In en, this message translates to:
  /// **'Account completion for Catalyst'**
  String get walletLinkTransactionAccountCompletion;

  /// An item in the transaction summary for the wallet link.
  ///
  /// In en, this message translates to:
  /// **'1 Link {wallet} to Catalyst Keychain'**
  String walletLinkTransactionLinkItem(String wallet);

  /// A side note on transaction summary in the wallet link explaining the positives about the registration.
  ///
  /// In en, this message translates to:
  /// **'Positive small print'**
  String get walletLinkTransactionPositiveSmallPrint;

  /// The first item for the positive small print message.
  ///
  /// In en, this message translates to:
  /// **'Your registration is a one time event, cost will not renew periodically.'**
  String get walletLinkTransactionPositiveSmallPrintItem1;

  /// The second item for the positive small print message.
  ///
  /// In en, this message translates to:
  /// **'Your registrations can be found under your account profile after completion.'**
  String get walletLinkTransactionPositiveSmallPrintItem2;

  /// The third item for the positive small print message.
  ///
  /// In en, this message translates to:
  /// **'All registration fees go into the Cardano Treasury.'**
  String get walletLinkTransactionPositiveSmallPrintItem3;

  /// The primary button label to sign a transaction on transaction summary screen.
  ///
  /// In en, this message translates to:
  /// **'Sign transaction with wallet'**
  String get walletLinkTransactionSign;

  /// The secondary button label to change the roles on transaction summary screen.
  ///
  /// In en, this message translates to:
  /// **'Change role setup'**
  String get walletLinkTransactionChangeRoles;

  /// An item in the transaction summary for the role registration
  ///
  /// In en, this message translates to:
  /// **'1 {role} registration to Catalyst Keychain'**
  String walletLinkTransactionRoleItem(String role);

  /// Indicates an error when submitting a registration transaction failed.
  ///
  /// In en, this message translates to:
  /// **'Transaction failed'**
  String get registrationTransactionFailed;

  /// Indicates an error when preparing a transaction has failed due to low wallet balance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance, please top up your wallet.'**
  String get registrationInsufficientBalance;

  /// A title on the role chooser screen in registration.
  ///
  /// In en, this message translates to:
  /// **'How do you want to participate in Catalyst?'**
  String get walletLinkRoleChooserTitle;

  /// A message on the role chooser screen in registration.
  ///
  /// In en, this message translates to:
  /// **'In Catalyst you can take on different roles, learn more below and choose your additional roles now.'**
  String get walletLinkRoleChooserContent;

  /// A title on the role summary screen in registration.
  ///
  /// In en, this message translates to:
  /// **'Is this your correct Catalyst role setup?'**
  String get walletLinkRoleSummaryTitle;

  /// The first part of the message on the role summary screen in registration.
  ///
  /// In en, this message translates to:
  /// **'You would like to register '**
  String get walletLinkRoleSummaryContent1;

  /// The middle (bold) part of the message on the role summary screen in registration.
  ///
  /// In en, this message translates to:
  /// **'{count} active {count, plural, =0{roles} =1{role} other{roles}}'**
  String walletLinkRoleSummaryContent2(num count);

  /// The last part of the message on the role summary screen in registration.
  ///
  /// In en, this message translates to:
  /// **' in Catalyst.'**
  String get walletLinkRoleSummaryContent3;

  /// A button label on the role summary screen in registration for the next step.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Sign with wallet'**
  String get walletLinkRoleSummaryButton;

  /// Message shown when redirecting to external content that describes which wallets are supported.
  ///
  /// In en, this message translates to:
  /// **'See all supported wallets'**
  String get seeAllSupportedWallets;

  /// Message shown when presenting the details of a connected wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet detection summary'**
  String get walletDetectionSummary;

  /// The wallet balance in terms of Ada.
  ///
  /// In en, this message translates to:
  /// **'Wallet balance'**
  String get walletBalance;

  /// A cardano wallet address
  ///
  /// In en, this message translates to:
  /// **'Wallet address'**
  String get walletAddress;

  /// No description provided for @accountCreationCreate.
  ///
  /// In en, this message translates to:
  /// **'Create a new  Catalyst Keychain'**
  String get accountCreationCreate;

  /// No description provided for @accountCreationRecover.
  ///
  /// In en, this message translates to:
  /// **'Recover your Catalyst Keychain'**
  String get accountCreationRecover;

  /// Indicates that created keychain will be stored in this device only
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get accountCreationOnThisDevice;

  /// No description provided for @accountCreationGetStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Catalyst'**
  String get accountCreationGetStartedTitle;

  /// No description provided for @accountCreationGetStatedDesc.
  ///
  /// In en, this message translates to:
  /// **'If you already have a Catalyst keychain you can restore it on this device, or you can create a new Catalyst Keychain.'**
  String get accountCreationGetStatedDesc;

  /// No description provided for @accountCreationGetStatedWhatNext.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do?'**
  String get accountCreationGetStatedWhatNext;

  /// Title of My Account page
  ///
  /// In en, this message translates to:
  /// **'My Account / Profile & Keychain'**
  String get myAccountProfileKeychain;

  /// Subtitle of My Account page
  ///
  /// In en, this message translates to:
  /// **'Your Catalyst keychain & role registration'**
  String get yourCatalystKeychainAndRoleRegistration;

  /// Tab on My Account page
  ///
  /// In en, this message translates to:
  /// **'Profile & Keychain'**
  String get profileAndKeychain;

  /// Action on Catalyst Keychain card
  ///
  /// In en, this message translates to:
  /// **'Remove Keychain'**
  String get removeKeychain;

  /// Describes that wallet is connected on Catalyst Keychain card
  ///
  /// In en, this message translates to:
  /// **'Wallet connected'**
  String get walletConnected;

  /// Describes roles on Catalyst Keychain card
  ///
  /// In en, this message translates to:
  /// **'Current Role registrations'**
  String get currentRoleRegistrations;

  /// Account role
  ///
  /// In en, this message translates to:
  /// **'Voter'**
  String get voter;

  /// Account role
  ///
  /// In en, this message translates to:
  /// **'Proposer'**
  String get proposer;

  /// Account role
  ///
  /// In en, this message translates to:
  /// **'Drep'**
  String get drep;

  /// Related to account role
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultRole;

  /// No description provided for @catalystKeychain.
  ///
  /// In en, this message translates to:
  /// **'Catalyst Keychain'**
  String get catalystKeychain;

  /// No description provided for @accountCreationSplashTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your Catalyst Keychain'**
  String get accountCreationSplashTitle;

  /// No description provided for @accountCreationSplashMessage.
  ///
  /// In en, this message translates to:
  /// **'Your keychain is your ticket to participate in  distributed innovation on the global stage.    Once you have it, you\'ll be able to enter different spaces, discover awesome ideas, and share your feedback to hep improve ideas.    As you add new keys to your keychain, you\'ll be able to enter new spaces, unlock new rewards opportunities, and have your voice heard in community decisions.'**
  String get accountCreationSplashMessage;

  /// No description provided for @accountCreationSplashNextButton.
  ///
  /// In en, this message translates to:
  /// **'Create your Keychain now'**
  String get accountCreationSplashNextButton;

  /// No description provided for @accountInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Great! Your Catalyst Keychain  has been created.'**
  String get accountInstructionsTitle;

  /// No description provided for @accountInstructionsMessage.
  ///
  /// In en, this message translates to:
  /// **'On the next screen, you\'re going to see 12 words.  This is called your \"seed phrase\".     It\'s like a super secure password that only you know,  that allows you to prove ownership of your keychain.    You\'ll use it to login and recover your account on  different devices, so be sure to put it somewhere safe!\n\nYou need to write this seed phrase down with pen and paper, so get this ready.'**
  String get accountInstructionsMessage;

  /// For example in button that goes to next stage of registration
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// For example in button that goes to previous stage of registration
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Retry action when something goes wrong.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Error description when something goes wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// A description when no wallet extension was found.
  ///
  /// In en, this message translates to:
  /// **'No wallet found.'**
  String get noWalletFound;

  /// A title on delete keychain dialog
  ///
  /// In en, this message translates to:
  /// **'Delete Keychain?'**
  String get deleteKeychainDialogTitle;

  /// A subtitle on delete keychain dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you wants to delete your\nCatalyst Keychain from this device?'**
  String get deleteKeychainDialogSubtitle;

  /// A warning on delete keychain dialog
  ///
  /// In en, this message translates to:
  /// **'Make sure you have a working Catalyst 12-word seedphrase!'**
  String get deleteKeychainDialogWarning;

  /// A warning info on delete keychain dialog
  ///
  /// In en, this message translates to:
  /// **'Your Catalyst account will be removed,\nthis action cannot be undone!'**
  String get deleteKeychainDialogWarningInfo;

  /// A typing info on delete keychain dialog
  ///
  /// In en, this message translates to:
  /// **'To avoid mistakes, please type ‘Remove Keychain’ below.'**
  String get deleteKeychainDialogTypingInfo;

  /// An input label on delete keychain dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm removal'**
  String get deleteKeychainDialogInputLabel;

  /// An error text on text field on delete keychain dialog
  ///
  /// In en, this message translates to:
  /// **'Error. Please type \'Remove keychain\' to remove your account from this device.'**
  String get deleteKeychainDialogErrorText;

  /// A removing phrase on delete keychain dialog
  ///
  /// In en, this message translates to:
  /// **'Remove Keychain'**
  String get deleteKeychainDialogRemovingPhrase;

  /// A title on account role dialog
  ///
  /// In en, this message translates to:
  /// **'Learn about Catalyst Roles'**
  String get accountRoleDialogTitle;

  /// A label on account role dialog's button
  ///
  /// In en, this message translates to:
  /// **'Continue Role setup'**
  String get accountRoleDialogButton;

  /// A title for role summary on account role dialog
  ///
  /// In en, this message translates to:
  /// **'{role} role summary'**
  String accountRoleDialogRoleSummaryTitle(String role);

  /// A verbose name for voter
  ///
  /// In en, this message translates to:
  /// **'Treasury guardian'**
  String get voterVerboseName;

  /// A verbose name for proposer
  ///
  /// In en, this message translates to:
  /// **'Main proposer'**
  String get proposerVerboseName;

  /// A verbose name for drep
  ///
  /// In en, this message translates to:
  /// **'Community expert'**
  String get drepVerboseName;

  /// A description for voter
  ///
  /// In en, this message translates to:
  /// **'The Voters are the guardians of Cardano treasury. They vote in projects for the growth of the Cardano Ecosystem.'**
  String get voterDescription;

  /// A description for proposer
  ///
  /// In en, this message translates to:
  /// **'The Main Proposers are the Innovators in Project Catalyst, they are the shapers of the future.'**
  String get proposerDescription;

  /// A description for drep
  ///
  /// In en, this message translates to:
  /// **'The dRep has an Expert Role in the Cardano/Catalyst as people can delegate their vote to Cardano Experts.'**
  String get drepDescription;

  /// No description provided for @voterSummarySelectFavorites.
  ///
  /// In en, this message translates to:
  /// **'Select favorites'**
  String get voterSummarySelectFavorites;

  /// No description provided for @voterSummaryComment.
  ///
  /// In en, this message translates to:
  /// **'Comment/Vote on Proposals'**
  String get voterSummaryComment;

  /// No description provided for @voterSummaryCastVotes.
  ///
  /// In en, this message translates to:
  /// **'Cast your votes'**
  String get voterSummaryCastVotes;

  /// No description provided for @voterSummaryVoterRewards.
  ///
  /// In en, this message translates to:
  /// **'Voter rewards'**
  String get voterSummaryVoterRewards;

  /// No description provided for @proposerSummaryWriteEdit.
  ///
  /// In en, this message translates to:
  /// **'Write/edit functionality'**
  String get proposerSummaryWriteEdit;

  /// No description provided for @proposerSummarySubmitToFund.
  ///
  /// In en, this message translates to:
  /// **'Rights to Submit to Fund'**
  String get proposerSummarySubmitToFund;

  /// No description provided for @proposerSummaryInviteTeamMembers.
  ///
  /// In en, this message translates to:
  /// **'Invite Team Members'**
  String get proposerSummaryInviteTeamMembers;

  /// No description provided for @proposerSummaryComment.
  ///
  /// In en, this message translates to:
  /// **'Comment functionality'**
  String get proposerSummaryComment;

  /// No description provided for @drepSummaryDelegatedVotes.
  ///
  /// In en, this message translates to:
  /// **'Delegated Votes'**
  String get drepSummaryDelegatedVotes;

  /// No description provided for @drepSummaryRewards.
  ///
  /// In en, this message translates to:
  /// **'dRep rewards'**
  String get drepSummaryRewards;

  /// No description provided for @drepSummaryCastVotes.
  ///
  /// In en, this message translates to:
  /// **'Cast delegated votes'**
  String get drepSummaryCastVotes;

  /// No description provided for @drepSummaryComment.
  ///
  /// In en, this message translates to:
  /// **'Comment Functionality'**
  String get drepSummaryComment;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @notice.
  ///
  /// In en, this message translates to:
  /// **'Notice'**
  String get notice;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'file'**
  String get file;

  /// No description provided for @key.
  ///
  /// In en, this message translates to:
  /// **'key'**
  String get key;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @browse.
  ///
  /// In en, this message translates to:
  /// **'browse'**
  String get browse;

  /// An info on upload dialog
  ///
  /// In en, this message translates to:
  /// **'Drop your {itemNameToUpload} here or '**
  String uploadDropInfo(String itemNameToUpload);

  /// No description provided for @uploadProgressInfo.
  ///
  /// In en, this message translates to:
  /// **'Upload in progress'**
  String get uploadProgressInfo;

  /// A title on keychain upload dialog
  ///
  /// In en, this message translates to:
  /// **'Upload Catalyst Keychain'**
  String get uploadKeychainTitle;

  /// An info on keychain upload dialog
  ///
  /// In en, this message translates to:
  /// **'Make sure it\'s a correct Catalyst keychain file.'**
  String get uploadKeychainInfo;

  /// Refers to a light theme mode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Refers to a dark theme mode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// A title on keychain deleted dialog
  ///
  /// In en, this message translates to:
  /// **'Catalyst keychain removed'**
  String get keychainDeletedDialogTitle;

  /// A subtitle on keychain deleted dialog
  ///
  /// In en, this message translates to:
  /// **'Catalyst keychain removed'**
  String get keychainDeletedDialogSubtitle;

  /// An info on keychain deleted dialog
  ///
  /// In en, this message translates to:
  /// **'Catalyst keychain removed'**
  String get keychainDeletedDialogInfo;

  /// No description provided for @createKeychainSeedPhraseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write down your 12 Catalyst  security words'**
  String get createKeychainSeedPhraseSubtitle;

  /// No description provided for @createKeychainSeedPhraseBody.
  ///
  /// In en, this message translates to:
  /// **'Make sure you create an offline backup of your recovery phrase as well.'**
  String get createKeychainSeedPhraseBody;

  /// No description provided for @createKeychainSeedPhraseDownload.
  ///
  /// In en, this message translates to:
  /// **'Download Catalyst key'**
  String get createKeychainSeedPhraseDownload;

  /// No description provided for @createKeychainSeedPhraseStoreConfirmation.
  ///
  /// In en, this message translates to:
  /// **'I have written down/downloaded my 12 words'**
  String get createKeychainSeedPhraseStoreConfirmation;

  /// No description provided for @createKeychainSeedPhraseCheckInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your Catalyst security keys'**
  String get createKeychainSeedPhraseCheckInstructionsTitle;

  /// No description provided for @createKeychainSeedPhraseCheckInstructionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Next, we\'re going to make sure that you\'ve written down your words correctly.     We don\'t save your seed phrase, so it\'s important  to make sure you have it right. That\'s why we do this confirmation before continuing.     It\'s also good practice to get familiar with using a seed phrase if you\'re new to crypto.'**
  String get createKeychainSeedPhraseCheckInstructionsSubtitle;

  /// No description provided for @createKeychainSeedPhraseCheckSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Input your Catalyst security keys'**
  String get createKeychainSeedPhraseCheckSubtitle;

  /// No description provided for @createKeychainSeedPhraseCheckBody.
  ///
  /// In en, this message translates to:
  /// **'Select your 12 written down words in  the correct order.'**
  String get createKeychainSeedPhraseCheckBody;

  /// When user checks correct seed phrase words order he can upload it too
  ///
  /// In en, this message translates to:
  /// **'Upload Catalyst Key'**
  String get uploadCatalystKey;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @createKeychainSeedPhraseCheckSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Nice job! You\'ve successfully verified the seed phrase for your keychain.'**
  String get createKeychainSeedPhraseCheckSuccessTitle;

  /// No description provided for @createKeychainSeedPhraseCheckSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your seed phrase to recover your Catalyst Keychain on any device.  It\'s kinda like your email and password all rolled into one, so keep it somewhere safe!  In the next step we’ll add a password to your Catalyst Keychain, so you can lock/unlock access to Voices.'**
  String get createKeychainSeedPhraseCheckSuccessSubtitle;

  /// No description provided for @yourNextStep.
  ///
  /// In en, this message translates to:
  /// **'Your next step'**
  String get yourNextStep;

  /// No description provided for @createKeychainSeedPhraseCheckSuccessNextStep.
  ///
  /// In en, this message translates to:
  /// **'Now let’s set your Unlock password for this device!'**
  String get createKeychainSeedPhraseCheckSuccessNextStep;

  /// No description provided for @createKeychainUnlockPasswordInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your Catalyst unlock password  for this device'**
  String get createKeychainUnlockPasswordInstructionsTitle;

  /// No description provided for @createKeychainUnlockPasswordInstructionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'With over 300 trillion possible combinations, your 12 word seed phrase is great for keeping your account safe.    But it can be a bit tedious to enter every single time you want to use the app.    In this next step, you\'ll set your Unlock Password for your current device. It\'s like a shortcut for proving ownership of your Keychain.    Whenever you recover your account for the first time on a new device, you\'ll need to use your Catalyst Keychain to get started. Every time after that, you can use your Unlock Password to quickly regain access.'**
  String get createKeychainUnlockPasswordInstructionsSubtitle;

  /// No description provided for @createKeychainCreatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Congratulations your Catalyst  Keychain is created!'**
  String get createKeychainCreatedTitle;

  /// No description provided for @createKeychainCreatedNextStep.
  ///
  /// In en, this message translates to:
  /// **'In the next step you write your Catalyst roles and  account to the Cardano Mainnet.'**
  String get createKeychainCreatedNextStep;

  /// No description provided for @createKeychainLinkWalletAndRoles.
  ///
  /// In en, this message translates to:
  /// **'Link your Cardano Wallet & Roles'**
  String get createKeychainLinkWalletAndRoles;

  /// No description provided for @registrationCreateKeychainStepGroup.
  ///
  /// In en, this message translates to:
  /// **'Catalyst Keychain created'**
  String get registrationCreateKeychainStepGroup;

  /// No description provided for @registrationLinkWalletStepGroup.
  ///
  /// In en, this message translates to:
  /// **'Link Cardano Wallet & Roles'**
  String get registrationLinkWalletStepGroup;

  /// No description provided for @registrationCompletedStepGroup.
  ///
  /// In en, this message translates to:
  /// **'Catalyst account creation completed!'**
  String get registrationCompletedStepGroup;

  /// No description provided for @createKeychainUnlockPasswordIntoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Catalyst unlock password'**
  String get createKeychainUnlockPasswordIntoSubtitle;

  /// No description provided for @createKeychainUnlockPasswordIntoBody.
  ///
  /// In en, this message translates to:
  /// **'Please provide a password for your Catalyst Keychain.'**
  String get createKeychainUnlockPasswordIntoBody;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get enterPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @xCharactersMinimum.
  ///
  /// In en, this message translates to:
  /// **'{number} characters minimum length'**
  String xCharactersMinimum(int number);

  /// When user confirms password but it does not match original one.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match, please correct'**
  String get passwordDoNotMatch;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @registrationExitConfirmDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Account creation incomplete!'**
  String get registrationExitConfirmDialogSubtitle;

  /// No description provided for @registrationExitConfirmDialogContent.
  ///
  /// In en, this message translates to:
  /// **'If attempt to leave without creating your keychain - account creation will be incomplete.   You are not able to login without  completing your keychain.'**
  String get registrationExitConfirmDialogContent;

  /// No description provided for @registrationExitConfirmDialogContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue keychain creation'**
  String get registrationExitConfirmDialogContinue;

  /// No description provided for @registrationExitConfirmDialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel anyway'**
  String get registrationExitConfirmDialogCancel;

  /// No description provided for @recoverCatalystKeychain.
  ///
  /// In en, this message translates to:
  /// **'Restore Catalyst keychain'**
  String get recoverCatalystKeychain;

  /// No description provided for @recoverKeychainMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore your Catalyst Keychain'**
  String get recoverKeychainMethodsTitle;

  /// No description provided for @recoverKeychainMethodsNoKeychainFound.
  ///
  /// In en, this message translates to:
  /// **'No Catalyst Keychain found on this device.'**
  String get recoverKeychainMethodsNoKeychainFound;

  /// No description provided for @recoverKeychainMethodsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Not to worry, in the next step you can choose the recovery option that applies to you for this device!'**
  String get recoverKeychainMethodsSubtitle;

  /// No description provided for @recoverKeychainMethodsListTitle.
  ///
  /// In en, this message translates to:
  /// **'How do you want Restore your Catalyst Keychain?'**
  String get recoverKeychainMethodsListTitle;

  /// No description provided for @recoverKeychainNonFound.
  ///
  /// In en, this message translates to:
  /// **'No Catalyst Keychain found on this device.'**
  String get recoverKeychainNonFound;

  /// No description provided for @recoverKeychainFound.
  ///
  /// In en, this message translates to:
  /// **'Keychain found!   Please unlock your device.'**
  String get recoverKeychainFound;

  /// No description provided for @seedPhrase12Words.
  ///
  /// In en, this message translates to:
  /// **'12 security words'**
  String get seedPhrase12Words;

  /// No description provided for @recoverySeedPhraseInstructionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore your Catalyst Keychain with  your 12 security words.'**
  String get recoverySeedPhraseInstructionsTitle;

  /// No description provided for @recoverySeedPhraseInstructionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your security words in the correct order, and sign into your Catalyst account on a new device.'**
  String get recoverySeedPhraseInstructionsSubtitle;

  /// No description provided for @recoverySeedPhraseInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore your Catalyst Keychain with  your 12 security words'**
  String get recoverySeedPhraseInputTitle;

  /// No description provided for @recoverySeedPhraseInputSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter each word of your Catalyst Key in the right order  to bring your Catalyst account to this device.'**
  String get recoverySeedPhraseInputSubtitle;

  /// No description provided for @recoveryAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalyst account recovery'**
  String get recoveryAccountTitle;

  /// No description provided for @recoveryAccountDetailsAction.
  ///
  /// In en, this message translates to:
  /// **'Set unlock password for this device'**
  String get recoveryAccountDetailsAction;
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
