import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'onboarding_page_interface.dart';
import 'step_8_writedown_seedphrase.dart';

class WritedownSeedphraseInfoPanel implements OnboardingPage {
  PatrolTester $;
  WritedownSeedphraseInfoPanel(this.$);

  static const nextButton = Key('NextButton');

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await WriteDownSeedphrasePanel($).goto();
    await WriteDownSeedphrasePanel($).storeSeedPhraseWords();
    await WriteDownSeedphrasePanel($).clickSeedPhraseStoredCheckbox();
    await WriteDownSeedphrasePanel($).clickNext();
  }

  @override
  void verifyPageElements() {
    // TODO: implement verifyPageElements
  }
}
