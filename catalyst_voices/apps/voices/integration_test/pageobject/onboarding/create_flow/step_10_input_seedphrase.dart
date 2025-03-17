import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/test_context.dart';
import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_9_writedown_seedphrase_info.dart';

class InputSeedphrasePanel extends OnboardingPageBase {
  InputSeedphrasePanel(super.$);

  static const seedPhrasesPicker = Key('SeedPhrasesPicker');
  final resetButton = const Key('ResetButton');

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await WritedownSeedphraseInfoPanel($).goto();
    await WritedownSeedphraseInfoPanel($).clickNext();
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
  Future<void> verifyPageElements() async {
    await clickResetButton();
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> clickResetButton() async {
    await $(resetButton).tap();
    await Future.delayed(const Duration(seconds: 3));
  }

  Future<void> verifyInfoPanel() async {
    expect(
      $(registrationInfoPanel).$(headerTitle).text,
      T.get('Catalyst Keychain'),
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(headerSubtitle).text,
      T.get('Input your '
          'Catalyst seed phrase'),
    );
    expect(
        $(registrationInfoPanel).$(headerBody).text,
        'Select your 12 '
        'written down words in \u2028the correct order.');
    expect(
      $(learnMoreButton).$(Text).text,
      T.get('Learn More'),
    );
    expect(await closeButton(), findsOneWidget);
  }

  Future<void> verifyDetailsPanel() async {
    for (var i = 0; i < 12; i++) {
      expect(find.text('Slot ${i + 1}'), findsOneWidget);
    }
    for (var i = 0; i < 12; i++) {
      expect(
        $(seedPhrasesPicker).$(find.text(TestContext.get('word$i'))),
        findsWidgets,
      );
    }
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
  }
}
