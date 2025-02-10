import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/translations_utils.dart';
import '../common_page.dart';
import 'onboarding_base_page.dart';
import 'step_13_password_input.dart';

class KeychainFinalPanel extends OnboardingPageBase {
  KeychainFinalPanel(super.$);

  static const linkWalletAndRolesButton = Key('LinkWalletAndRolesButton');

  Future<void> clickLinkWalletAndRoles() async {
    await $(linkWalletAndRolesButton).tap();
  }

  @override
  Future<void> goto() async {
    await PasswordInputPanel($).goto();
    await PasswordInputPanel($).enterPassword('Test1234', 'Test1234');
    await PasswordInputPanel($).clickNext();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyDetailsPanel() async {}

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), T.get('Catalyst Keychain'));
    //temporary: check for specific picture (green key locked icon)
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
      T.get('Learn More'),
    );
  }
}
