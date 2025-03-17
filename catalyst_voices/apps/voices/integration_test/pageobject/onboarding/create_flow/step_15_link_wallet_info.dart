import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
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
    expect(await infoPartHeaderTitleText(), (await t()).walletLinkHeader);
    expect(await infoPartHeaderSubtitleText(), (await t()).walletLinkHeader);
    //temporary: check for specific picture (blue key icon)
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(infoPartLearnMoreText(), (await t()).learnMore);
  }
}
