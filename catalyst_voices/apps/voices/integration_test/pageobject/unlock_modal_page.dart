import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/translations_utils.dart';

class UnlockModalPage {
  UnlockModalPage(this.$);
  late PatrolTester $;

  static const unlockKeychainDialog = Key('UnlockKeychainDialog');
  static const unlockKeychainInfoPanel = Key('UnlockKeychainInfoPanel');
  static const unlockPasswordTextField = Key('UnlockPasswordTextField');
  static const unlockConfirmPasswordButton = Key('UnlockConfirmPasswordButton');
  static const unlockRecoverButton = Key('UnlockRecoverButton');
  static const unlockContinueAsGuestButton = Key('UnlockContinueAsGuestButton');
  static const passwordTextField = Key('PasswordTextField');

  Future<void> incorrectPasswordErrorShowsUp() async {
    expect(
      find.text((await t()).unlockDialogIncorrectPassword),
      findsOneWidget,
    );
  }
}
