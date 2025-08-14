import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/constants.dart';
import '../../../utils/selector_utils.dart';
import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_15_link_wallet_info.dart';

final class WalletListPanel extends OnboardingPageBase {
  static const seeAllSupportedWalletsBtn = Key('SeeAllSupportedWalletsButton');

  WalletListPanel(super.$);

  @override
  Future<void> goto() async {
    await LinkWalletInfoPanel($).goto();
    await LinkWalletInfoPanel($).clickChooseCardanoWallet();
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(registrationDetailsTitle).$(Text).text,
      (await t()).walletLinkSelectWalletTitle,
    );
    expect(
      $(registrationDetailsBody).$(Text).text,
      (await t()).walletLinkSelectWalletContent,
    );
    final seeAllSupportedWalletsCopy = (await t()).seeAllSupportedWallets;
    expect(
      $(seeAllSupportedWalletsBtn).$(Text).text,
      seeAllSupportedWalletsCopy,
    );
    await SelectorUtils.checkOpeningLinkByMocking(
      $,
      seeAllSupportedWalletsCopy,
      Urls.supportedWallets,
    );
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
            (widget.bytesLoader as dynamic).assetName == 'assets/images/keychain.svg',
      ),
      findsOneWidget,
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect($(learnMoreButton).$(Text).text, (await t()).learnMore);
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }
}
