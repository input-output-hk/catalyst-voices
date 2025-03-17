import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_10_input_seedphrase.dart';

class SeedphraseSuccessPanel extends OnboardingPageBase {
  SeedphraseSuccessPanel(super.$);

  final nextStepBody = const Key('NextStepBody');
  final greenImageLayoutBuilder = const Key('GreenImageLayoutBuilder');

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await InputSeedphrasePanel($).goto();
    await InputSeedphrasePanel($).inputSeedPhraseWords();
    await InputSeedphrasePanel($).clickNext();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(nextStepBody).text,
      T.get('Now let’s set your Unlock password for this device!'),
    );
    expect(
      $(registrationDetailsTitle).text,
      T.get("Nice job! You've"
          ' successfully verified your Catalyst seed phase'),
    );
    expect(
      $(registrationDetailsBody).text,
      T.get('Enter your seed phrase to recover your Catalyst Keychain on '
          "any device.   \u2028\u2028It's kinda "
          'like your email and password all'
          ' rolled into one, so keep it somewhere safe!\u2028\u2028In the next '
          'step we’ll add a password to your Catalyst Keychain, so you can'
          ' lock/unlock access to Voices.'),
    );
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), T.get('Catalyst Keychain'));
    //temporary: check for specific picture (green checked icon)
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CatalystSvgPicture &&
            (widget.bytesLoader as dynamic).assetName ==
                'assets/icons/check.svg',
      ),
      findsOneWidget,
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      T.get('Learn More'),
    );
    expect(await closeButton(), findsOneWidget);
  }
}
