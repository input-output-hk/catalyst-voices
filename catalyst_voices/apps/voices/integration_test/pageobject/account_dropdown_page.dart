import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/translations_utils.dart';

class AccountDropdownPage {
  PatrolTester $;
  AccountDropdownPage(this.$);

  final profileAndKeychainText = const Key('ProfileAndKeychain');
  final popUpMenuAccountHeader = const Key('PopUpMenuAccountHeader');
  final popUpMenuMyAccount = const Key('PopUpMenuMyAccount');
  final popUpMenuProfileAndKeychain = const Key('PopUpMenuProfileAndKeychain');
  final popUpMenuLock = const Key('PopUpMenuLockAccount');
  final segmentedButton = const Key('SegmentedButton');
  final setupRolesMenuItem = const Key('SetupRolesMenuItem');
  final redirectToSupportMenuItem = const Key('SubmitSupportRequest');
  final redirectToDocsMenuItem = const Key('CatalystKnowledgeBase');
  final segmentedButtonContainer = const Key('segmentedButtonContainer');
  final lockAccountButton = const Key('LockAccountButton');

  Future<void> accountDropdownContainsSpecificData() async {
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
      (await t()).myAccount,
    );
    expect(
      $(popUpMenuProfileAndKeychain).$(Text).text,
      (await t()).profileAndKeychain,
    );
    expect($(popUpMenuLock).$(Text).text, (await t()).lockAccount);
  }

  Future<void> accountDropdownLooksAsExpected() async {
    expect($(profileAndKeychainText), findsOneWidget);
    expect($(segmentedButton), findsWidgets);
    expect($(setupRolesMenuItem), findsOneWidget);
    expect($(lockAccountButton), findsOneWidget);
  }

  Future<void> clickProfileAndKeychain() async {
    await $(profileAndKeychainText).tap();
  }

  Future<void> clickDarkTheme() async {
    await $(segmentedButton).$('Dark').tap();
  }

  Future<void> clickLightTheme() async {
    await $(segmentedButton).$('Light').tap();
  }

  Future<void> clickUTC() async {
    await $(segmentedButton).$('UTC').tap();
  }

  Future<void> clickLocal() async {
    await $(segmentedButton).$('Local').tap();
  }

  Future<void> clickSetupRoles() async {
    await $(setupRolesMenuItem).tap();
  }

  Future<void> clickRedirectToSupport() async {
    await $(redirectToSupportMenuItem).tap();
  }

  Future<void> clickRedirectToDocs() async {
    await $(redirectToDocsMenuItem).tap();
  }
}
