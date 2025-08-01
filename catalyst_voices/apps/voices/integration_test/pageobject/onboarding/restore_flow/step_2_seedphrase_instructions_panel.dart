import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../../common_page.dart';
import '../onboarding_base_page.dart';
import '../step_1_get_started.dart';

class RestoreKeychainInputPanel extends OnboardingPageBase {
  RestoreKeychainInputPanel(super.$);

  final seedPhraseInstructionsTitleKey = const Key('SeedPhraseInstructionsTitle');
  final seedPhraseInstructionsSubtitleKey = const Key('SeedPhraseInstructionsSubtitleKey');
  final resetButton = const Key('ResetButton');

  @override
  Future<void> goto() async {
    await GetStartedPanel($).goto();
    await GetStartedPanel($).clickRecoverKeychain();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> enterSeedPhrase(List<String> seedPhrase) async {
    await $(resetButton).tap();
    for (final word in seedPhrase) {
      await $(CommonPage($).voicesTextField).enterText(word);
      await $.tester.testTextInput.receiveAction(TextInputAction.done);
      await $.tester.pumpAndSettle();
    }
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
