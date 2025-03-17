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
      find.text('Mandatory Acknowledgements'),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is PlaceholderRichText &&
            widget.text ==
                'I confirm '
                    'that I have read and agree to be bound by {tos}.',
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is PlaceholderRichText &&
            widget.text ==
                'I acknowledge and agree that any data I share in '
                'connection with my participation in '
                'Project Catalyst Funds will be '
                'collected, stored, used and processed in accordance '
                'with the {privacy_policy}.',
      ),
      findsOneWidget,
    );

    expect(
      find.text('I acknowledge that the Catalyst Ops team may use my '
          'email only for Catalyst communication.'),
      findsOneWidget,
    );
  }
}
