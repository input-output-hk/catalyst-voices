import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_2_restore_keychain_choice_panel.dart';

class SeedPhraseInstructionsPanel extends OnboardingPageBase {
  SeedPhraseInstructionsPanel(super.$);

  final seedPhraseInstructionsTitleKey =
      const Key('SeedPhraseInstructionsTitle');
  final seedPhraseInstructionsSubtitleKey =
      const Key('SeedPhraseInstructionsSubtitleKey');

  @override
  Future<void> goto() async {
    await RestoreKeychainChoicePanel($).goto();
    await RestoreKeychainChoicePanel($).clickRestoreSeedPhrase();
  }

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyInfoPanel() async {
    expect(
      await infoPartHeaderTitleText(),
      T.get('Restore Catalyst keychain'),
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect(
      infoPartLearnMoreText(),
      T.get('Learn More'),
    );
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(seedPhraseInstructionsTitleKey).text,
      T.get('Restore your Catalyst Keychain with \n'
          'your 12-word Catalyst seed phrase'),
    );
    expect(
      $(seedPhraseInstructionsSubtitleKey).text,
      T.get('Enter your security words in the correct order,'
          ' and sign into your Catalyst account on a new device.'),
    );
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
  }
}
