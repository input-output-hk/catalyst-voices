import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../../common_page.dart';
import '../onboarding_base_page.dart';
import 'step_3_seedphrase_instructions_panel.dart';

class RestoreKeychainInputPanel extends OnboardingPageBase {
  RestoreKeychainInputPanel(super.$);

  final recoverySeedPhraseInputTitle =
      const Key('RecoverySeedPhraseInputTitle');
  final recoverySeedPhraseInputSubtitle =
      const Key('RecoverySeedPhraseInputSubtitle');
  final resetButton = const Key('ResetButton');
  final importCatalystKey = const Key('UploadKeyButton');
  final uploadKeyButton = const Key('UploadKeyButton');

  @override
  Future<void> goto() async {
    await SeedPhraseInstructionsPanel($).goto();
    await SeedPhraseInstructionsPanel($).clickNext();
  }

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  Future<void> enterSeedPhrase(List<String> seedPhrase) async {
    await $(resetButton).tap();
    for (final word in seedPhrase) {
      await $(CommonPage($).voicesTextField).enterText(word);
      await $.tester.testTextInput.receiveAction(TextInputAction.done);
      await $.tester.pumpAndSettle();
    }
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), (await t()).catalystKeychain);
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      (await t()).learnMore,
    );
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(recoverySeedPhraseInputTitle).text,
      (await t()).recoverySeedPhraseInstructionsTitle,
    );

    expect(
      $(recoverySeedPhraseInputSubtitle).text,
      (await t()).recoverySeedPhraseInstructionsSubtitle,
    );

    for (var i = 1; i < 13; i++) {
      expect(find.byKey(Key('Word${i}CellKey')), findsOneWidget);

      expect($(uploadKeyButton), findsOneWidget);
      expect($(resetButton), findsOneWidget);
      expect($(backButton), findsOneWidget);
      expect($(nextButton), findsOneWidget);
    }
  }
}
