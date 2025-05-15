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
  final recoverKeychainMethodsSubtitleKey = const Key('RecoverKeychainMethodsSubtitle');
  final recoverKeychainMethodsListTitleKey = const Key('RecoverKeychainMethodsListTitle');
  final registrationTileKey = const ValueKey(RegistrationRecoverMethod.seedPhrase);

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
      (await t()).recoverKeychainMethodsTitle,
    );
    expect(
      $(onDeviceKeychainsWidget).$(keychainNotFoundIndicator).$(Text).text,
      (await t()).recoverKeychainMethodsNoKeychainFound,
    );
    expect(
      $(recoverKeychainMethodsSubtitleKey).text,
      (await t()).recoverKeychainMethodsSubtitle,
    );
    expect(
      $(recoverKeychainMethodsListTitleKey).text,
      (await t()).recoverKeychainMethodsListTitle,
    );
    expect(
      $(registrationTileTitle).text,
      (await t()).recoverWithSeedPhrase12Words,
    );
  }

  Future<void> verifyInfoPanel() async {
    expect(
      await infoPartHeaderTitleText(),
      (await t()).recoverCatalystKeychain,
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(learnMoreButton).$(Text).text, (await t()).learnMore);
  }
}
