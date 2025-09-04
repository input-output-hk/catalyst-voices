import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/test_state_utils.dart';
import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_5_unlock_password_input_panel.dart';

final class UnlockPasswordSuccessPanel extends OnboardingPageBase {
  final recoverySuccessTitle = const Key('RecoverySuccessTitle');
  final recoverySuccessSubtitle = const Key('RecoverySuccessSubtitle');
  final recoverySuccessGoToDashboardButton = const Key('RecoverySuccessGoToDashboardButton');
  final recoverySuccessGoAccountButton = const Key('RecoverySuccessGoAccountButton');

  UnlockPasswordSuccessPanel(super.$);

  Future<void> clickGoToAccount() async {
    await $(recoverySuccessGoAccountButton).tap();
  }

  Future<void> clickGoToDashboard() async {
    await $(recoverySuccessGoToDashboardButton).tap();
  }

  @override
  Future<void> goto() async {
    await UnlockPasswordInputPanel($).goto();
    await UnlockPasswordInputPanel($).enterPassword(
      Account.dummyUnlockFactor.data,
      Account.dummyUnlockFactor.data,
    );
    await UnlockPasswordInputPanel($).clickNext();
  }

  /// Smart goto method that ensures clean visitor state first
  /// This checks if user is already logged in and handles logout automatically
  Future<void> gotoWithCleanState(GoRouter router) async {
    await TestStateUtils.ensureCleanVisitorState($, router);
    await goto();
  }

  Future<void> verifyDetailsPanel() async {
    expect($(recoverySuccessTitle).text, (await t()).recoverySuccessTitle);
    expect(
      $(recoverySuccessSubtitle).text,
      (await t()).recoverySuccessSubtitle,
    );
    expect($(recoverySuccessGoToDashboardButton), findsOneWidget);
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

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }
}
