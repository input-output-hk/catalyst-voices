import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../../common_page.dart';
import '../onboarding_base_page.dart';
import 'step_4_restore_keychain_input_panel.dart';

class RestoreKeychainSuccessPanel extends OnboardingPageBase {
  RestoreKeychainSuccessPanel(super.$);

  final recoveryAccountTitle = const Key('RecoveryAccountTitle');
  final walletNameText = const Key('WalletNameText');
  final recoveryAccountSuccessTitle = const Key('RecoveryAccountSuccessTitle');
  final walletDetectionSummaryText = const Key('WalletDetectionSummary');
  final nameOfWalletLabel = const Key('NameOfWalletLabel');
  final nameOfWalletValue = const Key('NameOfWalletValue');
  final walletBalanceLabel = const Key('WalletBalanceLabel');
  final walletBalanceValue = const Key('WalletBalanceValue');
  final walletAddressLabel = const Key('WalletAddressLabel');
  final walletAddressValue = const Key('WalletAddressValue');
  final setUnlockPasswordButton = const Key('SetUnlockPasswordButton');
  final recoverDifferentKeychainButton = const Key('RecoverDifferentKeychainButton');
  final recoveryAccountError = const Key('RecoveryAccountError');

  @override
  Future<void> goto() async {
    final seedPhrase = [
      'broken',
      'member',
      'repeat',
      'liquid',
      'barely',
      'electric',
      'theory',
      'paddle',
      'coyote',
      'behind',
      'unique',
      'member',
    ];
    await RestoreKeychainInputPanel($).goto();
    await RestoreKeychainInputPanel($).enterSeedPhrase(seedPhrase);
    await RestoreKeychainInputPanel($).clickNext();
    await _ensureWalletIsRecovered();
  }

  Future<void> clickSetUnlockPassword() async {
    await $(setUnlockPasswordButton).tap();
  }

  Future<void> clickRecoverDifferentKeychain() async {
    await $(recoverDifferentKeychainButton).tap();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyDetailsPanel() async {
    expect($(recoveryAccountTitle).text, (await t()).recoveryAccountTitle);
    expect($(walletNameText), findsOneWidget);
    expect(
      $(recoveryAccountSuccessTitle).text,
      (await t()).recoveryAccountSuccessTitle,
    );
    expect(
      $(walletDetectionSummaryText).text,
      (await t()).walletDetectionSummary,
    );
    expect($(nameOfWalletLabel).text, (await t()).nameOfWallet);
    expect($(nameOfWalletValue), findsOneWidget);
    expect($(walletBalanceLabel).text, (await t()).walletBalance);
    expect($(walletBalanceValue), findsOneWidget);
    expect($(walletAddressLabel).text, (await t()).walletAddress);
    expect($(walletAddressValue), findsOneWidget);
    expect($(setUnlockPasswordButton), findsOneWidget);
    expect($(recoverDifferentKeychainButton), findsOneWidget);
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), (await t()).catalystKeychain);
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage($).decorData).$(Text).text,
      (await t()).learnMore,
    );
  }

  Future<void> _ensureWalletIsRecovered() async {
    try {
      await $(recoveryAccountSuccessTitle).waitUntilVisible(timeout: const Duration(seconds: 5));
    } catch (e) {
      await $(recoveryAccountError).$(CommonPage($).errorRetryBtn).tap();
    }
    await $(recoveryAccountSuccessTitle).waitUntilVisible(timeout: const Duration(seconds: 5));
  }
}
