import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_3_setup_profile.dart';

class ProfileFinalPanel extends OnboardingPageBase {
  static const createKeychainButton = Key('CreateKeychainButton');

  final nextStepBody = const Key('NextStepBody');
  final nextStepTitle = const Key('NextStepText');

  ProfileFinalPanel(super.$);

  Future<void> clickCreateKeychain() async {
    await $(createKeychainButton).tap();
  }

  @override
  Future<void> goto() async {
    await SetupProfilePanel($).goto();
    await SetupProfilePanel($).clickNext();
  }

  Future<void> verifyDetailsPanel() async {
    expect($(createKeychainButton), findsOneWidget);
    expect($(nextStepBody), findsOneWidget);
    expect($(nextStepTitle), findsOneWidget);
  }

  Future<void> verifyInfoPanel() async {
    expect(
      $(registrationInfoPanel).$(headerTitle).text,
      (await t()).catalystKeychain,
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      (await t()).learnMore,
    );
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }
}
