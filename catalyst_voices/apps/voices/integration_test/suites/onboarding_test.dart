import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/app_bar_page.dart';
import '../pageobject/onboarding_page.dart';
import '../pageobject/overall_spaces_page.dart';
import '../types/registration_state.dart';

void main() async {
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter();
  });

  setUp(() async {
    await registerDependencies(config: const AppConfig());
    router.go(const DiscoveryRoute().location);
  });

  tearDown(() async {
    await restartDependencies();
  });

  group(
    'Onboarding -',
    () {
      patrolWidgetTest(
        'visitor - get started button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(OverallSpacesPage.visitorShortcutBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await $(AppBarPage.getStartedBtn).tap();
          expect($(OnboardingPage.registrationInfoPanel), findsOneWidget);
          expect($(OnboardingPage.registrationDetailsPanel), findsOneWidget);
        },
      );

      patrolWidgetTest(
        'visitor - get started screen looks OK',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.onboardingScreenLooksAsExpected(
            $,
            RegistrationState.getStarted,
          );
        },
      );

      patrolWidgetTest(
        'visitor - get started screen close button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.closeBtn($).tap();
          expect($(OnboardingPage.registrationDialog), findsNothing);
        },
      );

      patrolWidgetTest(
        'visitor - create - keychain info screen looks OK',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
          await OnboardingPage.onboardingScreenLooksAsExpected(
            $,
            RegistrationState.createKeychainInfo,
          );
        },
      );

      patrolWidgetTest(
        'visitor - create - keychain info screen back button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
          await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
          await OnboardingPage.registrationInfoPanelLooksAsExpected(
            $,
            RegistrationState.getStarted,
          );
        },
      );

      patrolWidgetTest(
        'visitor - create - keychain created screen looks OK',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
          await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
          await OnboardingPage.onboardingScreenLooksAsExpected(
            $,
            RegistrationState.createKeychainInfo,
          );
        },
      );

      patrolWidgetTest(
        'visitor - create - keychain created screen back button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
          await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
          await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
          await OnboardingPage.registrationInfoPanelLooksAsExpected(
            $,
            RegistrationState.createKeychainInfo,
          );
        },
      );

      patrolWidgetTest('visitor - create - mnemonic writedown screen looks OK',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await $(AppBarPage.getStartedBtn)
            .tap(settleTimeout: const Duration(seconds: 10));
        await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
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
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
          await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
          await $(OnboardingPage.nextButton).tap();
          await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
          await OnboardingPage.registrationInfoPanelLooksAsExpected(
            $,
            RegistrationState.keychainCreated,
          );
        },
      );

      patrolWidgetTest(
        'visitor - create - mnemonic writedown screen next button is disabled',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
          await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
          await $(OnboardingPage.nextButton).tap();
          await OnboardingPage.registrationInfoPanelLooksAsExpected(
            $,
            RegistrationState.keychainCreateMnemonicWritedown,
          );
          OnboardingPage.voicesButtonIsDisabled($, OnboardingPage.nextButton);
        },
      );

      patrolWidgetTest(
        'visitor - create - mnemonic input info screen looks OK',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
          await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
          await $(OnboardingPage.nextButton).tap();
          await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
          await $(OnboardingPage.nextButton).tap();
          await OnboardingPage.onboardingScreenLooksAsExpected(
            $,
            RegistrationState.keychainCreateMnemonicInputInfo,
          );
        },
      );

      patrolWidgetTest(
        'visitor - create - mnemonic input info screen back button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
          await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
          await $(OnboardingPage.nextButton).tap();
          await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
          await $(OnboardingPage.nextButton).tap();
          await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
          await OnboardingPage.registrationInfoPanelLooksAsExpected(
            $,
            RegistrationState.keychainCreateMnemonicWritedown,
          );
        },
      );

      patrolWidgetTest(
        'visitor - create - mnemonic input screen looks OK',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
          await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
          await $(OnboardingPage.nextButton).tap();
          await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
          await $(OnboardingPage.nextButton).tap();
          await $(OnboardingPage.nextButton).tap();
          //temporary: remove reset when seeds are no longer prefilled
          await $(OnboardingPage.resetButton).tap();
          await OnboardingPage.onboardingScreenLooksAsExpected(
            $,
            RegistrationState.keychainCreateMnemonicInput,
          );
        },
      );

      patrolWidgetTest(
        'visitor - create - mnemonic input screen back button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
          await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
          await $(OnboardingPage.nextButton).tap();
          await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
          await $(OnboardingPage.nextButton).tap();
          await $(OnboardingPage.nextButton).tap();
          await ($(OnboardingPage.backButton)).waitUntilVisible().tap();
          await OnboardingPage.registrationInfoPanelLooksAsExpected(
            $,
            RegistrationState.keychainCreateMnemonicInputInfo,
          );
        },
      );

      patrolWidgetTest(
        'visitor - create - mnemonic input - correct words unlock next button',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await $(AppBarPage.getStartedBtn)
              .tap(settleTimeout: const Duration(seconds: 10));
          await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
          await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
          await $(OnboardingPage.nextButton).tap();
          await OnboardingPage.storeSeedPhrases($);
          await $(OnboardingPage.seedPhraseStoredCheckbox).tap();
          await $(OnboardingPage.nextButton).tap();
          await $(OnboardingPage.nextButton).tap();
          //temporary: remove reset when seeds are no longer prefilled
          await $(OnboardingPage.resetButton).tap();
          await OnboardingPage.enterStoredSeedPhrases($);
          await $(OnboardingPage.nextButton).tap();
          await OnboardingPage.onboardingScreenLooksAsExpected(
            $,
            RegistrationState.keychainCreateMnemonicVerified,
          );
        },
      );
    },
  );
}
