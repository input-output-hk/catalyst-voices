import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/constants.dart';
import '../../../utils/selector_utils.dart';
import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_3_setup_profile.dart';

class AcknowledgmentsPanel extends OnboardingPageBase {
  final acknowledgmentsTile = const Key('AcknowledgementsTitle');
  final tosCheckbox = const Key('TosCheckbox');
  final privacyPolicyCheckbox = const Key('PrivacyPolicyCheckbox');
  final dataUsageCheckbox = const Key('DataUsageCheckbox');
  final placeholderRichText = const Key('PlaceholderRichText');

  AcknowledgmentsPanel(super.$);

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await SetupProfilePanel($).goto();
    await SetupProfilePanel($).clickNext();
  }

  Future<void> verifyDetailsPanel() async {
    expect(
      $(acknowledgmentsTile).text,
      (await t()).createProfileAcknowledgementsTitle,
    );
    final tosText = (await t()).createProfileAcknowledgementsToS('{tos}').split('{tos}')[0];
    final tosTextCurrent = $(tosCheckbox).$(Row).$(RichText);
    expect(tosTextCurrent.text?.contains(tosText), true);
    final policyText = (await t())
        .createProfileAcknowledgementsPrivacyPolicy('{privacy_policy}')
        .split('{privacy_policy}')[0];
    final policyTextCurrent = $(privacyPolicyCheckbox).$(Row).$(RichText);
    expect(policyTextCurrent.text?.contains(policyText), true);
    final dataUsageText = (await t()).createProfileAcknowledgementsDataUsage;
    final dataUsageTextCurrent = $(dataUsageCheckbox).$(Row).$(Text).text;
    expect(dataUsageTextCurrent?.contains(dataUsageText), true);
    await verifyOpeningLinks();
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

  Future<void> verifyOpeningLinks() async {
    final tosLinkText = (await t()).catalystTos;
    await SelectorUtils.checkOpeningLinkByMocking($, tosLinkText, Urls.tos);
    final policyLinkText = (await t()).catalystPrivacyPolicy;
    await SelectorUtils.checkOpeningLinkByMocking(
      $,
      policyLinkText,
      Urls.privacyPolicy,
    );
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }
}
