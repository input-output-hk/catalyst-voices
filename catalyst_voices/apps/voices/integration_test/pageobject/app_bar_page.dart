import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/constants.dart';
import '../utils/translations_utils.dart';

class AppBarPage {
  AppBarPage(this.$);
  late PatrolTester $;
  final spacesDrawerButton = const Key('DrawerButton');
  final getStartedBtn = const Key('GetStartedButton');
  final finishRegistrationBtn = const Key('FinishRegistrationButton');
  final accountPopupBtn = const Key('AccountPopupButton');
  final lockBtn = const Key('LockButton');
  final unlockBtn = const Key('UnlockButton');
  final visitorBtn = const Key('VisitorBtn');
  final sessionAccountPopupMenuAvatar =
      const Key('SessionAccountPopupMenuAvatar');

  Future<void> spacesDrawerButtonExists({bool? reverse = false}) async {
    expect($(spacesDrawerButton).exists, !reverse!);
  }

  Future<void> spacesDrawerButtonClick() async {
    await $(spacesDrawerButton).waitUntilVisible().tap();
  }

  Future<void> getStartedBtnClick() async {
    await $(getStartedBtn).tap(settleTimeout: Time.short.duration);
  }

  Future<void> getStartedBtnIsVisible() async {
    expect($(getStartedBtn), findsOneWidget);
    expect($(getStartedBtn).$(Text).text, T.get('Get Started'));
  }

  Future<void> finishAccountCreationBtnIsVisible() async {
    expect($(finishRegistrationBtn), findsOneWidget);
    expect(
      $(finishRegistrationBtn).$(Text).text,
      T.get('Finish account creation'),
    );
  }

  Future<void> sessionAccountPopupMenuAvatarIsVisible() async {
    expect($(sessionAccountPopupMenuAvatar), findsOneWidget);
  }

  Future<void> accountPopupBtnClick() async {
    await $(accountPopupBtn).tap();
  }

  Future<void> lockBtnClick() async {
    await $(lockBtn).tap();
  }

  Future<void> unlockBtnIsVisible() async {
    expect($(unlockBtn), findsOneWidget);
  }

  Future<void> unlockBtnClick() async {
    await $(unlockBtn).tap();
  }

  Future<void> visitorBtnIsVisible() async {
    expect($(visitorBtn), findsOneWidget);
  }

  Future<void> looksAsExpectedForVisitor() async {
    await getStartedBtnIsVisible();
    await visitorBtnIsVisible();
  }

  Future<void> looksAsExpectedForVisitorOnboardingInProgress() async {
    await finishAccountCreationBtnIsVisible();
    await visitorBtnIsVisible();
  }
}
