import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/account_dropdown_page.dart';
import '../pageobject/app_bar_page.dart';
import '../pageobject/onboarding/restore_flow/step_6_unlock_password_success_panel.dart';
import '../pageobject/profile_page.dart';
import '../pageobject/unlock_modal_page.dart';
import '../utils/bootstrap_utils.dart';
import '../utils/test_state_utils.dart';

void main() async {
  late final GoRouter router;

  setUpAll(() async {
    router = buildAppRouter(); 
  });

  setUp(() async {
    await registerForTests();
    router.go(const DiscoveryRoute().location);
  });

  tearDown(() async {
    await restartForTests();
  });
  group(
    'Account page -',
    () {
      // Add a simple first test that just verifies setup
      patrolWidgetTest('SETUP - app initializes correctly', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await TestStateUtils.ensureCleanVisitorState($, router);
        // Just verify the app starts and is in visitor state
        expect(find.byType(App), findsOneWidget);
        await AppBarPage($).visitorBtnIsVisible();
        await AppBarPage($).getStartedBtnIsVisible();
      });
      
      patrolWidgetTest('removing keychain logs out the user', (PatrolTester $) async {
        print('\n\nremoving keychain logs out the user');
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await TestStateUtils.ensureCleanVisitorState($, router);
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).clickGoToDashboard();
        await AppBarPage($).accountPopupBtnClick(); 
        await AccountDropdownPage($).clickProfileAndKeychain();
        await ProfilePage($).removeKeychainClick();
        await $(ProfilePage($).deleteKeychainTextField).enterText('Remove Keychain');
        await $(ProfilePage($).deleteKeychainContinueButton).tap();
        await AppBarPage($).visitorBtnIsVisible();
        await AppBarPage($).getStartedBtnIsVisible();
        print('removing keychain logs out the user\n\n');
      });            
     
      patrolWidgetTest('user - locking and unlocking account',skip: true, (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await TestStateUtils.ensureCleanVisitorState($, router);
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).clickGoToDashboard();
        await AppBarPage($).lockBtnClick();
        await AppBarPage($).unlockBtnClick();
        await $(UnlockModalPage($).unlockPasswordTextField).enterText('Test1234');
        await $(UnlockModalPage($).unlockConfirmPasswordButton).tap(); 
      
      });

        

      patrolWidgetTest('user - unlocking - wrong password error appears', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await TestStateUtils.ensureCleanVisitorState($, router);
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).clickGoToAccount();
        await AppBarPage($).lockBtnClick();
        await AppBarPage($).unlockBtnClick();
        await $(UnlockModalPage($).unlockPasswordTextField).enterText('Test12345');
        await $(UnlockModalPage($).unlockConfirmPasswordButton).tap();
        await UnlockModalPage($).incorrectPasswordErrorShowsUp();
        await UnlockModalPage($).closeButtonClick();
        await AppBarPage($).unlockBtnClick();
        await $(UnlockModalPage($).unlockPasswordTextField).enterText('Test1234');
        await $(UnlockModalPage($).unlockConfirmPasswordButton).tap();
     

      });
      patrolWidgetTest('user - clicking back button from account page',  (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await TestStateUtils.ensureCleanVisitorState($, router);
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).clickGoToAccount();
        await ProfilePage($).clickBackButton();
        await UnlockPasswordSuccessPanel($).verifyPageElements();
      
      });
      patrolWidgetTest('user - changing name works',(PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await TestStateUtils.ensureCleanVisitorState($, router);
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).clickGoToAccount();
        await ProfilePage($).clickDisplayNameEdit();
        await $(ProfilePage($).accDisplayNameTxtField).enterText('Test Name');
        await $(ProfilePage($).emailTileSaveBtn).tap();
        await UnlockPasswordSuccessPanel($).verifyPageElements();
       

      });
      patrolWidgetTest('user - account page - create proposal button disappears',(PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await TestStateUtils.ensureCleanVisitorState($, router);
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).clickGoToAccount();
        await AppBarPage($).createProposalBtnIsNotVisible();
        await UnlockPasswordSuccessPanel($).verifyPageElements();
       

      });
       patrolWidgetTest(tags: 'issues_1597', 'user changing email works',
          (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await TestStateUtils.ensureCleanVisitorState($, router);
        await UnlockPasswordSuccessPanel($).goto();
        await UnlockPasswordSuccessPanel($).clickGoToAccount();
        await ProfilePage($).clickEmailAddressEdit();
        await $(ProfilePage($).accountEmailTextField).enterText('bera@gmail.com');
        await $(ProfilePage($).emailTileSaveBtn).tap();
        await $(ProfilePage($).verificationEmailOkButton).tap();
        await ProfilePage($).emailIsAsExpected('bera@gmail.com');
       
        // https://github.com/input-output-hk/catalyst-voices/issues/1597
      });
    },
  );
 
  group(
    'Account dropdown -',
    () {
       patrolWidgetTest('SETUP - app initializes correctly', (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await TestStateUtils.ensureCleanVisitorState($, router);
        // Just verify the app starts and is in visitor state
        expect(find.byType(App), findsOneWidget);
        await AppBarPage($).visitorBtnIsVisible();
        await AppBarPage($).getStartedBtnIsVisible();
      });
      patrolWidgetTest(
        tags: 'issues_1715',
        'user - Account dropdown button opens account dropdown',
        (PatrolTester $) async {
          print('\n\nuser - Account dropdown button opens account dropdown');
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await TestStateUtils.ensureCleanVisitorState($, router);
          await UnlockPasswordSuccessPanel($).goto();
          await UnlockPasswordSuccessPanel($).clickGoToDashboard();
          await AppBarPage($).accountPopupBtnClick();
          await AccountDropdownPage($).accountDropdownLooksAsExpected();
          print('user - Account dropdown button opens account dropdown\n\n');
        },
      );

      patrolWidgetTest(
        tags: 'issues_1715',
        skip: true,
        'user - Account dropdown Profile & Keychain button works',
        (PatrolTester $) async {
          await $.pumpWidgetAndSettle(App(routerConfig: router));
          await TestStateUtils.ensureCleanVisitorState($, router);
          await UnlockPasswordSuccessPanel($).goto();
          await UnlockPasswordSuccessPanel($).clickGoToDashboard();
          await AppBarPage($).accountPopupBtnClick();
          await AccountDropdownPage($).clickProfileAndKeychain();
          await ProfilePage($).verifyPageElements();
        },
      );
    },
  );
}
