import 'package:flutter/material.dart';

import 'onboarding_base_page.dart';
import 'step_4_acknowledgments.dart';

class BaseProfileFinalPanel extends OnboardingPageBase {
  BaseProfileFinalPanel(super.$);

  static const createKeychainButton = Key('CreateKeychainButton');

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
    // TODO(emiride): implement verifyPageElements
  }
}
