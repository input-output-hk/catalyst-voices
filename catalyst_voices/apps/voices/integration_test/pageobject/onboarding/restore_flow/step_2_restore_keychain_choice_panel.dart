import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import '../step_1_get_started.dart';

class RestoreKeychainChoicePanel extends OnboardingPageBase {
  RestoreKeychainChoicePanel(super.$);

  final recoverKeychainMethodsTitle = const Key('RecoverKeychainMethodsTitle');
  final onDeviceKeychainsWidget = const Key('BlocOnDeviceKeychains');
  final keychainNotFoundIndicator = const Key('KeychainNotFoundIndicator');
  final recoverKeychainMethodsSubtitleKey =
      const Key('RecoverKeychainMethodsSubtitle');
  final recoverKeychainMethodsListTitleKey =
      const Key('RecoverKeychainMethodsListTitle');
  final registrationTileKey =
      const ValueKey(RegistrationRecoverMethod.seedPhrase);

  @override
  Future<void> goto() async {
    await GetStartedPanel($).goto();
    await GetStartedPanel($).clickRecoverKeychain();
  }

  Future<void> clickRestoreSeedPhrase() async {
    await $(registrationTileKey).tap();
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
      $(recoverKeychainMethodsSubtitleKey).text,
      T.get('Not to worry, in the next step you can choose the recovery '
          'option that applies to you for this device!'),
    );
    expect(
      $(recoverKeychainMethodsListTitleKey).text,
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
      $(learnMoreButton).$(Text).text,
      T.get('Learn More'),
    );
  }
}
