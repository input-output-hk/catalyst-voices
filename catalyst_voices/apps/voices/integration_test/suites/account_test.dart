import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/account_dropdown_page.dart';
import '../pageobject/app_bar_page.dart';
import '../pageobject/onboarding/restore_flow/step_8_unlock_password_success_panel.dart';
import '../pageobject/profile_page.dart';
import '../pageobject/unlock_modal_page.dart';

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
    'Account dropdown -',
    () {
      patrolWidgetTest(
        tags: 'issues_1715',
        skip: true,
        'user - Account dropdown button opens account dropdown',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await UnlockPasswordSuccessPanel($).goto();
          await UnlockPasswordSuccessPanel($).clickGoToDashboard();
          await AppBarPage($).accountPopupBtnClick();
          await AccountDropdownPage($).accountDropdownLooksAsExpected();
        },
      );
      patrolWidgetTest(
        skip: true,
        'user - Account dropdown Profile & Keychain button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await UnlockPasswordSuccessPanel($).goto();
          await UnlockPasswordSuccessPanel($).clickGoToDashboard();
          await AppBarPage($).accountPopupBtnClick();
          await AccountDropdownPage($).clickProfileAndKeychain();
          await ProfilePage($).verifyPageElements();
        },
      );
      patrolWidgetTest(
          tags: 'issues_1715',
          skip: true,
          'user - locking account', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).clickGoToDashboard();
        await AppBarPage($).lockBtnClick();
        await AppBarPage($).unlockBtnIsVisible();
      });

      patrolWidgetTest(
          tags: 'issues_1715',
          skip: true,
          'user - locking and unlocking account', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).clickGoToDashboard();
        await AppBarPage($).lockBtnClick();
        await AppBarPage($).unlockBtnClick();
        await $(UnlockModalPage.unlockPasswordTextField).enterText('Test1234');
        await $(UnlockModalPage.unlockConfirmPasswordButton).tap();
        await AppBarPage($).unlockBtnIsVisible();
      });
      patrolWidgetTest('user changing email works', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).clickGoToDashboard();
        await AppBarPage($).accountPopupBtnClick();
        await AccountDropdownPage($).clickProfileAndKeychain();
        await ProfilePage($).clickEmailAddressEdit();
        await $(ProfilePage($).accountEmailTextField)
            .enterText('bera@gmail.com');
        await $(ProfilePage($).emailTileSaveBtn).tap();
        // await ProfilePage($).emailIsAsExpected('bera@gmail.com');
        // TODO(emiride): uncomment above when backend is ready
        // https://github.com/input-output-hk/catalyst-voices/issues/1597

      });
      patrolWidgetTest('user deletes keychain works', skip: true,
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).clickGoToDashboard();
        await AppBarPage($).accountPopupBtnClick();
        await AccountDropdownPage($).clickProfileAndKeychain();
        await ProfilePage($).removeKeychainClick();
        await $(ProfilePage($).deleteKeychainTextField)
            .enterText('Remove Keychain');
        await $(ProfilePage($).deleteKeychainContinueButton).tap();
        await $(ProfilePage($).keychainDeletedDialogCloseButton).tap();
        await AppBarPage($).visitorBtnIsVisible();
        await AppBarPage($).getStartedBtnIsVisible();
      });
    },
  );
}
