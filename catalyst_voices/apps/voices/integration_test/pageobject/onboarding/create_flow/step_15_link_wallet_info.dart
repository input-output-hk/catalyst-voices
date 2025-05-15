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
      (await t()).walletLinkIntroTitle,
    );

    expect(
      $(registrationDetailsBody).$(Text).text,
      (await t()).walletLinkIntroContent,
    );

    expect($(chooseCardanoWalletButton), findsOneWidget);
  }

  Future<void> verifyInfoPanel() async {
    expect(
      await infoPartHeaderTitleText(),
      (await t()).walletLinkHeader,
    );
    expect(
      await infoPartHeaderSubtitleText(),
      (await t()).walletLinkWalletSubheader,
    );
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
    expect($(learnMoreButton).$(Text).text, (await t()).learnMore);
  }
}
