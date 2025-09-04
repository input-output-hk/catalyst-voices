import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import '../step_1_get_started.dart';

final class ProfileInfoPanel extends OnboardingPageBase {
  final profileExplanationText = const Key('ProfileExplanationTest');
  final emailRequestTitle = const Key('EmailRequestTitle');
  final emailRequestList = const Key('EmailRequestList');

  ProfileInfoPanel(super.$);

  @override
  Key get nextButton => const Key('CreateBaseProfileNext');

  Future<void> clickCreateProfile() async {
    await $(nextButton).tap();
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
      $(emailRequestTitle).text,
      (await t()).createProfileInstructionsEmailRequest,
    );
    expect($(nextButton).visible, true);
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
