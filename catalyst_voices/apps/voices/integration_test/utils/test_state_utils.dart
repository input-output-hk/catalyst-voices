import 'dart:math';

import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/app/view/app_precache_image_assets.dart';
import 'package:catalyst_voices/app/view/video_cache/app_video_manager.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_finders/patrol_finders.dart';

/// Utilities for managing test state between tests
class TestStateUtils {
  /// Helper method to ensure we start from a clean visitor state
  /// This checks if user is logged in and logs them out if needed
  /// NOTE: App must already be pumped before calling this function
  static Future<void> ensureCleanVisitorState(
    PatrolTester $,
    GoRouter router,
  ) async {
    throw UnimplementedError('Should use UserService instead');
    /*// Give app time to initialize and restore any previous session
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Check if user is already logged in (sessionAccountPopupMenuAvatar visible)
    final isLoggedIn = await AppBarPage($).getStartedBtnExists();

    if (!isLoggedIn) {
      // User is logged in - need to logout
      print('🔄 User already logged in, logging out...');

      // Try to access account dropdown and remove keychain
      try {
        await AppBarPage($).accountPopupBtnClick();
        await AccountDropdownPage($).clickProfileAndKeychain();
        await ProfilePage($).removeKeychainClick();
        await $(ProfilePage($).deleteKeychainTextField).enterText('Remove Keychain');
        await $(ProfilePage($).deleteKeychainContinueButton).tap();
        await $(ProfilePage($).keychainDeletedDialogCloseButton).tap();

        // Verify we're back to visitor state
        await AppBarPage($).visitorBtnIsVisible();
        await AppBarPage($).getStartedBtnIsVisible();
        print('✅ Successfully logged out user');
      } catch (e) {
        print('⚠️ Could not logout via UI, user might be in locked state: $e');
      }
    }

    // Ensure we're on discovery route in visitor state
    router.go(const DiscoveryRoute().location);

    // Final verification - should see visitor UI
    try {
      await AppBarPage($).visitorBtnIsVisible();
      await AppBarPage($).getStartedBtnIsVisible();
      print('✅ Clean visitor state confirmed');
    } catch (e) {
      print('⚠️ Not in expected visitor state: $e');
    }*/
  }

  static Future<void> lock() async {
    final service = Dependencies.instance.get<UserService>();

    final activeAccount = await service.getUser().then((value) => value.activeAccount);
    await activeAccount?.keychain.lock();
  }

  static Future<void> pumpApp(
    PatrolTester $, {
    GoRouter? router,
    bool debugLogs = false,
  }) async {
    router ??= AppRouterFactory.create();

    void logWidgets() {
      final allWidgets = $.tester.allWidgets;
      final lastWidgets = allWidgets.skip(max(0, allWidgets.length - 20)).toList();
      debugPrint('last 20 widgets -> $lastWidgets');
    }

    if (debugLogs) debugPrint('Pumping app');

    await $.pumpWidgetAndSettle(App(routerConfig: router));

    if (debugLogs) debugPrint('Awaiting VideoManager to initialize');

    await Dependencies.instance.get<VideoManager>().isInitialized;

    await $.pump();

    if (debugLogs) debugPrint('awaiting precache to initialize');

    await ImagePrecacheService.instance.isInitialized;

    if (debugLogs) {
      logWidgets();
      debugPrint('1st pump and try settle');
    }

    await $.pumpAndTrySettle();

    if (debugLogs) {
      logWidgets();
      debugPrint('2nd pump and try settle');
    }

    await $.pumpAndTrySettle();

    if (debugLogs) logWidgets();
  }

  static Future<void> switchToAccount(Account account) async {
    final service = Dependencies.instance.get<UserService>();

    await service.useAccount(account);
  }

  static Future<void> unlock(LockFactor unlock) async {
    final service = Dependencies.instance.get<UserService>();

    final activeAccount = await service.getUser().then((value) => value.activeAccount);
    await activeAccount?.keychain.unlock(unlock);
  }
}
