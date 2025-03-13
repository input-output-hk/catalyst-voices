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
    expect(await infoPartHeaderTitleText(), T.get('Restore Catalyst keychain'));
    expect(infoPartTaskPicture(), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage($).decorData).$(Text).text,
      T.get('Learn More'),
    );
    expect(await closeButton(), findsOneWidget);
  }
  Future<void> verifyDetailsPanel() async {
      expect($(passwordInputField).$(voicesTextField), findsOneWidget);
      expect($(enterPasswordText).text, T.get('Enter password'));
      expect($(passwordConfirmInputField).$(enterPasswordText).text, 
      T.get('Confirm password'));
      expect($(passwordConfirmInputField).$(voicesTextField), findsOneWidget);
      expect($(backButton), findsOneWidget);
      expect($(nextButton), findsOneWidget);  
  }
}
