import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_7_unlock_password_input_panel.dart';

class UnlockPasswordSuccessPanel extends OnboardingPageBase {
  UnlockPasswordSuccessPanel(super.$);

  final recoverySuccessTitle = const Key('RecoverySuccessTitle');
  final recoverySuccessSubtitle = const Key('RecoverySuccessSubtitle');
  final recoverySuccessGoToDashboardButton = const Key('RecoverySuccessGoToDashboardButton');
  final recoverySuccessGoAccountButton = const Key('RecoverySuccessGoAccountButton');

  @override
  Future<void> goto() async {
    await UnlockPasswordInputPanel($).goto();
    await UnlockPasswordInputPanel($).enterPassword('Test1234', 'Test1234');
    await UnlockPasswordInputPanel($).clickNext();
  }

  Future<void> clickGoToDashboard() async {
    await $(recoverySuccessGoToDashboardButton).tap();
  }

  Future<void> clickGoToAccount() async {
    await $(recoverySuccessGoAccountButton).tap();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyInfoPanel() async {
    expect(
      await infoPartHeaderTitleText(),
      (await t()).recoverCatalystKeychain,
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(infoPartLearnMoreText(), (await t()).learnMore);
  }

  Future<void> verifyDetailsPanel() async {
    expect($(recoverySuccessTitle).text, (await t()).recoverySuccessTitle);
    expect(
      $(recoverySuccessSubtitle).text,
      (await t()).recoverySuccessSubtitle,
    );
    expect($(recoverySuccessGoToDashboardButton), findsOneWidget);
  }
}
