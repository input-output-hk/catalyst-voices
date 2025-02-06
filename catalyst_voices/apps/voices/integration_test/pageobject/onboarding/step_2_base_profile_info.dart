import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'onboarding_page_interface.dart';
import 'step_1_get_started.dart';

class BaseProfileInfoPanel implements OnboardingPage{
  PatrolTester $;
  BaseProfileInfoPanel(this.$);

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
  void verifyPageElements() {
    // TODO: implement verifyPageElements
  }
  
}