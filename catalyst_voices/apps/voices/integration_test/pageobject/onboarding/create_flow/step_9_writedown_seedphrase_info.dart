import 'package:flutter/widgets.dart';
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
    expect($(headerTitle).$(Text).text, T.get('Catalyst Keychain'));
    // expect(infoPartTaskPicture(), findsOneWidget);
    // expect($(progressBar), findsOneWidget);
    // expect(
    //   infoPartLearnMoreText(),
    //   T.get('Learn More'),
    // );
    // expect(await closeButton(), findsOneWidget);
  }

  Future<void> verifyDetailsPanel() async {
    // expect(
    //     $(registrationDetailsTitle).$(Text).text,
    //     T.get('Write down your'
    //         ' Catalyst seed phrase'));
    // expect(
    //     $(registrationDetailsBody).$(Text).text,
    //     T.get("Next, we're going"
    //         " to make sure that you've written down your Catalyst seed phrase"
    //         " correctly.   \u2028\u2028We don't save your Catalyst seed phrase,"
    //         " so it's important \u2028to make sure you have it right. Thats why we"
    //         " don't trust, we verify before continuing.   \u2028\u2028It's also good"
    //         " practice to get familiar with using a \nseed phrase if you're new "
    //         "to crypto."));
    // expect($(nextButton), findsOneWidget);
    // expect($(backButton), findsOneWidget);
  }
}
