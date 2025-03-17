import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import '../step_1_get_started.dart';

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
      (await t()).accountCreationGetStartedTitle,
    );
    expect($(pictureContainer).$(IconTheme), findsOneWidget);
    expect(
      $(learnMoreButton).$(Text).text,
      (await t()).learnMore,
    );
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(registrationDetailsTitle).$(Text).text,
      (await t()).createBaseProfileInstructionsTitle,
    );
    expect(
      $(registrationDetailsBody).$(Text).text,
      (await t()).createBaseProfileInstructionsMessage,
    );
    expect(
      $(baseProfileExplanationText).$(Text).text,
      (await t()).headsUp,
    );
    expect(
      $(emailRequestTitle).text,
      (await t()).createBaseProfileInstructionsEmailRequest,
    );
    expect(
      $(emailRequestList).$(Flexible).at(0).$(Text).text,
      (await t()).createBaseProfileInstructionsEmailReason1,
    );
    expect(
      $(emailRequestList).$(Flexible).at(1).$(Text).text,
      (await t()).createBaseProfileInstructionsEmailReason2,
    );
    expect(
      $(emailRequestList).$(Flexible).at(2).$(Text).text,
      (await t()).createBaseProfileInstructionsEmailReason3,
    );
    expect($(createBaseProfileButton).visible, true);
    expect(await closeButton(), findsOneWidget);
  }
}
