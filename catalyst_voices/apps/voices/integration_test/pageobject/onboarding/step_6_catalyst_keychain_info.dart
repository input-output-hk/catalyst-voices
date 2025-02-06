import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'onboarding_page_interface.dart';
import 'step_5_base_profile_final.dart';

class CatalystKeychainInfoPanel implements OnboardingPage {
  PatrolTester $;
  CatalystKeychainInfoPanel(this.$);

  static const createKeychainButton = Key('CreateKeychainButton');

  Future<void> clickCreateKeychain() async {
    await $(createKeychainButton).tap();
  }

  @override
  Future<void> goto() async {
    await BaseProfileFinalPanel($).goto();
    await BaseProfileFinalPanel($).clickCreateKeychain();
  }

  @override
  void verifyPageElements() {
    // TODO: implement verifyPageElements
  }
}