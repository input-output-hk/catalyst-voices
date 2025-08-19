import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/app_bar_page.dart';
import '../pageobject/onboarding/onboarding_base_page.dart';
import '../pageobject/onboarding/restore_flow/step_2_seedphrase_instructions_panel.dart';
import '../pageobject/onboarding/restore_flow/step_3_restore_keychain_success_panel.dart';
import '../pageobject/onboarding/restore_flow/step_4_unlock_password_info_panel.dart';
import '../pageobject/onboarding/restore_flow/step_5_unlock_password_input_panel.dart';
import '../pageobject/onboarding/restore_flow/step_6_unlock_password_success_panel.dart';
import '../types/password_validation_states.dart';
import '../utils/test_utils.dart';

void onboardingRestoreTests() {
  tearDown(() async {
    TestContext.clearContext();
  });

  patrolWidgetTest('restore - seed phrase input screen looks OK', (PatrolTester $) async {
    await TestStateUtils.pumpApp($);
    await RestoreKeychainInputPanel($).goto();
    await RestoreKeychainInputPanel($).verifyPageElements();
  });

  patrolWidgetTest('restore - valid seed phrase input works', (PatrolTester $) async {
    await TestStateUtils.pumpApp($);
    await RestoreKeychainSuccessPanel($).goto();
    await RestoreKeychainSuccessPanel($).verifyPageElements();
  });

  patrolWidgetTest('restore - unlock password info screen looks OK', (PatrolTester $) async {
    await TestStateUtils.pumpApp($);
    await UnlockPasswordInfoPanel($).goto();
    await UnlockPasswordInfoPanel($).verifyPageElements();
  });

  patrolWidgetTest(
      'restore - unlock password info screen close button - '
      'dialog check', (PatrolTester $) async {
    await TestStateUtils.pumpApp($);
    await UnlockPasswordInfoPanel($).goto();
    await OnboardingPageBase($).closeButton().tap();
    await OnboardingPageBase($).incompleteDialogCheckRestorationPhase();
  });

  patrolWidgetTest(
      'restore - unlock password info screen close button - '
      'dialog continue', (PatrolTester $) async {
    await TestStateUtils.pumpApp($);
    await UnlockPasswordInfoPanel($).goto();
    await OnboardingPageBase($).closeButton().tap();
    await OnboardingPageBase($).incompleteDialogClickContinue();
    await UnlockPasswordInfoPanel($).verifyDetailsPanel();
  });

  patrolWidgetTest(
      'restore - unlock password info screen close button - '
      'dialog cancel', (PatrolTester $) async {
    await TestStateUtils.pumpApp($);
    await UnlockPasswordInfoPanel($).goto();
    await OnboardingPageBase($).closeButton().tap();
    await OnboardingPageBase($).incompleteDialogClickCancel();
    await AppBarPage($).looksAsExpectedForVisitor();
  });

  patrolWidgetTest(
      tags: 'issues_2004',
      skip: true,
      'restore - unlock password info screen close button - '
      'dialog close', (PatrolTester $) async {
    await TestStateUtils.pumpApp($);
    await UnlockPasswordInfoPanel($).goto();
    await OnboardingPageBase($).closeButton().tap();
    await OnboardingPageBase($).incompleteDialogClickClose();
    await UnlockPasswordInfoPanel($).verifyDetailsPanel();
  });

  patrolWidgetTest('restore - password input validation works', (PatrolTester $) async {
    await TestStateUtils.pumpApp($);
    await UnlockPasswordInputPanel($).goto();
    await UnlockPasswordInputPanel($).verifyPageElements();

    // Test invalid password
    await UnlockPasswordInputPanel($).enterPassword('short', 'short');
    await UnlockPasswordInputPanel($).verifyValidationIndicator(PasswordValidationStatus.weak);

    // Test valid password
    await UnlockPasswordInputPanel($).enterPassword('ValidPass123', 'ValidPass123');
    await UnlockPasswordInputPanel($).verifyValidationIndicator(PasswordValidationStatus.good);
  });

  patrolWidgetTest('restore - complete flow works', (PatrolTester $) async {
    await TestStateUtils.pumpApp($);

    // Navigate through all restore steps
    await UnlockPasswordSuccessPanel($).goto();
    await UnlockPasswordSuccessPanel($).verifyPageElements();
    await UnlockPasswordSuccessPanel($).clickGoToDashboard();
    await AppBarPage($).sessionAccountPopupMenuAvatarIsVisible();
  });

  patrolWidgetTest('restore - password mismatch shows error', (PatrolTester $) async {
    await TestStateUtils.pumpApp($);
    await UnlockPasswordInputPanel($).goto();

    await UnlockPasswordInputPanel($).enterPassword('Test1234', 'WrongPassword');
    await UnlockPasswordInputPanel($).verifyPasswordConfirmErrorIcon();
  });
}
