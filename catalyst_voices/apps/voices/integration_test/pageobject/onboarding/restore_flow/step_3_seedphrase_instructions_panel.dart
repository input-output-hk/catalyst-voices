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
      (await t()).recoverCatalystKeychain,
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(learnMoreButton).$(Text).text, (await t()).learnMore);
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(seedPhraseInstructionsTitleKey).text,
      (await t()).recoverySeedPhraseInstructionsTitle,
    );
    expect(
      $(seedPhraseInstructionsSubtitleKey).text,
      (await t()).recoverySeedPhraseInstructionsSubtitle,
    );
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
  }
}
