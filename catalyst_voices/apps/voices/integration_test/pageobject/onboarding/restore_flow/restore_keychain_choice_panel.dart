import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../../common_page.dart';
import '../onboarding_base_page.dart';
import '../step_1_get_started.dart';

class RestoreKeychainChoicePanel extends OnboardingPageBase {
  RestoreKeychainChoicePanel(super.$);

  final recoverKeychainMethodsTitle = const Key('RecoverKeychainMethodsTitle');
  final onDeviceKeychainsWidget = const Key('BlocOnDeviceKeychains');
  final keychainNotFoundIndicator = const Key('KeychainNotFoundIndicator');
  final recoverKeychainMethodsSubtitle =
      const Key('RecoverKeychainMethodsSubtitle');
  final recoverKeychainMethodsListTitle =
      const Key('RecoverKeychainMethodsListTitle');

  @override
  Future<void> goto() async {
    await GetStartedPanel($).goto();
    await GetStartedPanel($).clickRecoverKeychain();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(recoverKeychainMethodsTitle).text,
      T.get('Restore your Catalyst Keychain'),
    );
    expect(
      $(onDeviceKeychainsWidget).$(keychainNotFoundIndicator).$(Text).text,
      T.get('No Catalyst Keychain found on this device.'),
    );
    expect(
      $(recoverKeychainMethodsSubtitle).text,
      T.get('Not to worry, in the next step you can choose the recovery '
          'option that applies to you for this device!'),
    );
    expect(
      $(recoverKeychainMethodsListTitle).text,
      T.get('How do you want Restore your Catalyst Keychain?'),
    );
    expect(
      $(registrationTileTitle).text,
      T.get('Restore/Upload with 12-word seed phrase'),
    );
  }

  Future<void> verifyInfoPanel() async {
    expect(
      await infoPartHeaderTitleText(),
      T.get('Restore Catalyst keychain'),
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
      T.get('Learn More'),
    );
  }
}
