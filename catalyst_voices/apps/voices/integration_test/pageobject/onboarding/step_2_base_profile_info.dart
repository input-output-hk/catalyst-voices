import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/translations_utils.dart';
import 'onboarding_base_page.dart';
import 'step_1_get_started.dart';

class BaseProfileInfoPanel extends OnboardingPageBase {
  BaseProfileInfoPanel(super.$);

  final createBaseProfileButton = const Key('CreateBaseProfileNext');
  final baseProfileExplanationText = const Key('BaseProfileExplanationTest');
  final emailRequestTitle = const Key('EmailRequestTitle');
  final emailRequestList = const Key('EmailRequestList');

  @override
  Future<void> goto() async {
    await GetStartedPanel($).goto();
    await GetStartedPanel($).clickCreateNewKeychain();
  }

  Future<void> clickCreateBaseProfile() async {
    await $(createBaseProfileButton).tap();
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyInfoPanel() async {
    expect(
      $(registrationInfoPanel).$(headerTitle).text,
      T.get('Welcome to Catalyst'),
    );
    expect($(pictureContainer).$(IconTheme), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      T.get('Learn More'),
    );
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(registrationDetailsTitle).$(Text).text,
      T.get('Introduction'),
    );
    expect(
      $(registrationDetailsBody).$(Text).text,
      T.get(
        'In the following account creation steps we will:\n\n1. Setup your base'
        ' profile\n2. Create your Catalyst Keychain\n3. Link Cardano wallet &'
        ' roles\n\nTo ensure a smooth experience, completing your account setup'
        ' in one session is essential—stay focused and avoid interruptions to'
        ' finalize everything efficiently.',
      ),
    );
    expect(
      $(baseProfileExplanationText).$(Text).text,
      T.get('Heads up'),
    );
    expect($(emailRequestTitle).text, T.get('Email request'));
    expect(
      $(emailRequestList).$(Flexible).at(0).$(Text).text,
      T.get('We store email in a mutable database.'),
    );
    expect(
      $(emailRequestList).$(Flexible).at(1).$(Text).text,
      T.get('We do not store your email on-chain ever.'),
    );
    expect(
      $(emailRequestList).$(Flexible).at(2).$(Text).text,
      T.get('We only use email for communication about Catalyst.'),
    );
    expect($(createBaseProfileButton).visible, true);
    expect(await closeButton(), findsOneWidget);
  }
}
