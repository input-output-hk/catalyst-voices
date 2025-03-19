import 'package:catalyst_voices/widgets/text_field/voices_password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../types/password_validation_states.dart';
import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_12_password_info.dart';

class PasswordInputPanel extends OnboardingPageBase {
  PasswordInputPanel(super.$);

  final passwordInputField = const Key('PasswordInputField');
  final passwordConfirmInputField = const Key('PasswordConfirmInputField');
  final passwordStrengthLabel = const Key('PasswordStrengthLabel');

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  Future<void> enterPassword(String password, String confirmPassword) async {
    await (await $(passwordInputField).waitUntilVisible()).enterText(password);
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
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyPasswordConfirmErrorIcon({
    bool isShown = true,
  }) async {
    final passwordConfirmField = $(passwordConfirmInputField);
    final widget =
        $.tester.widget<VoicesPasswordTextField>(passwordConfirmField);
    final decoration = widget.decoration!;
    if (!isShown) {
      expect(decoration.errorText, null);
    } else {
      expect(decoration.errorText, (await t()).passwordDoNotMatch);
    }
  }

  Future<void> verifyValidationIndicator(
    PasswordValidationStatus validationStatus,
  ) async {
    expect($(passwordStrengthLabel), findsOneWidget);

    switch (validationStatus) {
      case PasswordValidationStatus.weak:
        expect($(passwordStrengthLabel).text, (await t()).weakPasswordStrength);
        break;
      case PasswordValidationStatus.normal:
        expect(
          $(passwordStrengthLabel).text,
          (await t()).normalPasswordStrength,
        );
        break;
      case PasswordValidationStatus.good:
        expect($(passwordStrengthLabel).text, (await t()).goodPasswordStrength);
        break;
    }
  }

  Future<void> verifyDetailsPanel() async {}

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), (await t()).catalystKeychain);
    expect(
      await infoPartHeaderSubtitleText(),
      (await t()).createKeychainUnlockPasswordIntoSubtitle,
    );
    expect(
      await infoPartHeaderBodyText(),
      (await t()).createKeychainUnlockPasswordIntoBody,
    );
    expect(await closeButton(), findsOneWidget);
  }
}
