import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_10_input_seedphrase.dart';

class SeedphraseSuccessPanel extends OnboardingPageBase {
  SeedphraseSuccessPanel(super.$);

  final nextStepBody = const Key('NextStepBody');

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
      (await t()).createKeychainSeedPhraseCheckSuccessNextStep,
    );
    expect(
      $(registrationDetailsTitle).text,
      (await t()).createKeychainSeedPhraseCheckSuccessTitle,
    );
    expect(
      $(registrationDetailsBody).text,
      (await t()).createKeychainSeedPhraseCheckSuccessSubtitle,
    );
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), (await t()).catalystKeychain);
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
    expect($(learnMoreButton).$(Text).text, (await t()).learnMore);
    expect(
      $(nextStepBody).text,
      (await t()).createKeychainSeedPhraseCheckSuccessNextStep,
    );
    expect(await closeButton(), findsOneWidget);
  }
}
