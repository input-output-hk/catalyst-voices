import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/selector_utils.dart';
import '../../utils/translations_utils.dart';
import '../common_page.dart';

class OnboardingPageBase {
  PatrolTester $;
  OnboardingPageBase(this.$);
  final registrationDialog = const Key('RegistrationDialog');
  final registrationInfoPanel = const Key('RegistrationInfoPanel');
  final registrationDetailsPanel = const Key('RegistrationDetailsPanel');
  final headerTitle = const Key('HeaderTitle');
  final headerSubtitle = const Key('HeaderSubtitle');
  final headerBody = const Key('HeaderBody');
  final backButton = const Key('BackButton');
  final nextButton = const Key('NextButton');
  final registrationInfoPictureContainer = const Key('PictureContainer');
  final progressBar = const Key('ProgressBar');
  final registrationDetailsTitle = const Key('RegistrationDetailsTitle');
  final registrationDetailsBody = const Key('RegistrationDetailsBody');
  final registrationTileTitle = const Key('RegistrationTileTitle');
  final registrationTileSubtitle = const Key('RegistrationTileSubtitle');
  final pictureContainer = const Key('PictureContainer');
  final learnMoreButton = const Key('LearnMoreButton');
  final voicesAlertDialog = const Key('VoicesAlertDialog');
  final registrationDialogTitle = const Key('RegistrationDialogTitle');
  final voicesAlertDialogTitleRow = const Key('VoicesAlertDialogTitleRow');
  final warningIcon = const Key('WarningIcon');
  final voicesAlertDialogCloseButton =
      const Key('VoicesAlertDialogCloseButton');
  final voicesAlertDialogSubtitle = const Key('VoicesAlertDialogSubtitle');
  final registrationExitDialogContent =
      const Key('RegistrationExitDialogContent');
  final recoveryExitDialogContent = const Key('RecoveryExitDialogContent');

  Future<String?> infoPartHeaderTitleText() async {
    return $(registrationInfoPanel).$(headerTitle).text;
  }

  Future<String?> infoPartHeaderSubtitleText() async {
    return $(registrationInfoPanel).$(headerSubtitle).text;
  }

  Future<String?> infoPartHeaderBodyText() async {
    return $(registrationInfoPanel).$(headerBody).text;
  }

  Future<String?> infoPartLearnMoreText() async {
    return $(registrationInfoPanel).$(CommonPage($).decorData).$(Text).text;
  }

  Future<PatrolFinder> closeButton() async {
    return $(registrationDialog)
        .$(CommonPage($).dialogCloseButton)
        .waitUntilVisible();
  }

  Future<void> verifyNextButtonIsEnabled() async {
    return SelectorUtils.isEnabled($, $(nextButton).$(FilledButton));
  }

  Future<void> verifyNextButtonIsDisabled() async {
    return SelectorUtils.isDisabled($, $(nextButton).$(FilledButton));
  }

  PatrolFinder infoPartTaskPicture() {
    return $(registrationInfoPanel)
        .$(registrationInfoPictureContainer)
        .$(IconTheme);
  }

  Future<void> clickBack() async {
    await $(backButton).waitUntilVisible().tap();
  }

  Future<void> goto() async {
    throw UnimplementedError('goto() must be overridden in subclasses');
  }

  Future<void> verifyPageElements() async {
    throw UnimplementedError(
      'verifyPageElements() must be overridden in subclasses',
    );
  }

  Future<void> incompleteDialogCheckKeychainPhase() async {
    expect(
      $(voicesAlertDialogTitleRow).$(registrationDialogTitle).text,
      (await t()).warning,
    );
    expect($(voicesAlertDialogTitleRow).$(VoicesIconButton), findsExactly(2));
    expect($(voicesAlertDialog).$(warningIcon), findsOneWidget);
    expect(
      $(voicesAlertDialog).$(voicesAlertDialogSubtitle).$(Text).text,
      (await t()).registrationExitConfirmDialogSubtitle,
    );
    expect(
      $(voicesAlertDialog).$(registrationExitDialogContent).text,
      (await t()).registrationExitConfirmDialogContent,
    );
    expect(
      $(voicesAlertDialog).$(CommonPage($).buttonFilledType),
      findsOneWidget,
    );
    expect(
      $(voicesAlertDialog).$(CommonPage($).buttonFilledType).$(Text).text,
      (await t()).registrationExitConfirmDialogContinue,
    );
    expect(
      $(voicesAlertDialog).$(CommonPage($).buttonTextType),
      findsOneWidget,
    );
    expect(
      $(voicesAlertDialog).$(CommonPage($).buttonTextType).$(Text).text,
      (await t()).cancelAnyways,
    );
  }

  Future<void> incompleteDialogCheckRestorationPhase() async {
    expect(
      $(voicesAlertDialogTitleRow).$(registrationDialogTitle).text,
      (await t()).warning,
    );
    expect($(voicesAlertDialogTitleRow).$(VoicesIconButton), findsExactly(2));
    expect($(voicesAlertDialog).$(warningIcon), findsOneWidget);
    expect(
      $(voicesAlertDialog).$(voicesAlertDialogSubtitle).$(Text).text,
      (await t()).recoveryExitConfirmDialogSubtitle,
    );
    expect(
      $(voicesAlertDialog).$(recoveryExitDialogContent).text,
      (await t()).recoveryExitConfirmDialogContent,
    );
    expect(
      $(voicesAlertDialog).$(CommonPage($).buttonFilledType),
      findsOneWidget,
    );
    expect(
      $(voicesAlertDialog).$(CommonPage($).buttonFilledType).$(Text).text,
      (await t()).recoveryExitConfirmDialogContinue,
    );
    expect(
      $(voicesAlertDialog).$(CommonPage($).buttonTextType),
      findsOneWidget,
    );
    expect(
      $(voicesAlertDialog).$(CommonPage($).buttonTextType).$(Text).text,
      (await t()).cancelAnyways,
    );
  }

  // TODO(oldgreg): implement after issue #2004 is resolved
  Future<void> incompleteDialogCheckWalletLinkPhase() async {
    throw UnimplementedError('incompleteDialogCheckWalletLinkPhase()');
  }

  Future<void> incompleteDialogClickContinue() async {
    await $(voicesAlertDialog).$(CommonPage($).buttonFilledType).tap();
  }

  Future<void> incompleteDialogClickCancel() async {
    await $(voicesAlertDialog).$(CommonPage($).buttonTextType).tap();
  }

  Future<void> incompleteDialogClickClose() async {
    await $(voicesAlertDialog).$(voicesAlertDialogCloseButton).tap();
  }
}
