import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_3_setup_base_profile.dart';

class AcknowledgmentsPanel extends OnboardingPageBase {
  AcknowledgmentsPanel(super.$);
  final acknowledgmentsTile = const Key('AcknowledgementsTitle');
  final tosCheckbox = const Key('TosCheckbox');
  final privacyPolicyCheckbox = const Key('PrivacyPolicyCheckbox');
  final dataUsageCheckbox = const Key('DataUsageCheckbox');
  final placeholderRichText = const Key('PlaceholderRichText');
  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> goto() async {
    await SetupBaseProfilePanel($).goto();
    await SetupBaseProfilePanel($).clickNext();
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
      $(acknowledgmentsTile).text,
      (await t()).createBaseProfileAcknowledgementsTitle,
    );
    final tosText =
        (await t()).createBaseProfileAcknowledgementsToS.split('{tos}')[0];
    expect(
      find.byWidgetPredicate(
        (widget) {
          if (widget is Text) {
            return widget.data?.contains(tosText) ?? false;
          } else if (widget is RichText) {
            return widget.text.toPlainText().contains(tosText);
          }
          return false;
        },
      ),
      findsOneWidget,
    );
  }
}
