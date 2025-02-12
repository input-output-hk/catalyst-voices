import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/translations_utils.dart';
import '../common_page.dart';
import 'onboarding_base_page.dart';
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
    expect(await closeButton(), findsOneWidget);
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), T.get('Catalyst Keychain'));
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
      T.get('Learn More'),
    );
  }
}
