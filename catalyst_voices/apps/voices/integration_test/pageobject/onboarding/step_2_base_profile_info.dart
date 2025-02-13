import 'package:flutter/material.dart';

import 'onboarding_base_page.dart';
import 'step_1_get_started.dart';

class BaseProfileInfoPanel extends OnboardingPageBase {
  BaseProfileInfoPanel(super.$);

  static const createBaseProfileButton = Key('CreateBaseProfileNext');

  @override
  Future<void> goto() async {
    await GetStartedPanel($).goto();
    await GetStartedPanel($).clickCreateNewKeychain();
  }

  Future<void> clickCreateBaseProfile() async {
    await $(createBaseProfileButton).tap();
  }

  @override
  Future<void> verifyPageElements() async {
    // TODO(emiride): implement verifyPageElements
  }
}
