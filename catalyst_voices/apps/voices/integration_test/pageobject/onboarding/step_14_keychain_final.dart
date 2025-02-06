import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/translations_utils.dart';
import 'onboarding_page_interface.dart';
import 'step_13_password_input.dart';

class KeychainFinalPanel implements OnboardingPage {
  PatrolTester $;
  KeychainFinalPanel(this.$);

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
  void verifyPageElements() {
    expect(
      $(linkWalletAndRolesButton).$(Text).text,
      T.get('Link your Cardano Wallet & Roles'),
    );
  }
}
