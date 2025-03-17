import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/translations_utils.dart';
import '../app_bar_page.dart';
import 'onboarding_base_page.dart';

class GetStartedPanel extends OnboardingPageBase {
  GetStartedPanel(super.$);
  final getStartedMessage = const Key('GetStartedMessage');
  final getStartedQuestion = const Key('GetStartedQuestion');
  final createNewKeychain = const Key('CreateAccountType.createNew');
  final recoverKeychain = const Key('CreateAccountType.recover');

  @override
  Future<void> goto() async {
    await AppBarPage($).getStartedBtnClick();
  }

  Future<void> clickCreateNewKeychain() async {
    await $(createNewKeychain).tap();
  }

  Future<void> clickRecoverKeychain() async {
    await $(recoverKeychain).tap();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyInfoPanel() async {
    expect(
      $(registrationInfoPanel).$(headerTitle).text,
      (await t()).getStarted,
    );
    expect($(pictureContainer).$(IconTheme), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      (await t()).learnMore,
    );
    expect(await closeButton(), findsOneWidget);
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(registrationDetailsTitle).$(Text).text,
      (await t()).accountCreationGetStartedTitle,
    );
    expect(
      $(registrationDetailsBody).$(Text).text,
      (await t()).accountCreationGetStatedDesc,
    );
    expect(
      $(getStartedQuestion).text,
      (await t()).accountCreationGetStatedWhatNext,
    );
    expect(
      $(createNewKeychain).$(registrationTileTitle).text,
      (await t()).accountCreationCreate,
    );
    expect(
      $(createNewKeychain).$(registrationTileSubtitle).text,
      (await t()).accountCreationOnThisDevice,
    );
    expect(
      $(recoverKeychain).$(registrationTileTitle).text,
      (await t()).accountCreationRecover,
    );
    expect(
      $(recoverKeychain).$(registrationTileSubtitle).text,
      (await t()).accountCreationOnThisDevice,
    );
  }
}
