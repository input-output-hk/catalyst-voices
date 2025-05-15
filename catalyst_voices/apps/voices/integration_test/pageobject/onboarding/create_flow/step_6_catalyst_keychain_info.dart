import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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
    await verifyDetailsPanel();
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), (await t()).catalystKeychain);
    expect(infoPartTaskPicture(), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CatalystSvgPicture &&
            (widget.bytesLoader as dynamic).assetName == 'assets/images/keychain.svg',
      ),
      findsOneWidget,
    );
    expect($(progressBar), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      (await t()).learnMore,
    );
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(registrationDetailsTitle).$(Text).text,
      (await t()).accountCreationSplashTitle,
    );
    expect(
      $(registrationDetailsBody).$(Text).text,
      (await t()).accountCreationSplashMessage,
    );
    expect($(createKeychainButton), findsOneWidget);
  }
}
