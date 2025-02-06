import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart' as blocs;
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/app_bar_page.dart';
import '../pageobject/onboarding_page.dart';
import '../types/password_validation_states.dart';
import '../types/registration_state.dart';
import '../utils/constants.dart';
import '../utils/test_context.dart';
import '../utils/translations_utils.dart';

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

  group('Onboarding -', () {
    patrolWidgetTest('visitor - get started button works',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap();
      expect($(OnboardingPage.registrationInfoPanel), findsOneWidget);
      expect($(OnboardingPage.registrationDetailsPanel), findsOneWidget);
    });

    patrolWidgetTest('visitor - get started screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.long.duration);
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.getStarted,
      );
    });

    patrolWidgetTest('visitor - get started screen close button works',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.long.duration);
      await OnboardingPage.closeBtn($).tap();
      expect($(OnboardingPage.registrationDialog), findsNothing);
    });

    // TODO(oldgreg): add Introduction screen tests and base profile screens

    patrolWidgetTest('visitor - create - keychain info screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.createKeychainInfo,
      );
    });

    patrolWidgetTest('visitor - create - keychain created screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.keychainCreated,
      );
    });

    patrolWidgetTest(
        'visitor - create - keychain created screen back button works',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
      await OnboardingPage.registrationInfoPanelLooksAsExpected(
        $,
        RegistrationState.createKeychainInfo,
      );
    });

    patrolWidgetTest('visitor - create - mnemonic writedown screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.keychainCreateMnemonicWritedown,
      );
    });

    patrolWidgetTest(
        'visitor - create - mnemonic writedown screen back button works',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
      await OnboardingPage.registrationInfoPanelLooksAsExpected(
        $,
        RegistrationState.keychainCreated,
      );
    });

    patrolWidgetTest(
        'visitor - create - mnemonic writedown screen next button is disabled',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.registrationInfoPanelLooksAsExpected(
        $,
        RegistrationState.keychainCreateMnemonicWritedown,
      );
      OnboardingPage.voicesButtonIsDisabled($, OnboardingPage.nextButton);
    });

    patrolWidgetTest('visitor - create - mnemonic input info screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.keychainCreateMnemonicInputInfo,
      );
    });

    patrolWidgetTest(
        'visitor - create - mnemonic input info screen back button works',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
      await OnboardingPage.registrationInfoPanelLooksAsExpected(
        $,
        RegistrationState.keychainCreateMnemonicWritedown,
      );
    });

    patrolWidgetTest('visitor - create - mnemonic input screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.keychainCreateMnemonicInput,
      );
    });

    patrolWidgetTest(
        'visitor - create - mnemonic input screen back button works',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
      await OnboardingPage.registrationInfoPanelLooksAsExpected(
        $,
        RegistrationState.keychainCreateMnemonicInputInfo,
      );
    });

    patrolWidgetTest(
        'visitor - create - mnemonic input - correct words unlock next button',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      OnboardingPage.voicesButtonIsEnabled($, OnboardingPage.nextButton);
    });

    patrolWidgetTest(
        'visitor - create - mnemonic input verified screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.keychainCreateMnemonicVerified,
      );
    });

    patrolWidgetTest(
        'visitor - create - mnemonic input verified screen back button works',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
      await OnboardingPage.registrationInfoPanelLooksAsExpected(
        $,
        RegistrationState.keychainCreateMnemonicInputInfo,
      );
    });

    patrolWidgetTest('visitor - create - password info screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.passwordInfo,
      );
    });

    patrolWidgetTest(
        'visitor - create - password info screen back button works',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
      expect(
        $(OnboardingPage.nextStepBody).text,
        T.get('Now let’s set your Unlock password '
            'for this device!'),
      );
    });

    patrolWidgetTest('visitor - create - password input screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.passwordInput,
      );
    });

    patrolWidgetTest(
        'visitor - create - password input screen back button works',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
      await OnboardingPage.registrationDetailsPanelLooksAsExpected(
        $,
        RegistrationState.passwordInfo,
      );
    });

    patrolWidgetTest(
        'visitor - create - password input - valid minimum length password',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.enterPassword($, 'Test1234');
      await OnboardingPage.enterPasswordConfirm($, 'Test1234');
      OnboardingPage.passwordConfirmErrorIconIsShown(
        $,
        reverse: true,
      );
      OnboardingPage.checkValidationIndicator(
        $,
        PasswordValidationStatus.normal,
      );
      OnboardingPage.passwordConfirmErrorIconIsShown(
        $,
        reverse: true,
      );
      OnboardingPage.voicesButtonIsEnabled($, OnboardingPage.nextButton);
    });

    patrolWidgetTest('visitor - create - password input - valid long password',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.enterPassword($, 'Test1234Test1234');
      await OnboardingPage.enterPasswordConfirm($, 'Test1234Test1234');
      OnboardingPage.checkValidationIndicator(
        $,
        PasswordValidationStatus.good,
      );
      OnboardingPage.passwordConfirmErrorIconIsShown(
        $,
        reverse: true,
      );
      OnboardingPage.voicesButtonIsEnabled($, OnboardingPage.nextButton);
    });

    patrolWidgetTest('visitor - create - password input - too short password',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.enterPassword($, 'Test123');
      OnboardingPage.checkValidationIndicator(
        $,
        PasswordValidationStatus.weak,
      );
      OnboardingPage.passwordConfirmErrorIconIsShown(
        $,
        reverse: true,
      );
      OnboardingPage.voicesButtonIsDisabled($, OnboardingPage.nextButton);
    });

    patrolWidgetTest(
        'visitor - create - password input - valid password, no confirmation',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.enterPassword($, 'Test1234');
      OnboardingPage.checkValidationIndicator(
        $,
        PasswordValidationStatus.normal,
      );
      OnboardingPage.passwordConfirmErrorIconIsShown(
        $,
        reverse: true,
      );
      OnboardingPage.voicesButtonIsDisabled($, OnboardingPage.nextButton);
    });

    patrolWidgetTest(
        'visitor - create - password input - not matching confirmation',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.enterPassword($, 'Test1234');
      await OnboardingPage.enterPasswordConfirm($, 'Test123');
      OnboardingPage.checkValidationIndicator(
        $,
        PasswordValidationStatus.normal,
      );
      OnboardingPage.passwordConfirmErrorIconIsShown($);
      OnboardingPage.voicesButtonIsDisabled($, OnboardingPage.nextButton);
    });

    patrolWidgetTest(
        'visitor - create - keychain created success screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.enterPassword($, 'Test1234');
      await OnboardingPage.enterPasswordConfirm($, 'Test1234');
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.keychainCreateSuccess,
      );
    });

    patrolWidgetTest('visitor - create - link wallet info screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.enterPassword($, 'Test1234');
      await OnboardingPage.enterPasswordConfirm($, 'Test1234');
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.linkWalletAndRolesButton).tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.linkWalletInfo,
      );
    });

    patrolWidgetTest('visitor - create - link wallet select screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.enterPassword($, 'Test1234');
      await OnboardingPage.enterPasswordConfirm($, 'Test1234');
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.linkWalletAndRolesButton).tap();
      await $(OnboardingPage.chooseCardanoWalletButton).tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.linkWalletSelect,
      );
    });

    patrolWidgetTest(
        'visitor - create - link wallet select screen back button works',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
      await $(OnboardingPage.createBaseProfileNext).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.storeSeedPhrases($);
      await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      // TODO(oldgreg): remove reset when seeds are no longer prefilled
      //issues_1531
      await $(OnboardingPage.resetButton).tap();
      await OnboardingPage.enterStoredSeedPhrases($);
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.nextButton).tap();
      await OnboardingPage.enterPassword($, 'Test1234');
      await OnboardingPage.enterPasswordConfirm($, 'Test1234');
      await $(OnboardingPage.nextButton).tap();
      await $(OnboardingPage.linkWalletAndRolesButton).tap();
      await $(OnboardingPage.chooseCardanoWalletButton).tap();
      await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.linkWalletInfo,
      );
    });

    patrolWidgetTest('visitor - restore - keychain choice screen looks OK',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
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
      await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
      await OnboardingPage.detailsPartGetStartedRecoverBtn($).tap();
      await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
      await OnboardingPage.onboardingScreenLooksAsExpected(
        $,
        RegistrationState.getStarted,
      );
    });

    
  });
}
