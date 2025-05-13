import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/app_bar_page.dart';
import '../pageobject/onboarding/onboarding_base_page.dart';
import '../pageobject/onboarding/restore_flow/step_2_restore_keychain_choice_panel.dart';
import '../pageobject/onboarding/restore_flow/step_3_seedphrase_instructions_panel.dart';
import '../pageobject/onboarding/restore_flow/step_4_restore_keychain_input_panel.dart';
import '../pageobject/onboarding/restore_flow/step_5_restore_keychain_success_panel.dart';
import '../pageobject/onboarding/restore_flow/step_6_unlock_password_info_panel.dart';
import '../pageobject/onboarding/restore_flow/step_7_unlock_password_input_panel.dart';
import '../pageobject/onboarding/restore_flow/step_8_unlock_password_success_panel.dart';
import '../pageobject/onboarding/step_1_get_started.dart';
import '../types/password_validation_states.dart';
import '../utils/test_context.dart';

void main() async {
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter();
  });

  setUp(() async {
    await registerDependencies();
    registerConfig(AppConfig.dev());
    router.go(const DiscoveryRoute().location);
  });

  tearDown(() async {
    await restartDependencies();
    TestContext.clearContext();
  });

  group(
    'Onboarding Restore Flow -',
    () {
      patrolWidgetTest('visitor - restore - keychain choice screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await RestoreKeychainChoicePanel($).goto();
        await RestoreKeychainChoicePanel($).verifyInfoPanel();
      });

      patrolWidgetTest(
        'visitor - restore - keychain choice screen back button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await RestoreKeychainChoicePanel($).goto();
          await RestoreKeychainChoicePanel($).clickBack();
          await GetStartedPanel($).verifyPageElements();
        },
      );

      patrolWidgetTest('restore - keychain choice screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await RestoreKeychainChoicePanel($).goto();
        await RestoreKeychainChoicePanel($).verifyPageElements();
      });

      patrolWidgetTest('restore - keychain choice screen back button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await RestoreKeychainChoicePanel($).goto();
        await RestoreKeychainChoicePanel($).clickBack();
        await GetStartedPanel($).verifyPageElements();
      });

      patrolWidgetTest('restore - seed phrase instructions screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await SeedPhraseInstructionsPanel($).goto();
        await SeedPhraseInstructionsPanel($).verifyPageElements();
      });

      patrolWidgetTest(
          'restore - seed phrase instructions screen close button - '
          'dialog check', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await SeedPhraseInstructionsPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        await OnboardingPageBase($).incompleteDialogCheckRestorationPhase();
      });

      patrolWidgetTest(
          'restore - seed phrase instructions screen close button - '
          'dialog continue', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await SeedPhraseInstructionsPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        await OnboardingPageBase($).incompleteDialogClickContinue();
        await SeedPhraseInstructionsPanel($).verifyDetailsPanel();
      });

      patrolWidgetTest(
          'restore - seed phrase instructions screen close button - '
          'dialog cancel', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await SeedPhraseInstructionsPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        await OnboardingPageBase($).incompleteDialogClickCancel();
        await AppBarPage($).looksAsExpectedForVisitor();
      });

      patrolWidgetTest(
          tags: 'issues_2004',
          skip: true,
          'restore - seed phrase instructions screen close button - '
          'dialog close', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await SeedPhraseInstructionsPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        await OnboardingPageBase($).incompleteDialogClickClose();
        await SeedPhraseInstructionsPanel($).verifyDetailsPanel();
      });

      patrolWidgetTest('restore - seed phrase input screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await RestoreKeychainInputPanel($).goto();
        await RestoreKeychainInputPanel($).verifyPageElements();
      });

      patrolWidgetTest(
          'restore - seed phrase input screen close button - '
          'dialog check', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await RestoreKeychainInputPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        await OnboardingPageBase($).incompleteDialogCheckRestorationPhase();
      });

      patrolWidgetTest(
          'restore - seed phrase input screen close button - '
          'dialog continue', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await RestoreKeychainInputPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        await OnboardingPageBase($).incompleteDialogClickContinue();
        await RestoreKeychainInputPanel($).verifyDetailsPanel();
      });

      patrolWidgetTest(
          'restore - seed phrase input screen close button - '
          'dialog cancel', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await RestoreKeychainInputPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        await OnboardingPageBase($).incompleteDialogClickCancel();
        await AppBarPage($).looksAsExpectedForVisitor();
      });

      patrolWidgetTest(
          tags: 'issues_2004',
          skip: true,
          'restore - seed phrase input screen close button - '
          'dialog close', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await RestoreKeychainInputPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        await OnboardingPageBase($).incompleteDialogClickClose();
        await RestoreKeychainInputPanel($).verifyDetailsPanel();
      });

      patrolWidgetTest('restore - valid seed phrase input works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await RestoreKeychainSuccessPanel($).goto();
        await RestoreKeychainSuccessPanel($).verifyPageElements();
      });

      patrolWidgetTest('restore - unlock password info screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await UnlockPasswordInfoPanel($).goto();
        await UnlockPasswordInfoPanel($).verifyPageElements();
      });

      patrolWidgetTest(
          'restore - unlock password info screen close button - '
          'dialog check', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await UnlockPasswordInfoPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        await OnboardingPageBase($).incompleteDialogCheckRestorationPhase();
      });

      patrolWidgetTest(
          'restore - unlock password info screen close button - '
          'dialog continue', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await UnlockPasswordInfoPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        await OnboardingPageBase($).incompleteDialogClickContinue();
        await UnlockPasswordInfoPanel($).verifyDetailsPanel();
      });

      patrolWidgetTest(
          'restore - unlock password info screen close button - '
          'dialog cancel', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
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
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await UnlockPasswordInfoPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        await OnboardingPageBase($).incompleteDialogClickClose();
        await UnlockPasswordInfoPanel($).verifyDetailsPanel();
      });

      patrolWidgetTest('restore - password input validation works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await UnlockPasswordInputPanel($).goto();
        await UnlockPasswordInputPanel($).verifyPageElements();

        // Test invalid password
        await UnlockPasswordInputPanel($).enterPassword('short', 'short');
        await UnlockPasswordInputPanel($)
            .verifyValidationIndicator(PasswordValidationStatus.weak);

        // Test valid password
        await UnlockPasswordInputPanel($)
            .enterPassword('ValidPass123', 'ValidPass123');
        await UnlockPasswordInputPanel($)
            .verifyValidationIndicator(PasswordValidationStatus.good);
      });

      patrolWidgetTest('restore - complete flow works', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));

        // Navigate through all restore steps
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).verifyPageElements();
        await UnlockPasswordSuccessPanel($).clickGoToDashboard();
        await AppBarPage($).sessionAccountPopupMenuAvatarIsVisible();
      });

      patrolWidgetTest('restore - password mismatch shows error',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await UnlockPasswordInputPanel($).goto();

        await UnlockPasswordInputPanel($)
            .enterPassword('Test1234', 'WrongPassword');
        await UnlockPasswordInputPanel($).verifyPasswordConfirmErrorIcon();
      });

      patrolWidgetTest('restore - can recover different keychain',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await RestoreKeychainSuccessPanel($).goto();
        await RestoreKeychainSuccessPanel($).clickRecoverDifferentKeychain();
        await RestoreKeychainChoicePanel($).verifyPageElements();
      });
    },
    skip: true,
    // TODO(emiride): Fix the tests when this finishes:
    // https://github.com/input-output-hk/catalyst-voices/issues/1597
  );
}
