import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/translations_utils.dart';

class UnlockModalPage {
  UnlockModalPage(this.$);
  late PatrolTester $;

  final unlockKeychainDialog = const Key('UnlockKeychainDialog');
  final unlockKeychainInfoPanel = const Key('UnlockKeychainInfoPanel');
  final unlockPasswordTextField = const Key('UnlockPasswordTextField');
  final unlockConfirmPasswordButton = const Key('UnlockConfirmPasswordButton');
  final unlockRecoverButton = const Key('UnlockRecoverButton');
  final unlockContinueAsGuestButton = const Key('UnlockContinueAsGuestButton');
  final passwordTextField = const Key('PasswordTextField');

  Future<void> incorrectPasswordErrorShowsUp() async {
    expect(
      find.text((await t()).unlockDialogIncorrectPassword),
      findsOneWidget,
    );
  }
}
