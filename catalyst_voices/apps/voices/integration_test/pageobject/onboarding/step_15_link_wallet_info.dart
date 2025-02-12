import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/translations_utils.dart';
import '../common_page.dart';
import 'onboarding_base_page.dart';
import 'step_14_keychain_final.dart';

class LinkWalletInfoPanel extends OnboardingPageBase {
  LinkWalletInfoPanel(super.$);

  static const chooseCardanoWalletButton = Key('ChooseCardanoWalletButton');

  Future<void> clickChooseCardanoWallet() async {
    await $(chooseCardanoWalletButton).tap();
  }

  @override
  Future<void> goto() async {
    await KeychainFinalPanel($).goto();
    await KeychainFinalPanel($).clickLinkWalletAndRoles();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyDetailsPanel() async {}

  Future<void> verifyInfoPanel() async {
    expect(
      await infoPartHeaderTitleText(),
      T.get('Link keys to your Catalyst Keychain'),
    );
    expect(
      await infoPartHeaderSubtitleText(),
      T.get('Link your Cardano wallet'),
    );
    //temporary: check for specific picture (blue key icon)
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
      T.get('Learn More'),
    );
  }
}
