import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_5_base_profile_final.dart';

class CatalystKeychainInfoPanel extends OnboardingPageBase {
  CatalystKeychainInfoPanel(super.$);

  static const createKeychainButton = Key('CreateKeychainButton');

  Future<void> clickCreateKeychain() async {
    await $(createKeychainButton).tap();
  }

  @override
  Future<void> goto() async {
    await BaseProfileFinalPanel($).goto();
    await BaseProfileFinalPanel($).clickCreateKeychain();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), (await t()).catalystKeychain);
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      infoPartLearnMoreText(),
      (await t()).learnMore,
    );
  }
}
