import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'onboarding_page_interface.dart';
import 'step_12_password_info.dart';

class PasswordInputPanel implements OnboardingPage {
  PatrolTester $;
  PasswordInputPanel(this.$);

  static const nextButton = Key('NextButton');
  static const passwordInputField = Key('PasswordInputField');
  static const passwordConfirmInputField = Key('PasswordConfirmInputField');

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  Future<void> enterPassword(String password, String confirmPassword) async {
    await $(passwordInputField).enterText(password);
    if (confirmPassword != '') {
      await $(passwordConfirmInputField).enterText(confirmPassword);
    }
  }

  @override
  Future<void> goto() async {
    await PasswordInfoPanel($).goto();
    await PasswordInfoPanel($).clickNext();
  }

  @override
  void verifyPageElements() {
    // TODO: implement verifyPageElements
  }
}
