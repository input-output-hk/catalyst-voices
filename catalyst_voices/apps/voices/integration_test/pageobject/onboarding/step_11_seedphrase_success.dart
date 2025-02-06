import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'onboarding_page_interface.dart';
import 'step_10_input_seedphrase.dart';

class SeedphraseSuccessPanel implements OnboardingPage {
  PatrolTester $;
  SeedphraseSuccessPanel(this.$);

  static const nextButton = Key('NextButton');

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await InputSeedphrasePanel($).goto();
    await InputSeedphrasePanel($).inputSeedPhraseWords();
    await InputSeedphrasePanel($).clickNext();
  }

  @override
  void verifyPageElements() {
    // TODO: implement verifyPageElements
  }
  
}