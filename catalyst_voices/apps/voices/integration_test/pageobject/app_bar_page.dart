import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../utils/constants.dart';
import '../utils/translations_utils.dart';

class AppBarPage {
  final PatrolTester $;

  final spacesDrawerButton = const Key('DrawerButton');
  final getStartedBtn = const Key('GetStartedButton');
  final finishRegistrationBtn = const Key('FinishRegistrationButton');
  final accountPopupBtn = const Key('AccountPopupButton');
  final lockBtn = const Key('LockButton');
  final unlockBtn = const Key('UnlockButton');
  final visitorBtn = const Key('VisitorBtn');
  final sessionAccountPopupMenuAvatar = const Key('SessionAccountPopupMenuAvatar');
  final createProposalBtn = const Key('CreateProposalButton');

  AppBarPage(this.$);

  Future<void> accountPopupBtnClick() async {
    await $(sessionAccountPopupMenuAvatar).tap();
  }

  Future<void> createProposalBtnIsNotVisible() async {
    expect($(createProposalBtn), findsNothing);
  }

  Future<void> createProposalBtnIsVisible() async {
    expect($(createProposalBtn), findsOneWidget);
  }

  Future<void> finishAccountCreationBtnIsVisible() async {
    expect($(finishRegistrationBtn), findsOneWidget);
    expect(
      $(finishRegistrationBtn).$(Text).text,
      (await t()).finishAccountCreation,
    );
  }

  Future<void> getStartedBtnClick() async {
    await $(getStartedBtn).tap(settleTimeout: Time.short.duration);
  }

  Future<bool> getStartedBtnExists() async {
    return $(getStartedBtn).exists;
  }

  Future<void> getStartedBtnIsVisible() async {
    expect($(getStartedBtn), findsOneWidget);
    expect($(getStartedBtn).$(Text).text, (await t()).getStarted);
  }

  Future<void> lockBtnClick() async {
    await $(lockBtn).tap();
  }

  Future<void> looksAsExpectedForVisitor() async {
    await getStartedBtnIsVisible();
    await visitorBtnIsVisible();
  }

  Future<void> looksAsExpectedForVisitorOnboardingInProgress() async {
    await finishAccountCreationBtnIsVisible();
    await visitorBtnIsVisible();
  }

  Future<void> sessionAccountPopupMenuAvatarIsVisible() async {
    expect($(sessionAccountPopupMenuAvatar), findsOneWidget);
  }

  Future<void> spacesDrawerButtonClick() async {
    await $(spacesDrawerButton).waitUntilVisible().tap();
  }

  Future<void> spacesDrawerButtonExists({bool reverse = false}) async {
    expect($(spacesDrawerButton).exists, !reverse);
  }

  Future<void> unlockBtnClick() async {
    await $(unlockBtn).tap();
  }

  Future<void> unlockBtnIsVisible() async {
    expect($(unlockBtn), findsOneWidget);
  }

  Future<void> visitorBtnIsVisible() async {
    expect($(visitorBtn), findsOneWidget);
  }
}
