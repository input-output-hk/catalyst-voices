import 'package:catalyst_voices/widgets/text_field/voices_password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../types/password_validation_states.dart';
import '../../utils/translations_utils.dart';
import 'onboarding_base_page.dart';
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

  void verifyPasswordConfirmErrorIcon({
    bool isShown = true,
  }) {
    final passwordConfirmField = $(passwordConfirmInputField);
    final widget =
        $.tester.widget<VoicesPasswordTextField>(passwordConfirmField);
    final decoration = widget.decoration!;
    if (!isShown) {
      expect(decoration.errorText, null);
    } else {
      expect(
        decoration.errorText,
        T.get('Passwords do not match, please correct'),
      );
    }
  }

  void verifyValidationIndicator(
    PasswordValidationStatus validationStatus,
  ) {
    expect($(passwordStrengthLabel), findsOneWidget);

    switch (validationStatus) {
      case PasswordValidationStatus.weak:
        expect(
          $(passwordStrengthLabel).text,
          T.get('Weak password strength'),
        );
        break;
      case PasswordValidationStatus.normal:
        expect(
          $(passwordStrengthLabel).text,
          T.get('Normal password strength'),
        );
        break;
      case PasswordValidationStatus.good:
        expect(
          $(passwordStrengthLabel).text,
          T.get('Good password strength'),
        );
        break;
    }
  }

  Future<void> verifyDetailsPanel() async {}

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), T.get('Catalyst Keychain'));
    expect(
      await infoPartHeaderSubtitleText(),
      T.get('Catalyst unlock password'),
    );
    expect(
      await infoPartHeaderBodyText(),
      T.get(
        'Please provide a password for your Catalyst Keychain.',
      ),
    );
    expect(await closeButton(), findsOneWidget);
  }
}
