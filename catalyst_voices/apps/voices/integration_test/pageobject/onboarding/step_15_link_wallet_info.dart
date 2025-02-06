import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/translations_utils.dart';
import 'onboarding_page_interface.dart';
import 'step_14_keychain_final.dart';

class LinkWalletInfoPanel implements OnboardingPage {
  PatrolTester $;
  LinkWalletInfoPanel(this.$);

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
  void verifyPageElements() {
    expect(
          $(chooseCardanoWalletButton).$(Text).text,
          T.get('Choose Cardano Wallet'),
        );
  }
}
