import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/translations_utils.dart';
import '../common_page.dart';
import 'onboarding_base_page.dart';
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
    expect(await infoPartHeaderTitleText(), T.get('Catalyst Keychain'));
    //temporary: check for specific picture (green checked icon)
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
      T.get('Learn More'),
    );
    expect(
      $(nextStepBody).text,
      T.get('Now let’s set your Unlock password for this device!'),
    );
    expect(await closeButton(), findsOneWidget);
  }
}
