import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_5_restore_keychain_success_panel.dart';

class UnlockPasswordInfoPanel extends OnboardingPageBase {
  UnlockPasswordInfoPanel(super.$);

  final unlockPasswordInfoTitle = const Key('UnlockPasswordInfoTitle');
  final unlockPasswordInfoSubtitle = const Key('UnlockPasswordInfoSubtitle');

  @override
  Future<void> goto() async {
    await RestoreKeychainSuccessPanel($).goto();
    await RestoreKeychainSuccessPanel($).clickSetUnlockPassword();
  }

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(unlockPasswordInfoTitle).text,
      T.get('Set your Catalyst unlock password for this device'),
    );
    expect(
      $(unlockPasswordInfoSubtitle),
      findsOneWidget,
    );
  }

  Future<void> verifyInfoPanel() async {
    expect(
      $(registrationInfoPanel).$(headerTitle).text,
      T.get('Restore Catalyst keychain'),
    );
    expect($(pictureContainer).$(IconTheme), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      T.get('Learn More'),
    );
  }
}
