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
  String get fundedProposal => 'Funded Proposal';

  @override
  String fundedProposalDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Funded $dateString';
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
}
