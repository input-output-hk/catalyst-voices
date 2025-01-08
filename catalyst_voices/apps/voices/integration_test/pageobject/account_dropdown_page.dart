import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

class AccountDropdownPage {
  static const popUpMenuAccountHeader = Key('PopUpMenuAccountHeader');
  static const popUpMenuMyAccount = Key('PopUpMenuMyAccount');
  static const popUpMenuProfileAndKeychain = Key('PopUpMenuProfileAndKeychain');
  static const popUpMenuLock = Key('PopUpMenuLockAccount');

  static Future<void> accountDropdownLooksAsExpected(
    PatrolTester $,
  ) async {
    expect($(popUpMenuAccountHeader), findsOneWidget);
    expect($(popUpMenuMyAccount), findsOneWidget);
    expect($(popUpMenuProfileAndKeychain), findsOneWidget);
    expect($(popUpMenuLock), findsOneWidget);
  }
}
