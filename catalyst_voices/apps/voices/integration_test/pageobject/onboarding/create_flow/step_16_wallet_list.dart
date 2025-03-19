import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_15_link_wallet_info.dart';

class WalletListPanel extends OnboardingPageBase {
  WalletListPanel(super.$);

  @override
  Future<void> goto() async {
    await LinkWalletInfoPanel($).goto();
    await LinkWalletInfoPanel($).clickChooseCardanoWallet();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), (await t()).walletLinkHeader);
    expect(
      await infoPartHeaderSubtitleText(),
      (await t()).walletLinkWalletSubheader,
    );
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
  }

  Future<void> verifyDetailsPanel() async {}
}
