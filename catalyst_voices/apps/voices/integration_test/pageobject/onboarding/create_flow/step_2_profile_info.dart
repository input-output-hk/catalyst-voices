import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import '../step_1_get_started.dart';

class ProfileInfoPanel extends OnboardingPageBase {
  final createProfileButton = const Key('CreateProfileNext');
  final profileExplanationText = const Key('ProfileExplanationTest');
  final emailRequestTitle = const Key('EmailRequestTitle');
  final emailRequestList = const Key('EmailRequestList');

  ProfileInfoPanel(super.$);

  Future<void> clickCreateProfile() async {
    await $(createProfileButton).tap();
  }

  @override
  Future<void> goto() async {
    await GetStartedPanel($).goto();
    await GetStartedPanel($).clickCreateNewKeychain();
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(registrationDetailsTitle).$(Text).text,
      (await t()).createProfileInstructionsTitle,
    );
    expect(
      $(registrationDetailsBody).$(Text).text,
      (await t()).createProfileInstructionsMessage,
    );
    expect(
      $(profileExplanationText).$(Text).text,
      (await t()).headsUp,
    );
    expect(
      $(emailRequestTitle).text,
      (await t()).createProfileInstructionsEmailRequest,
    );
    expect(
      $(emailRequestList).$(Flexible).at(0).$(Text).text,
      (await t()).createProfileInstructionsEmailReason1,
    );
    expect(
      $(emailRequestList).$(Flexible).at(1).$(Text).text,
      (await t()).createProfileInstructionsEmailReason2,
    );
    expect($(createProfileButton).visible, true);
    expect(await closeButton(), findsOneWidget);
  }

  Future<void> verifyInfoPanel() async {
    expect(
      $(registrationInfoPanel).$(headerTitle).text,
      (await t()).accountCreationGetStartedTitle,
    );
    expect($(pictureContainer).$(IconTheme), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      (await t()).learnMore,
    );
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }
}
