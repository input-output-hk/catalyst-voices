import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_2_profile_info.dart';

class SetupProfilePanel extends OnboardingPageBase {
  final profileDetailsPanel = const Key('ProfileDetailsPanel');
  final titleText = const Key('TitleText');
  final displayNameTextField = const Key('DisplayNameTextField');
  final emailTextField = const Key('EmailTextField');
  final ideascaleInfoCard = const Key('IdeascaleInfoCard');

  SetupProfilePanel(super.$);

  PatrolFinder get infoCardDescriptionLocator =>
      $(ideascaleInfoCard).$(#InfoCardDesc).$(Flexible).$(Text);
  PatrolFinder get infoCardTitleLocator => $(ideascaleInfoCard).$(#InfoCardTitle);

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await ProfileInfoPanel($).goto();
    await ProfileInfoPanel($).clickCreateProfile();
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(profileDetailsPanel).$(titleText).text,
      (await t()).createProfileSetupTitle,
    );
    expect($(displayNameTextField), findsOneWidget);
    expect(
      $(displayNameTextField).$(Text).text,
      '*${(await t()).createProfileSetupDisplayNameLabel}',
    );
    expect($(emailTextField), findsOneWidget);
    expect(
      $(emailTextField).$(Text).text,
      '*${(await t()).createProfileSetupEmailLabel}',
    );
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
    expect($(ideascaleInfoCard), findsOneWidget);
    expect(
      infoCardTitleLocator.text,
      (await t()).createProfileHasIdeascaleAccountAlready,
    );
    expect(
      infoCardDescriptionLocator.text,
      (await t()).createProfileSetupIdeascaleReason1,
    );
  }

  Future<void> verifyInfoPanel() async {
    expect(
      $(registrationInfoPanel).$(headerTitle).text,
      (await t()).accountCreationGetStartedTitle,
    );
    expect($(pictureContainer).$(IconTheme), findsOneWidget);
    expect($(learnMoreButton).$(Text).text, (await t()).learnMore);
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }
}
