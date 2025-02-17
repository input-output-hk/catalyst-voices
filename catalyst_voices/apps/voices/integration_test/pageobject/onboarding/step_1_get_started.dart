import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/constants.dart';
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

  @override
  Future<void> goto() async {
    await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
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

  Future<void> verifyDetailsPanel() async {
    expect(
      $(registrationDetailsTitle).$(Text).text,
      T.get('Welcome to Catalyst'),
    );
    expect(
      $(registrationDetailsBody).$(Text).text,
      T.get(
        'If you already have a Catalyst keychain you can restore it '
        'on this device, or you can create a new Catalyst Keychain.',
      ),
    );
    expect($(getStartedQuestion).text, T.get('What do you want to do?'));
    expect(
      $(createNewKeychain).$(registrationTileTitle).text,
      T.get('Create a new \nCatalyst Keychain'),
    );
    expect(
      $(createNewKeychain).$(registrationTileSubtitle).text,
      T.get('On this device'),
    );
    expect(
      $(recoverKeychain).$(registrationTileTitle).text,
      T.get('Recover your\nCatalyst Keychain'),
    );
    expect(
      $(recoverKeychain).$(registrationTileSubtitle).text,
      T.get('On this device'),
    );
  }
}
