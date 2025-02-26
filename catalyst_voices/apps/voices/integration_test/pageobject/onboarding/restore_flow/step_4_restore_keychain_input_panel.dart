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
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), T.get('Catalyst Keychain'));
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage($).decorData).$(Text).text,
      T.get('Learn More'),
    );
    
  }

  Future<void> verifyDetailsPanel() async {}
}
