import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_6_catalyst_keychain_info.dart';

class CatalystKeychainSuccessPanel extends OnboardingPageBase {
  CatalystKeychainSuccessPanel(super.$);

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await CatalystKeychainInfoPanel($).goto();
    await CatalystKeychainInfoPanel($).clickCreateKeychain();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
    expect(await closeButton(), findsOneWidget);
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
      (await t()).accountInstructionsTitle,
    );
    expect(
      $(registrationDetailsBody).$(Text).text,
      (await t()).accountInstructionsMessage,
    );
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
  }
}
