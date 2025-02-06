import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'onboarding_page_interface.dart';
import 'step_11_seedphrase_success.dart';

class PasswordInfoPanel implements OnboardingPage {
  PatrolTester $;
  PasswordInfoPanel(this.$);

  static const nextButton = Key('NextButton');

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await SeedphraseSuccessPanel($).goto();
    await SeedphraseSuccessPanel($).clickNext();
  }

  @override
  void verifyPageElements() {
    // TODO: implement verifyPageElements
  }
  
}