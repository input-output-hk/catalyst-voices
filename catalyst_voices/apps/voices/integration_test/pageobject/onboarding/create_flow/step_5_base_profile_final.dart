import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_4_acknowledgments.dart';

class BaseProfileFinalPanel extends OnboardingPageBase {
  BaseProfileFinalPanel(super.$);

  static const createKeychainButton = Key('CreateKeychainButton');
  final nextStepBody = const Key('NextStepBody');
  final nextStepTitle = const Key('NextStepText');
  Future<void> clickCreateKeychain() async {
    await $(createKeychainButton).tap();
  }

  @override
  Future<void> goto() async {
    await AcknowledgmentsPanel($).goto();
    await AcknowledgmentsPanel($).clickNext();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
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

  Future<void> verifyDetailsPanel() async {
    expect($(createKeychainButton), findsOneWidget);
    expect($(nextStepBody), findsOneWidget);
    expect($(nextStepTitle), findsOneWidget);
  }
}
