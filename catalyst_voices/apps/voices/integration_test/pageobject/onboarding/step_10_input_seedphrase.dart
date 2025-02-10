import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/test_context.dart';
import '../../utils/translations_utils.dart';
import '../common_page.dart';
import 'onboarding_base_page.dart';
import 'step_9_writedown_seedphrase_info.dart';

class InputSeedphrasePanel extends OnboardingPageBase {
  InputSeedphrasePanel(super.$);

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
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
  }

  Future<void> verifyDetailsPanel() async {}

  Future<void> verifyInfoPanel() async {
    expect(
      $(registrationInfoPanel).$(headerTitle).text,
      T.get('Catalyst Keychain'),
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
      T.get('Learn More'),
    );
    expect(await closeButton(), findsOneWidget);
  }
}
