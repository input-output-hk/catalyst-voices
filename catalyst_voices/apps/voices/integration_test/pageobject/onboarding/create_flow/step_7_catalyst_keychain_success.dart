import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_6_catalyst_keychain_info.dart';

class CatalystKeychainSuccessPanel extends OnboardingPageBase {
  CatalystKeychainSuccessPanel(super.$);

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await CatalystKeychainInfoPanel($).goto();
    await CatalystKeychainInfoPanel($).clickCreateKeychain();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    expect(await closeButton(), findsOneWidget);
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

  Future<void> verifyDetailsPanel() async {
    expect(
      $(registrationDetailsTitle).$(Text).text,
      T.get('Great! Your Catalyst'
          ' Keychain has been created'),
    );
    expect(
      $(registrationDetailsBody).$(Text).text,
      T.get("On the next screen, you're going to see 12 words. \u2028This is"
      " called your \"Catalyst seed phrase\".   \u2028\u2028It's like a super "
      'secure password that only you know, \u2028that allows you to prove '
      'ownership of your keychain.  \u2028\u2028Use your Catalyst seed phrase '
      'to login and recover your account on different devices, so be sure to '
      'put it somewhere safe!\n\nIt is a super secure password that only you '
      'know, so best is to write it down with pen and paper, '
      'so get this ready. '),
    );
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
  }
}
