import 'package:intl/intl.dart' as intl;

import 'catalyst_voices_localizations.dart';

// ignore_for_file: type=lint

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
  String get passwordLabelText => 'Contraseña';

  @override
  String get passwordHintText => 'Mi1ContraseñaSecreta';

  @override
  String get passwordErrorText => 'La contraseña debe tener al menos 8 caracteres';

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
  String get chooseOtherWallet => 'Choose other wallet';

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
  String get walletLinkWalletDetailsTitle => 'Cardano wallet detection';

  @override
  String walletLinkWalletDetailsContent(String wallet) {
    return '$wallet connected successfully!';
  }

  @override
  String get walletLinkWalletDetailsNotice => 'Wallet and role registrations require a minimal transaction fee. You can setup your default dApp connector wallet in your browser extension settings.';

  @override
  String get walletLinkWalletDetailsNoticeTopUp => 'Top up ADA';

  @override
  String get walletLinkWalletDetailsNoticeTopUpLink => 'Link to top-up provider';

  @override
  String get walletLinkTransactionTitle => 'Let\'s make sure everything looks right.';

  @override
  String get walletLinkTransactionAccountCompletion => 'Account completion for Catalyst';

  @override
  String walletLinkTransactionLinkItem(String wallet) {
    return '1 Link $wallet to Catalyst Keychain';
  }

  @override
  String get walletLinkTransactionPositiveSmallPrint => 'Positive small print';

  @override
  String get walletLinkTransactionPositiveSmallPrintItem1 => 'Your registration is a one time event, cost will not renew periodically.';

  @override
  String get walletLinkTransactionPositiveSmallPrintItem2 => 'Your registrations can be found under your account profile after completion.';

  @override
  String get walletLinkTransactionPositiveSmallPrintItem3 => 'All registration fees go into the Cardano Treasury.';

  @override
  String get walletLinkTransactionSign => 'Sign transaction with wallet';

  @override
  String get walletLinkTransactionChangeRoles => 'Change role setup';

  @override
  String walletLinkTransactionRoleItem(String role) {
    return '1 $role registration to Catalyst Keychain';
  }

  @override
  String get registrationTransactionFailed => 'Transaction failed';

  @override
  String get registrationInsufficientBalance => 'Insufficient balance, please top up your wallet.';

  @override
  String get registrationSeedPhraseNotFound => 'Seed phrase was not found. Make sure correct words are correct.';

  @override
  String get walletLinkRoleChooserTitle => 'How do you want to participate in Catalyst?';

  @override
  String get walletLinkRoleChooserContent => 'In Catalyst you can take on different roles, learn more below and choose your additional roles now.';

  @override
  String get walletLinkRoleSummaryTitle => 'Is this your correct Catalyst role setup?';

  @override
  String get walletLinkRoleSummaryContent1 => 'You would like to register ';

  @override
  String walletLinkRoleSummaryContent2(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
      
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'roles',
      one: 'role',
      zero: 'roles',
    );
    return '$countString active $_temp0';
  }

  @override
  String get walletLinkRoleSummaryContent3 => ' in Catalyst.';

  @override
  String get walletLinkRoleSummaryButton => 'Confirm & Sign with wallet';

  @override
  String get seeAllSupportedWallets => 'See all supported wallets';

  @override
  String get walletDetectionSummary => 'Wallet detection summary';

  @override
  String get walletBalance => 'Wallet balance';

  @override
  String get walletAddress => 'Wallet address';

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
  String get deleteKeychainDialogTitle => 'Delete Keychain?';

  @override
  String get deleteKeychainDialogSubtitle => 'Are you sure you wants to delete your\nCatalyst Keychain from this device?';

  @override
  String get deleteKeychainDialogWarning => 'Make sure you have a working Catalyst 12-word seedphrase!';

  @override
  String get deleteKeychainDialogWarningInfo => 'Your Catalyst account will be removed,\nthis action cannot be undone!';

  @override
  String get deleteKeychainDialogTypingInfo => 'To avoid mistakes, please type ‘Remove Keychain’ below.';

  @override
  String get deleteKeychainDialogInputLabel => 'Confirm removal';

  @override
  String get deleteKeychainDialogErrorText => 'Error. Please type \'Remove keychain\' to remove your account from this device.';

  @override
  String get deleteKeychainDialogRemovingPhrase => 'Remove Keychain';

  @override
  String get accountRoleDialogTitle => 'Learn about Catalyst Roles';

  @override
  String get accountRoleDialogButton => 'Continue Role setup';

  @override
  String accountRoleDialogRoleSummaryTitle(String role) {
    return '$role role summary';
  }

  @override
  String get voterVerboseName => 'Treasury guardian';

  @override
  String get proposerVerboseName => 'Main proposer';

  @override
  String get drepVerboseName => 'Community expert';

  @override
  String get voterDescription => 'The Voters are the guardians of Cardano treasury. They vote in projects for the growth of the Cardano Ecosystem.';

  @override
  String get proposerDescription => 'The Main Proposers are the Innovators in Project Catalyst, they are the shapers of the future.';

  @override
  String get drepDescription => 'The dRep has an Expert Role in the Cardano/Catalyst as people can delegate their vote to Cardano Experts.';

  @override
  String get voterSummarySelectFavorites => 'Select favorites';

  @override
  String get voterSummaryComment => 'Comment/Vote on Proposals';

  @override
  String get voterSummaryCastVotes => 'Cast your votes';

  @override
  String get voterSummaryVoterRewards => 'Voter rewards';

  @override
  String get proposerSummaryWriteEdit => 'Write/edit functionality';

  @override
  String get proposerSummarySubmitToFund => 'Rights to Submit to Fund';

  @override
  String get proposerSummaryInviteTeamMembers => 'Invite Team Members';

  @override
  String get proposerSummaryComment => 'Comment functionality';

  @override
  String get drepSummaryDelegatedVotes => 'Delegated Votes';

  @override
  String get drepSummaryRewards => 'dRep rewards';

  @override
  String get drepSummaryCastVotes => 'Cast delegated votes';

  @override
  String get drepSummaryComment => 'Comment Functionality';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get notice => 'Notice';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get total => 'Total';

  @override
  String get file => 'file';

  @override
  String get key => 'key';

  @override
  String get upload => 'Upload';

  @override
  String get browse => 'browse';

  @override
  String uploadDropInfo(String itemNameToUpload) {
    return 'Drop your $itemNameToUpload here or ';
  }

  @override
  String get uploadProgressInfo => 'Upload in progress';

  @override
  String get uploadKeychainTitle => 'Upload Catalyst Keychain';

  @override
  String get uploadKeychainInfo => 'Make sure it\'s a correct Catalyst keychain file.';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get keychainDeletedDialogTitle => 'Catalyst keychain removed';

  @override
  String get keychainDeletedDialogSubtitle => 'Catalyst keychain removed';

  @override
  String get keychainDeletedDialogInfo => 'Catalyst keychain removed';

  @override
  String get createKeychainSeedPhraseSubtitle => 'Write down your 12 Catalyst  security words';

  @override
  String get createKeychainSeedPhraseBody => 'Make sure you create an offline backup of your recovery phrase as well.';

  @override
  String get createKeychainSeedPhraseDownload => 'Download Catalyst key';

  @override
  String get createKeychainSeedPhraseStoreConfirmation => 'I have written down/downloaded my 12 words';

  @override
  String get createKeychainSeedPhraseCheckInstructionsTitle => 'Check your Catalyst security keys';

  @override
  String get createKeychainSeedPhraseCheckInstructionsSubtitle => 'Next, we\'re going to make sure that you\'ve written down your words correctly.     We don\'t save your seed phrase, so it\'s important  to make sure you have it right. That\'s why we do this confirmation before continuing.     It\'s also good practice to get familiar with using a seed phrase if you\'re new to crypto.';

  @override
  String get createKeychainSeedPhraseCheckSubtitle => 'Input your Catalyst security keys';

  @override
  String get createKeychainSeedPhraseCheckBody => 'Select your 12 written down words in  the correct order.';

  @override
  String get uploadCatalystKey => 'Upload Catalyst Key';

  @override
  String get reset => 'Reset';

  @override
  String get createKeychainSeedPhraseCheckSuccessTitle => 'Nice job! You\'ve successfully verified the seed phrase for your keychain.';

  @override
  String get createKeychainSeedPhraseCheckSuccessSubtitle => 'Enter your seed phrase to recover your Catalyst Keychain on any device.  It\'s kinda like your email and password all rolled into one, so keep it somewhere safe!  In the next step we’ll add a password to your Catalyst Keychain, so you can lock/unlock access to Voices.';

  @override
  String get yourNextStep => 'Your next step';

  @override
  String get createKeychainSeedPhraseCheckSuccessNextStep => 'Now let’s set your Unlock password for this device!';

  @override
  String get createKeychainUnlockPasswordInstructionsTitle => 'Set your Catalyst unlock password  for this device';

  @override
  String get createKeychainUnlockPasswordInstructionsSubtitle => 'With over 300 trillion possible combinations, your 12 word seed phrase is great for keeping your account safe.    But it can be a bit tedious to enter every single time you want to use the app.    In this next step, you\'ll set your Unlock Password for your current device. It\'s like a shortcut for proving ownership of your Keychain.    Whenever you recover your account for the first time on a new device, you\'ll need to use your Catalyst Keychain to get started. Every time after that, you can use your Unlock Password to quickly regain access.';

  @override
  String get createKeychainCreatedTitle => 'Congratulations your Catalyst  Keychain is created!';

  @override
  String get createKeychainCreatedNextStep => 'In the next step you write your Catalyst roles and  account to the Cardano Mainnet.';

  @override
  String get createKeychainLinkWalletAndRoles => 'Link your Cardano Wallet & Roles';

  @override
  String get registrationCreateKeychainStepGroup => 'Catalyst Keychain created';

  @override
  String get registrationLinkWalletStepGroup => 'Link Cardano Wallet & Roles';

  @override
  String get registrationCompletedStepGroup => 'Catalyst account creation completed!';

  @override
  String get createKeychainUnlockPasswordIntoSubtitle => 'Catalyst unlock password';

  @override
  String get createKeychainUnlockPasswordIntoBody => 'Please provide a password for your Catalyst Keychain.';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String xCharactersMinimum(int number) {
    return '$number characters minimum length';
  }

  @override
  String get passwordDoNotMatch => 'Passwords do not match, please correct';

  @override
  String get warning => 'Warning';

  @override
  String get registrationExitConfirmDialogSubtitle => 'Account creation incomplete!';

  @override
  String get registrationExitConfirmDialogContent => 'If attempt to leave without creating your keychain - account creation will be incomplete.   You are not able to login without  completing your keychain.';

  @override
  String get registrationExitConfirmDialogContinue => 'Continue keychain creation';

  @override
  String get registrationExitConfirmDialogCancel => 'Cancel anyway';

  @override
  String get recoverCatalystKeychain => 'Restore Catalyst keychain';

  @override
  String get recoverKeychainMethodsTitle => 'Restore your Catalyst Keychain';

  @override
  String get recoverKeychainMethodsNoKeychainFound => 'No Catalyst Keychain found on this device.';

  @override
  String get recoverKeychainMethodsSubtitle => 'Not to worry, in the next step you can choose the recovery option that applies to you for this device!';

  @override
  String get recoverKeychainMethodsListTitle => 'How do you want Restore your Catalyst Keychain?';

  @override
  String get recoverKeychainNonFound => 'No Catalyst Keychain found on this device.';

  @override
  String get recoverKeychainFound => 'Keychain found!   Please unlock your device.';

  @override
  String get seedPhrase12Words => '12 security words';

  @override
  String get recoverySeedPhraseInstructionsTitle => 'Restore your Catalyst Keychain with  your 12 security words.';

  @override
  String get recoverySeedPhraseInstructionsSubtitle => 'Enter your security words in the correct order, and sign into your Catalyst account on a new device.';

  @override
  String get recoverySeedPhraseInputTitle => 'Restore your Catalyst Keychain with  your 12 security words';

  @override
  String get recoverySeedPhraseInputSubtitle => 'Enter each word of your Catalyst Key in the right order  to bring your Catalyst account to this device.';

  @override
  String get recoveryAccountTitle => 'Catalyst account recovery';

  @override
  String get recoveryAccountSuccessTitle => 'Keychain recovered successfully!';

  @override
  String get recoveryAccountDetailsAction => 'Set unlock password for this device';
}
