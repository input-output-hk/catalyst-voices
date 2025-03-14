import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_10_input_seedphrase.dart';

class SeedphraseSuccessPanel extends OnboardingPageBase {
  SeedphraseSuccessPanel(super.$);

  final nextStepBody = const Key('NextStepBody');

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
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyDetailsPanel() async {}

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), (await t()).catalystKeychain);
    //temporary: check for specific picture (green checked icon)
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(infoPartLearnMoreText(), (await t()).learnMore);
    expect(
      $(nextStepBody).text,
      (await t()).createKeychainSeedPhraseCheckSuccessNextStep,
    );
    expect(await closeButton(), findsOneWidget);
  }
}
