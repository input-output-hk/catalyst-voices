import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../../common_page.dart';
import '../create_flow/step_13_password_input.dart';
import 'step_6_unlock_password_info_panel.dart';

class UnlockPasswordInputPanel extends PasswordInputPanel {
  UnlockPasswordInputPanel(super.$);

  @override
  Future<void> goto() async {
    await UnlockPasswordInfoPanel($).goto();
    await UnlockPasswordInfoPanel($).clickNext();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  @override
  Future<void> verifyInfoPanel() async {
    expect(
      await infoPartHeaderTitleText(),
      (await t()).recoverCatalystKeychain,
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage($).decorData).$(Text).text,
      (await t()).learnMore,
    );
    expect(await closeButton(), findsOneWidget);
  }

  @override
  Future<void> verifyDetailsPanel() async {
    expect($(passwordInputField).$(voicesTextField), findsOneWidget);
    expect($(enterPasswordText).text, (await t()).enterPassword);
    expect($(passwordConfirmInputField).$(enterPasswordText).text,
        (await t()).confirmPassword);
    expect($(passwordConfirmInputField).$(voicesTextField), findsOneWidget);
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
  }
}
