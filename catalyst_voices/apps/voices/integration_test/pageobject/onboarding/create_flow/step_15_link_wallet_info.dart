import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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

  Future<void> verifyDetailsPanel() async {
    expect(
        $(registrationDetailsTitle).$(Text).text,
        T.get('Link Cardano Wallet & Catalyst Roles '
            '\u2028to you Catalyst Keychain.'),);

    expect(
        $(registrationDetailsBody).$(Text).text,
        T.get("You're almost there! This "
            'is the final and most important step in your account '
            "setup. \u2028\u2028We're going to link a Cardano Wallet to your "
            'Catalyst Keychain, so you can start collecting Role Keys.  '
            "\u2028\u2028We'll start with your Voter/Commenter Key by default. "
            'You can decide to add a Proposer Key if you want.'),);

    expect($(chooseCardanoWalletButton), findsOneWidget);
  }

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
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is CatalystSvgPicture &&
            (widget.bytesLoader as dynamic).assetName ==
                'assets/images/keychain.svg',
      ),
      findsOneWidget,
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      T.get('Learn More'),
    );
  }
}
