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
  final progressBar = const Key('ProgressBar');
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
    expect(await infoPartHeaderTitleText(), T.get('Catalyst Keychain'));
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
        expect(
      $(learnMoreButton).$(Text).text,
      T.get('Learn More'),
    );
  }

  Future<void> verifyDetailsPanel() async {
    expect($(createKeychainButton), findsOneWidget);
    expect($(nextStepBody), findsOneWidget);
    expect($(nextStepTitle), findsOneWidget);
    
  }
}
