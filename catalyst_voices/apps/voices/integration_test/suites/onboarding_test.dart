import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart' as blocs;
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/app_bar_page.dart';
import '../pageobject/onboarding/onboarding_base_page.dart';
import '../pageobject/onboarding/step_10_input_seedphrase.dart';
import '../pageobject/onboarding/step_11_seedphrase_success.dart';
import '../pageobject/onboarding/step_12_password_info.dart';
import '../pageobject/onboarding/step_13_password_input.dart';
import '../pageobject/onboarding/step_14_keychain_final.dart';
import '../pageobject/onboarding/step_15_link_wallet_info.dart';
import '../pageobject/onboarding/step_16_wallet_list.dart';
import '../pageobject/onboarding/step_1_get_started.dart';
import '../pageobject/onboarding/step_2_base_profile_info.dart';
import '../pageobject/onboarding/step_3_setup_base_profile.dart';
import '../pageobject/onboarding/step_6_catalyst_keychain_info.dart';
import '../pageobject/onboarding/step_7_catalyst_keychain_success.dart';
import '../pageobject/onboarding/step_8_writedown_seedphrase.dart';
import '../pageobject/onboarding/step_9_writedown_seedphrase_info.dart';
import '../pageobject/onboarding_page.dart';
import '../types/password_validation_states.dart';
import '../types/registration_state.dart';
import '../utils/test_context.dart';

void main() async {
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter();

    blocs.alwaysAllowRegistration = true;
  });

  setUp(() async {
    await registerDependencies(config: const AppConfig());
    router.go(const DiscoveryRoute().location);
  });

  tearDown(() async {
    await restartDependencies();
    TestContext.clearContext();
  });

  group(
    'Onboarding -',
    () {
      patrolWidgetTest('visitor - get started button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await AppBarPage($).getStartedBtnClick();
        expect($(OnboardingPageBase($).registrationInfoPanel), findsOneWidget);
        expect(
          $(
            OnboardingPageBase($).registrationDetailsPanel,
          ),
          findsOneWidget,
        );
      });

      patrolWidgetTest('visitor - get started screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await GetStartedPanel($).goto();
        await GetStartedPanel($).verifyPageElements();
      });

      patrolWidgetTest('visitor - get started screen close button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await GetStartedPanel($).goto();
        await OnboardingPageBase($).closeButton().tap();
        expect($(OnboardingPageBase($).registrationDialog), findsNothing);
      });

      // TODO(oldgreg): add Introduction screen tests and base profile screens

      patrolWidgetTest('visitor - create - base profile info screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await BaseProfileInfoPanel($).goto();
        await BaseProfileInfoPanel($).verifyPageElements();
      });

      patrolWidgetTest('visitor - create - base profile setup screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await SetupBaseProfilePanel($).goto();
        await SetupBaseProfilePanel($).verifyPageElements();
      });

      patrolWidgetTest('visitor - create - keychain info screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await CatalystKeychainInfoPanel($).goto();
        await CatalystKeychainInfoPanel($).verifyPageElements();
      });

      patrolWidgetTest('visitor - create - keychain created screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await CatalystKeychainSuccessPanel($).goto();
        await CatalystKeychainSuccessPanel($).verifyPageElements();
      });

      patrolWidgetTest(
          'visitor - create - keychain created screen back button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await CatalystKeychainSuccessPanel($).goto();
        await CatalystKeychainSuccessPanel($).clickBack();
        await CatalystKeychainInfoPanel($).verifyPageElements();
      });

      patrolWidgetTest('visitor - create - mnemonic writedown screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await WriteDownSeedphrasePanel($).goto();
        await WriteDownSeedphrasePanel($).verifyPageElements();
      });

      patrolWidgetTest(
          'visitor - create - mnemonic writedown screen back button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await WriteDownSeedphrasePanel($).goto();
        await WriteDownSeedphrasePanel($).clickBack();
        await CatalystKeychainSuccessPanel($).verifyPageElements();
      });

      patrolWidgetTest(
          'visitor - create - mnemonic writedown '
          'screen next button is disabled', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await WriteDownSeedphrasePanel($).goto();
        await WriteDownSeedphrasePanel($).verifyPageElements();
        await WriteDownSeedphrasePanel($).verifyNextButtonIsDisabled();
      });

      patrolWidgetTest('visitor - create - mnemonic input info screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await WritedownSeedphraseInfoPanel($).goto();
        await WritedownSeedphraseInfoPanel($).verifyInfoPanel();
      });

      patrolWidgetTest(
          'visitor - create - mnemonic input info screen back button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await WritedownSeedphraseInfoPanel($).goto();
        await WritedownSeedphraseInfoPanel($).clickBack();
        await WriteDownSeedphrasePanel($).verifyPageElements();
      });

      patrolWidgetTest('visitor - create - mnemonic input screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await InputSeedphrasePanel($).goto();
        await InputSeedphrasePanel($).verifyInfoPanel();
      });

      patrolWidgetTest(
          'visitor - create - mnemonic input screen back button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await InputSeedphrasePanel($).goto();
        await InputSeedphrasePanel($).clickBack();
        await WritedownSeedphraseInfoPanel($).verifyInfoPanel();
      });

      patrolWidgetTest(
          'visitor - create - mnemonic input - '
          'correct words unlock next button', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await InputSeedphrasePanel($).goto();
        await InputSeedphrasePanel($).inputSeedPhraseWords();
        await InputSeedphrasePanel($).verifyNextButtonIsEnabled();
      });

      patrolWidgetTest(
          'visitor - create - mnemonic input verified screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await SeedphraseSuccessPanel($).goto();
        await SeedphraseSuccessPanel($).verifyInfoPanel();
      });

      patrolWidgetTest(
          'visitor - create - mnemonic input verified screen back button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await SeedphraseSuccessPanel($).goto();
        await SeedphraseSuccessPanel($).clickBack();
        await InputSeedphrasePanel($).verifyInfoPanel();
      });

      patrolWidgetTest('visitor - create - password info screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await PasswordInfoPanel($).goto();
        await PasswordInfoPanel($).verifyInfoPanel();
      });

      patrolWidgetTest(
          'visitor - create - password info screen back button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await PasswordInfoPanel($).goto();
        await PasswordInfoPanel($).clickBack();
        await PasswordInfoPanel($).verifyInfoPanel();
      });

      patrolWidgetTest('visitor - create - password input screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await PasswordInputPanel($).goto();
        await PasswordInputPanel($).verifyInfoPanel();
      });

      patrolWidgetTest(
          'visitor - create - password input screen back button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await PasswordInputPanel($).goto();
        await PasswordInputPanel($).clickBack();
        await PasswordInfoPanel($).verifyPageElements();
      });

      patrolWidgetTest(
          'visitor - create - password input - valid minimum length password',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await PasswordInputPanel($).goto();
        await PasswordInputPanel($).enterPassword('Test1234', 'Test1234');
        PasswordInputPanel($).verifyPasswordConfirmErrorIcon(isShown: false);
        PasswordInputPanel($).verifyValidationIndicator(
          PasswordValidationStatus.normal,
        );
        await PasswordInputPanel($).verifyNextButtonIsEnabled();
      });

      patrolWidgetTest(
          'visitor - create - password input - valid long password',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await PasswordInputPanel($).goto();
        await PasswordInputPanel($).enterPassword(
          'Test1234Test1234',
          'Test1234Test1234',
        );
        PasswordInputPanel($).verifyPasswordConfirmErrorIcon(isShown: false);
        PasswordInputPanel($).verifyValidationIndicator(
          PasswordValidationStatus.good,
        );
        await PasswordInputPanel($).verifyNextButtonIsEnabled();
      });

      patrolWidgetTest('visitor - create - password input - too short password',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await PasswordInputPanel($).goto();
        await PasswordInputPanel($).enterPassword('Test123', '');
        PasswordInputPanel($)
            .verifyValidationIndicator(PasswordValidationStatus.weak);
        PasswordInputPanel($).verifyPasswordConfirmErrorIcon(isShown: false);
        await PasswordInputPanel($).verifyNextButtonIsDisabled();
      });

      patrolWidgetTest(
          'visitor - create - password input - valid password, no confirmation',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await PasswordInputPanel($).goto();
        await PasswordInputPanel($).enterPassword('Test1234', '');
        PasswordInputPanel($)
            .verifyValidationIndicator(PasswordValidationStatus.normal);
        PasswordInputPanel($).verifyPasswordConfirmErrorIcon(isShown: false);
        await PasswordInputPanel($).verifyNextButtonIsDisabled();
      });

      patrolWidgetTest(
          'visitor - create - password input - not matching confirmation',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await PasswordInputPanel($).goto();
        await PasswordInputPanel($).enterPassword('Test1234', 'Test123');
        PasswordInputPanel($)
            .verifyValidationIndicator(PasswordValidationStatus.normal);
        PasswordInputPanel($).verifyPasswordConfirmErrorIcon(isShown: true);
        await PasswordInputPanel($).verifyNextButtonIsDisabled();
      });

      patrolWidgetTest(
          'visitor - create - keychain created success screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await KeychainFinalPanel($).goto();
        await KeychainFinalPanel($).verifyInfoPanel();
      });

      patrolWidgetTest('visitor - create - link wallet info screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await LinkWalletInfoPanel($).goto();
        await LinkWalletInfoPanel($).verifyInfoPanel();
      });

      patrolWidgetTest('visitor - create - link wallet select screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await WalletListPanel($).goto();
        await WalletListPanel($).verifyInfoPanel();
      });

      patrolWidgetTest(
          'visitor - create - link wallet select screen back button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await WalletListPanel($).goto();
        await WalletListPanel($).clickBack();
        await LinkWalletInfoPanel($).verifyInfoPanel();
      });

      patrolWidgetTest('visitor - restore - keychain choice screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await AppBarPage($).getStartedBtnClick();
        await OnboardingPage.detailsPartGetStartedRecoverBtn($).tap();
        await OnboardingPage.onboardingScreenLooksAsExpected(
          $,
          RegistrationState.keychainRestoreChoice,
        );
      });

      patrolWidgetTest(
          'visitor - restore - keychain choice screen back button works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await AppBarPage($).getStartedBtnClick();
        await OnboardingPage.detailsPartGetStartedRecoverBtn($).tap();
        await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
        await OnboardingPage.onboardingScreenLooksAsExpected(
          $,
          RegistrationState.getStarted,
        );
      });
    },
  );
}
