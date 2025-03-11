import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/account_dropdown_page.dart';
import '../pageobject/app_bar_page.dart';
import '../pageobject/overall_spaces_page.dart';
import '../pageobject/unlock_modal_page.dart';
import '../utils/constants.dart';

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

  group('Account dropdown -', () {
    patrolWidgetTest(
      tags: 'issues_1715',
      skip: true,
      'user - Account dropdown button opens account dropdown',
      (PatrolTester $) async {
        await $.pumpWidgetAndSettle(App(routerConfig: router));
        await $(OverallSpacesPage.userShortcutBtn)
            .tap(settleTimeout: const Duration(seconds: 10));
        await AppBarPage($).accountPopupBtnClick();
        await AccountDropdownPage($).accountDropdownLooksAsExpected();
      },
    );

    patrolWidgetTest(tags: 'issues_1715', skip: true, 'user - locking account',
        (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(OverallSpacesPage.userShortcutBtn)
          .tap(settleTimeout: const Duration(seconds: 10));
      await AppBarPage($).lockBtnClick();
      await AppBarPage($).unlockBtnIsVisible();
    });

    patrolWidgetTest(
        tags: 'issues_1715',
        skip: true,
        'user - locking and unlocking account', (PatrolTester $) async {
      await $.pumpWidgetAndSettle(App(routerConfig: router));
      await $(OverallSpacesPage.userShortcutBtn)
          .tap(settleTimeout: Time.long.duration);
      await AppBarPage($).lockBtnClick();
      await AppBarPage($).unlockBtnClick();
      await $(UnlockModalPage.unlockPasswordTextField).enterText('Test1234');
      await $(UnlockModalPage.unlockConfirmPasswordButton).tap();
      await AppBarPage($).unlockBtnIsVisible();
    });
  });
}
