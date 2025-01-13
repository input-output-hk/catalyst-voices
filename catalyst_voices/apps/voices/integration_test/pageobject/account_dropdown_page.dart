import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/translations_utils.dart';

class AccountDropdownPage {
  static const popUpMenuAccountHeader = Key('PopUpMenuAccountHeader');
  static const popUpMenuMyAccount = Key('PopUpMenuMyAccount');
  static const popUpMenuProfileAndKeychain = Key('PopUpMenuProfileAndKeychain');
  static const popUpMenuLock = Key('PopUpMenuLockAccount');

  static Future<void> accountDropdownContainsSpecificData(
    PatrolTester $,
  ) async {
    expect(
      $(popUpMenuAccountHeader).$(Expanded).$(Text).text?.isNotEmpty,
      true,
      reason: 'The wallet name should not be an empty string.',
    );
    expect(
      $(popUpMenuAccountHeader).$(Expanded).$(Text).at(1).text?.contains('₳'),
      true,
      reason: 'The account balance should contain the symbol ₳.',
    );
    expect(
      $(popUpMenuMyAccount).$(Text).text,
      T.get('My account'),
    );
    expect(
      $(popUpMenuProfileAndKeychain).$(Text).text,
      T.get('Profile & Keychain'),
    );
    expect($(popUpMenuLock).$(Text).text, T.get('Lock account'));
  }

  static Future<void> accountDropdownLooksAsExpected(
    PatrolTester $,
  ) async {
    expect($(popUpMenuAccountHeader), findsOneWidget);
    expect($(popUpMenuMyAccount), findsOneWidget);
    expect($(popUpMenuProfileAndKeychain), findsOneWidget);
    expect($(popUpMenuLock), findsOneWidget);
  }
}
