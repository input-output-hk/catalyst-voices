import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/translations_utils.dart';
import 'onboarding_base_page.dart';
import 'step_2_base_profile_info.dart';

class SetupBaseProfilePanel extends OnboardingPageBase {
  SetupBaseProfilePanel(super.$);

  final baseProfileDetailsPanel = const Key('BaseProfileDetailsPanel');
  final titleText = const Key('TitleText');
  final displayNameTextField = const Key('DisplayNameTextField');
  final emailTextField = const Key('EmailTextField');
  final ideascaleInfoCard = const Key('IdeascaleInfoCard');

  PatrolFinder get infoCardTitleLocator =>
      $(ideascaleInfoCard).$(#InfoCardTitle);
  PatrolFinder get infoCardDescriptionLocator =>
      $(ideascaleInfoCard).$(#InfoCardDesc).$(Flexible).$(Text);

  @override
  Future<void> goto() async {
    await BaseProfileInfoPanel($).goto();
    await BaseProfileInfoPanel($).clickCreateBaseProfile();
  }

  Future<void> clickNext() async {
    await $(nextButton).tap();
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
      $(baseProfileDetailsPanel).$(titleText).text,
      T.get('Setup your base profile'),
    );
    expect($(displayNameTextField), findsOneWidget);
    expect(
      $(displayNameTextField).$(Text).text,
      T.get('*What should we call you?'),
    );
    expect($(emailTextField), findsOneWidget);
    expect(
      $(emailTextField).$(Text).text,
      T.get('*Your e-mail'),
    );
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
    expect($(ideascaleInfoCard), findsOneWidget);
    expect(infoCardTitleLocator.text, T.get('Ideascale account'));
    expect(
      infoCardDescriptionLocator.text,
      T.get(
        'Please use the e-mail you use on cardano.ideascale.com',
      ),
    );
  }
}
