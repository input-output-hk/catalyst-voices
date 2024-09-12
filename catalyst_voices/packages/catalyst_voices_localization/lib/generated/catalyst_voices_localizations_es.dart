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
  String get treasuryStepEdit => 'Edit';

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
  String get overallSpacesSearchBrands => 'Search Brands';

  @override
  String get overallSpacesTasks => 'Tasks';
}
