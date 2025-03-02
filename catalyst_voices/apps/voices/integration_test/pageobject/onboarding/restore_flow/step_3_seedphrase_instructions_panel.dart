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
  final keychainNotFoundKey = const Key('KeychainNotFoundMessage');

  @override
  Future<void> goto() async {
    await RestoreKeychainChoicePanel($).goto();
    await RestoreKeychainChoicePanel($).clickRestoreSeedPhrase();
  }

  @override
  Future<void> verifyPageElements() async {}

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

  Future<void> verifyDetailsPanel() async {}
}
