import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';
import '../utils/constants.dart';

class AppBarPage {
  AppBarPage(this.$);
  late PatrolTester $;
  final spacesDrawerButton = const Key('DrawerButton');
  final getStartedBtn = const Key('GetStartedButton');
  final accountPopupBtn = const Key('AccountPopupButton');
  final lockBtn = const Key('LockButton');
  final unlockBtn = const Key('UnlockButton');
  final visitorBtn = const Key('VisitorButton');

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
}
