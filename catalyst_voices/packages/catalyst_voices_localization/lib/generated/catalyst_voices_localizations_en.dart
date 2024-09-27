import 'package:intl/intl.dart' as intl;

import 'catalyst_voices_localizations.dart';

// ignore_for_file: type=lint

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
  String get cancelButtonText => 'Cancel';

  @override
  String get editButtonText => 'Edit';

  @override
  String get headerTooltipText => 'Header';

  @override
  String get placeholderRichText => 'Start writing your text...';

  @override
  String get supportingTextLabelText => 'Supporting text';

  @override
  String get saveButtonText => 'Save';

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

  @override
  String get comingSoonSubtitle => 'Voices';

  @override
  String get comingSoonTitle1 => 'Coming';

  @override
  String get comingSoonTitle2 => 'soon';

  @override
  String get comingSoonDescription => 'Project Catalyst is the world\'s largest decentralized innovation engine for solving real-world challenges.';

  @override
  String get connectingStatusLabelText => 're-connecting';

  @override
  String get finishAccountButtonLabelText => 'Finish account';

  @override
  String get getStartedButtonLabelText => 'Get Started';

  @override
  String get unlockButtonLabelText => 'Unlock';

  @override
  String get userProfileGuestLabelText => 'Guest';

  @override
  String get searchButtonLabelText => '[cmd=K]';

  @override
  String get snackbarInfoLabelText => 'Info';

  @override
  String get snackbarInfoMessageText => 'This is an info message!';

  @override
  String get snackbarSuccessLabelText => 'Success';

  @override
  String get snackbarSuccessMessageText => 'This is a success message!';

  @override
  String get snackbarWarningLabelText => 'Warning';

  @override
  String get snackbarWarningMessageText => 'This is a warning message!';

  @override
  String get snackbarErrorLabelText => 'Error';

  @override
  String get snackbarErrorMessageText => 'This is an error message!';

  @override
  String get snackbarRefreshButtonText => 'Refresh';

  @override
  String get snackbarMoreButtonText => 'Learn more';

  @override
  String get snackbarOkButtonText => 'Ok';

  @override
  String seedPhraseSlotNr(int nr) {
    return 'Slot $nr';
  }

  @override
  String get proposalStatusReady => 'Ready';

  @override
  String get proposalStatusDraft => 'Draft';

  @override
  String get proposalStatusInProgress => 'In progress';

  @override
  String get proposalStatusPrivate => 'Private';

  @override
  String get proposalStatusLive => 'LIVE';

  @override
  String get proposalStatusCompleted => 'Completed';

  @override
  String get proposalStatusOpen => 'Open';

  @override
  String get fundedProposal => 'Funded proposal';

  @override
  String get publishedProposal => 'Published proposal';

  @override
  String fundedProposalDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Funded $dateString';
  }

  @override
  String lastUpdateDate(String date) {
    return 'Last update: $date.';
  }

  @override
  String get fundsRequested => 'Funds requested';

  @override
  String noOfComments(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'comments',
      one: 'comment',
      zero: 'comments',
    );
    return '$countString $_temp0';
  }

  @override
  String noOfSegmentsCompleted(num completed, num total, num percentage) {
    final intl.NumberFormat completedNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String completedString = completedNumberFormat.format(completed);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String totalString = totalNumberFormat.format(total);
    final intl.NumberFormat percentageNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String percentageString = percentageNumberFormat.format(percentage);

    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'segments',
      one: 'segment',
      zero: 'segments',
    );
    return '$completedString of $totalString ($percentageString%) $_temp0 completed';
  }

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get twoDaysAgo => '2 days ago';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get activeVotingRound => 'Active voting round 14';

  @override
  String noOfAllProposals(int count) {
    return 'All proposals ($count)';
  }

  @override
  String get favorites => 'Favorites';

  @override
  String get treasuryCampaignBuilder => 'Campaign builder';

  @override
  String get treasuryCampaignBuilderSegments => 'Segments';

  @override
  String get treasuryCampaignSetup => 'Setup Campaign';

  @override
  String get treasuryCampaignTitle => 'Campaign title';

  @override
  String get stepEdit => 'Edit';

  @override
  String get workspaceProposalNavigation => 'Proposal navigation';

  @override
  String get workspaceProposalNavigationSegments => 'Segments';

  @override
  String get workspaceProposalSetup => 'Proposal setup';

  @override
  String get drawerSpaceTreasury => 'Treasury';

  @override
  String get drawerSpaceDiscovery => 'Discovery';

  @override
  String get drawerSpaceWorkspace => 'Workspace';

  @override
  String get drawerSpaceVoting => 'Voting';

  @override
  String get drawerSpaceFundedProjects => 'Funded projects';

  @override
  String get fundedProjectSpace => 'Funded project space';

  @override
  String noOfFundedProposals(int count) {
    return 'Funded proposals ($count)';
  }

  @override
  String get followed => 'Followed';

  @override
  String get overallSpacesSearchBrands => 'Search Brands';

  @override
  String get overallSpacesTasks => 'Tasks';

  @override
  String get voicesUpdateReady => 'Voices update ready';

  @override
  String get clickToRestart => 'Click to restart';

  @override
  String get spaceTreasuryName => 'Treasury space';

  @override
  String get spaceDiscoveryName => 'Discovery space';

  @override
  String get spaceWorkspaceName => 'Workspace';

  @override
  String get spaceVotingName => 'Voting space';

  @override
  String get spaceFundedProjects => 'Funded project space';

  @override
  String get lock => 'Lock';

  @override
  String get unlock => 'Unlock';

  @override
  String get getStarted => 'Get Started';

  @override
  String get guest => 'Guest';

  @override
  String get visitor => 'Visitor';

  @override
  String get noConnectionBannerRefreshButtonText => 'Refresh';

  @override
  String get noConnectionBannerTitle => 'No internet connection';

  @override
  String get noConnectionBannerDescription => 'Your internet is playing hide and seek. Check your internet connection, or try again in a moment.';

  @override
  String get weakPasswordStrength => 'Weak password strength';

  @override
  String get normalPasswordStrength => 'Normal password strength';

  @override
  String get goodPasswordStrength => 'Good password strength';

  @override
  String get chooseCardanoWallet => 'Choose Cardano Wallet';

  @override
  String get learnMore => 'Learn More';

  @override
  String get walletLinkHeader => 'Link keys to your Catalyst Keychain';

  @override
  String get walletLinkWalletSubheader => 'Link your Cardano wallet';

  @override
  String get walletLinkRolesSubheader => 'Select your Catalyst roles';

  @override
  String get walletLinkTransactionSubheader => 'Sign your Catalyst roles to the\nCardano mainnet';

  @override
  String get walletLinkIntroTitle => 'Link Cardano Wallet & Catalyst Roles to you Catalyst Keychain.';

  @override
  String get walletLinkIntroContent => 'You\'re almost there! This is the final and most important step in your account setup.\n\nWe\'re going to link a Cardano Wallet to your Catalyst Keychain, so you can start collecting Role Keys.\n\nRole Keys allow you to enter new spaces, discover new ways to participate, and unlock new ways to earn rewards.\n\nWe\'ll start with your Voter Key by default. You can decide to add a Proposer Key and Drep key if you want, or you can always add them later.';

  @override
  String get walletLinkSelectWalletTitle => 'Select the Cardano wallet to link\nto your Catalyst Keychain.';

  @override
  String get walletLinkSelectWalletContent => 'To complete this action, you\'ll submit a signed transaction to Cardano. There will be an ADA transaction fee.';

  @override
  String get seeAllSupportedWallets => 'See all supported wallets';

  @override
  String get accountCreationCreate => 'Create a new  Catalyst Keychain';

  @override
  String get accountCreationRecover => 'Recover your Catalyst Keychain';

  @override
  String get accountCreationOnThisDevice => 'On this device';

  @override
  String get accountCreationGetStartedTitle => 'Welcome to Catalyst';

  @override
  String get accountCreationGetStatedDesc => 'If you already have a Catalyst keychain you can restore it on this device, or you can create a new Catalyst Keychain.';

  @override
  String get accountCreationGetStatedWhatNext => 'What do you want to do?';

  @override
  String get myAccountProfileKeychain => 'My Account / Profile & Keychain';

  @override
  String get yourCatalystKeychainAndRoleRegistration => 'Your Catalyst keychain & role registration';

  @override
  String get profileAndKeychain => 'Profile & Keychain';

  @override
  String get removeKeychain => 'Remove Keychain';

  @override
  String get walletConnected => 'Wallet connected';

  @override
  String get currentRoleRegistrations => 'Current Role registrations';

  @override
  String get voter => 'Voter';

  @override
  String get proposer => 'Proposer';

  @override
  String get drep => 'Drep';

  @override
  String get defaultRole => 'Default';

  @override
  String get catalystKeychain => 'Catalyst Keychain';

  @override
  String get accountCreationSplashTitle => 'Create your Catalyst Keychain';

  @override
  String get accountCreationSplashMessage => 'Your keychain is your ticket to participate in  distributed innovation on the global stage.    Once you have it, you\'ll be able to enter different spaces, discover awesome ideas, and share your feedback to hep improve ideas.    As you add new keys to your keychain, you\'ll be able to enter new spaces, unlock new rewards opportunities, and have your voice heard in community decisions.';

  @override
  String get accountCreationSplashNextButton => 'Create your Keychain now';

  @override
  String get accountInstructionsTitle => 'Great! Your Catalyst Keychain  has been created.';

  @override
  String get accountInstructionsMessage => 'On the next screen, you\'re going to see 12 words.  This is called your \"seed phrase\".     It\'s like a super secure password that only you know,  that allows you to prove ownership of your keychain.    You\'ll use it to login and recover your account on  different devices, so be sure to put it somewhere safe!\n\nYou need to write this seed phrase down with pen and paper, so get this ready.';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get retry => 'Retry';

  @override
  String get somethingWentWrong => 'Something went wrong.';

  @override
  String get noWalletFound => 'No wallet found.';

  @override
  String get createKeychainSeedPhraseSubtitle => 'Write down your 12 Catalyst  security words';

  @override
  String get createKeychainSeedPhraseBody => 'Make sure you create an offline backup of your recovery phrase as well.';

  @override
  String get createKeychainSeedPhraseDownload => 'Download Catalyst key';

  @override
  String get createKeychainSeedPhraseStoreConfirmation => 'I have written down/downloaded my 12 words';
}
