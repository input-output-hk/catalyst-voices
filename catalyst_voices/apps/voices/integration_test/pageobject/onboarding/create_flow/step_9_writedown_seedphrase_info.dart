import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_8_writedown_seedphrase.dart';

class WritedownSeedphraseInfoPanel extends OnboardingPageBase {
  WritedownSeedphraseInfoPanel(super.$);

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await WriteDownSeedphrasePanel($).goto();
    await WriteDownSeedphrasePanel($).storeSeedPhraseWords();
    await WriteDownSeedphrasePanel($).clickSeedPhraseStoredCheckbox();
    await WriteDownSeedphrasePanel($).clickNext();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), (await t()).catalystKeychain);
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(infoPartLearnMoreText(), (await t()).learnMore);
    expect(await closeButton(), findsOneWidget);
  }

  Future<void> verifyDetailsPanel() async {}
}
