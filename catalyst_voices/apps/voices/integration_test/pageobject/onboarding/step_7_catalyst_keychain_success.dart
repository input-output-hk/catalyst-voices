import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'onboarding_page_interface.dart';
import 'step_6_catalyst_keychain_info.dart';

class CatalystKeychainSuccessPanel implements OnboardingPage {
  PatrolTester $;
  CatalystKeychainSuccessPanel(this.$);

  static const nextButton = Key('NextButton');

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await CatalystKeychainInfoPanel($).goto();
    await CatalystKeychainInfoPanel($).clickCreateKeychain();
  }

  @override
  void verifyPageElements() {
    // TODO: implement verifyPageElements
  }
}
