import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/test_context.dart';
import 'onboarding_page_interface.dart';
import 'step_9_writedown_seedphrase_info.dart';

class InputSeedphrasePanel implements OnboardingPage {
  PatrolTester $;
  InputSeedphrasePanel(this.$);

  static const nextButton = Key('NextButton');
  static const seedPhrasesPicker = Key('SeedPhrasesPicker');
  static const resetButton = Key('ResetButton');

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  Future<void> inputSeedPhraseWords() async {
    // TODO(oldgreg): remove reset when seeds are no longer prefilled
    // issues_1531
    await $(resetButton).tap();
    for (var i = 0; i < 12; i++) {
      await $(seedPhrasesPicker).$(find.text(TestContext.get('word$i'))).tap();
    }
  }

  @override
  Future<void> goto() async {
    await WritedownSeedphraseInfoPanel($).goto();
    await WritedownSeedphraseInfoPanel($).clickNext();
  }

  @override
  void verifyPageElements() {
    // TODO: implement verifyPageElements
  }
}
