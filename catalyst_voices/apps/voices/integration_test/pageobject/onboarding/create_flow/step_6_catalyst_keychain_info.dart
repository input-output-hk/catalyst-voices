import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_5_base_profile_final.dart';

class CatalystKeychainInfoPanel extends OnboardingPageBase {
  CatalystKeychainInfoPanel(super.$);

  static const createKeychainButton = Key('CreateKeychainButton');
  final registrationDetailsTitle = Key('RegistrationDetailsTitle');
  Future<void> clickCreateKeychain() async {
    await $(createKeychainButton).tap();
  }

  @override
  Future<void> goto() async {
    await BaseProfileFinalPanel($).goto();
    await BaseProfileFinalPanel($).clickCreateKeychain();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), T.get('Catalyst Keychain'));
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
        expect(
      $(learnMoreButton).$(Text).text,
      T.get('Learn More'),
    );
  }
  
  Future<void> verifyDetailsPanel() async{
    expect($(registrationDetailsTitle).$(Text).text, T.get('Create your Catalyst Keychain'));
    expect(
      $(registrationDetailsBody).$(Text).text,
      T.get('Catalyst Keychain is your ticket to participate in innovation on '
      'the global stage.  \u2028\u2028These next steps will create your '
      'Catalyst keychain so you can enter new spaces, discover awesome ideas, '
      'and share your feedback to help improve ideas.'),
    );
    expect($(createKeychainButton), findsOneWidget);
  }
}
