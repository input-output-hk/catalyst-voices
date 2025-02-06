import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/constants.dart';
import '../../utils/translations_utils.dart';
import '../app_bar_page.dart';
import 'onboarding_page_interface.dart';

class GetStartedPanel implements OnboardingPage {
  PatrolTester $;
  GetStartedPanel(this.$);
  static const headerTitle = Key('HeaderTitle');
  static const pictureContainer = Key('PictureContainer');
  static const progressBar = Key('ProgressBar');
  static const learnMoreButton = Key('LearnMoreButton');

  static const registrationDetailsTitle = Key('RegistrationDetailsTitle');
  static const getStartedMessage = Key('GetStartedMessage');
  static const getStartedQuestion = Key('GetStartedQuestion');
  static const createNewKeychain = Key('CreateAccountType.createNew');
  static const recoverKeychain = Key('CreateAccountType.recover');

  Future<void> clickCreateNewKeychain() async {
    await $(createNewKeychain).tap();
  }

  @override
  Future<void> goto() async {
    await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
  }

  @override
  Future<void> verifyPageElements() async {
    expect($(headerTitle).text, T.get('Get Started'));
    expect($(pictureContainer).$(IconTheme), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      T.get('Learn More'),
    );
  }
}
