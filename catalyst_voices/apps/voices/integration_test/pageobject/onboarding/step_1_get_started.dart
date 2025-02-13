import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/translations_utils.dart';
import '../app_bar_page.dart';
import 'onboarding_base_page.dart';

class GetStartedPanel extends OnboardingPageBase {
  GetStartedPanel(super.$);
  final pictureContainer = const Key('PictureContainer');
  final learnMoreButton = const Key('LearnMoreButton');
  final getStartedMessage = const Key('GetStartedMessage');
  final getStartedQuestion = const Key('GetStartedQuestion');
  final createNewKeychain = const Key('CreateAccountType.createNew');
  final recoverKeychain = const Key('CreateAccountType.recover');

  Future<void> clickCreateNewKeychain() async {
    await $(createNewKeychain).tap();
  }

  Future<void> verifyInfoPanel() async {
    expect($(registrationInfoPanel).$(headerTitle).text, T.get('Get Started'));
    expect($(pictureContainer).$(IconTheme), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      T.get('Learn More'),
    );
    expect(await closeButton(), findsOneWidget);
  }

  @override
  Future<void> goto() async {
    await AppBarPage($).getStartedBtnClick();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
  }
}
