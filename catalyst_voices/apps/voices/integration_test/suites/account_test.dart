import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/pages/discovery/discovery.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/account_dropdown_page.dart';
import '../pageobject/app_bar_page.dart';
import '../pageobject/profile_page.dart';
import '../pageobject/unlock_modal_page.dart';
import '../utils/test_utils.dart';

void accountTests() {
  group(
    'page -',
    () {
      setUp(() async {
        final account = await TestAccounts.dummyAccount();
        await TestStateUtils.switchToAccount(account);
      });

      // Add a simple first test that just verifies setup
      patrolWidgetTest(
        'SETUP - app initializes correctly',
        (PatrolTester $) async {
          await TestStateUtils.removeAccounts();
          await TestStateUtils.pumpApp($);

          // Just verify the app starts state
          expect(find.byType(App), findsOneWidget);
          await AppBarPage($).getStartedBtnIsVisible();
        },
      );

      patrolWidgetTest(
        'removing keychain logs out the user',
        (PatrolTester $) async {
          await TestStateUtils.pumpApp($);

          await AppBarPage($).accountPopupBtnClick();

          await $.pumpAndTrySettle();

          await AccountDropdownPage($).clickProfileAndKeychain();
          await ProfilePage($).removeKeychainClick();
          await $(ProfilePage($).deleteKeychainTextField).enterText('Remove Keychain');
          await $(ProfilePage($).deleteKeychainContinueButton).tap();
          await AppBarPage($).getStartedBtnIsVisible();
        },
      );

      patrolWidgetTest(
        'user - locking and unlocking account',
        (PatrolTester $) async {
          const unlockFactor = Account.dummyUnlockFactor;
          await TestStateUtils.pumpApp($);

          await AppBarPage($).lockBtnClick();
          await AppBarPage($).unlockBtnClick();
          await $(UnlockModalPage($).unlockPasswordTextField).enterText(unlockFactor.data);
          await $(UnlockModalPage($).unlockConfirmPasswordButton).tap();
        },
      );

      patrolWidgetTest(
        'user - unlocking - wrong password error appears',
        (PatrolTester $) async {
          await TestStateUtils.lock();
          await TestStateUtils.pumpApp($);

          await AppBarPage($).unlockBtnClick();
          await $(UnlockModalPage($).unlockPasswordTextField).enterText('admin_admin');
          await $(UnlockModalPage($).unlockConfirmPasswordButton).tap();
          await UnlockModalPage($).incorrectPasswordErrorShowsUp();
        },
      );

      patrolWidgetTest(
        'user - clicking back button from account page',
        (PatrolTester $) async {
          await TestStateUtils.pumpApp($);

          await AppBarPage($).accountPopupBtnClick();
          await AccountDropdownPage($).clickProfileAndKeychain();
          await ProfilePage($).clickBackButton();
          expect(find.byType(DiscoveryPage), findsOneWidget);
        },
      );

      patrolWidgetTest(
        'user - changing name works',
        (PatrolTester $) async {
          const name = 'Test Name';
          await TestStateUtils.pumpApp($);

          await AppBarPage($).accountPopupBtnClick();
          await AccountDropdownPage($).clickProfileAndKeychain();
          await ProfilePage($).clickDisplayNameEdit();
          await $(ProfilePage($).accDisplayNameTxtField).enterText(name);

          await $.pump();

          await ProfilePage($).clickDisplayNameSave();
          await ProfilePage($).displayNameIsAsExpected(name);
        },
      );

      patrolWidgetTest(
        'user - account page - create proposal button disappears',
        (PatrolTester $) async {
          await TestStateUtils.pumpApp($);

          await AppBarPage($).accountPopupBtnClick();
          await AccountDropdownPage($).clickProfileAndKeychain();
          await AppBarPage($).createProposalBtnIsNotVisible();
        },
      );

      patrolWidgetTest(
        tags: 'issues_1597',
        'user changing email works',
        (PatrolTester $) async {
          await TestStateUtils.pumpApp($);

          await AppBarPage($).accountPopupBtnClick();
          await AccountDropdownPage($).clickProfileAndKeychain();
          await ProfilePage($).clickEmailAddressEdit();
          await $(ProfilePage($).accountEmailTextField).enterText('bera@gmail.com');
          await ProfilePage($).clickEmailAddressSave();
          await ProfilePage($).emailIsAsExpected('bera@gmail.com');

          // https://github.com/input-output-hk/catalyst-voices/issues/1597
        },
      );
    },
  );

  group(
    'dropdown -',
    () {
      setUp(() async {
        final account = await TestAccounts.dummyAccount();
        await TestStateUtils.switchToAccount(account);
      });

      patrolWidgetTest(
        tags: 'issues_1715',
        'user - Account dropdown button opens account dropdown',
        (PatrolTester $) async {
          await TestStateUtils.pumpApp($);

          await AppBarPage($).accountPopupBtnClick();
          await AccountDropdownPage($).accountDropdownLooksAsExpected();
        },
      );

      patrolWidgetTest(
        tags: 'issues_1715',
        'user - Account dropdown Profile & Keychain button works',
        (PatrolTester $) async {
          await TestStateUtils.pumpApp($);

          await AppBarPage($).accountPopupBtnClick();
          await AccountDropdownPage($).clickProfileAndKeychain();
          await ProfilePage($).verifyPageElements();
        },
      );
    },
  );
}
