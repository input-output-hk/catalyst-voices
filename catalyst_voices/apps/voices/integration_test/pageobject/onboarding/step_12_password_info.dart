import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/translations_utils.dart';
import '../common_page.dart';
import 'onboarding_base_page.dart';
import 'step_11_seedphrase_success.dart';

class PasswordInfoPanel extends OnboardingPageBase {
  PasswordInfoPanel(super.$);

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await SeedphraseSuccessPanel($).goto();
    await SeedphraseSuccessPanel($).clickNext();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(registrationDetailsPanel).$(registrationDetailsTitle).$(Text).text,
      T.get('Set your Catalyst unlock password for this device'),
    );
    expect(
      $(registrationDetailsPanel).$(registrationDetailsBody).$(Text).text,
      isNotEmpty,
    );
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), T.get('Catalyst Keychain'));
    //temporary: check for specific picture (locked icon)
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
      T.get('Learn More'),
    );
    expect(await closeButton(), findsOneWidget);
  }
}
