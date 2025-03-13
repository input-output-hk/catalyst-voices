import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/translations_utils.dart';
import '../onboarding_base_page.dart';
import 'step_3_setup_base_profile.dart';

class AcknowledgmentsPanel extends OnboardingPageBase {
  AcknowledgmentsPanel(super.$);
  final acknowledgmentsTile = const Key('AcknowledgementsTitle');
  final tosRichText = const ValueKey('TosRichText');
  final tosCheckbox = const Key('TosCheckbox');
  final privacyPolicyCheckbox = const Key('PrivacyPolicyCheckbox');
  final richText = const Key('PlaceholderRichText');
  final privacyPolicyRichText = const Key('PrivacyPolicyRichText');
  final checkbox = const Key('Checkbox');
  final bcakButton = const Key('BackButton');
  final nextButton = const Key('NextButton');

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
    expect($(acknowledgmentsTile).text, T.get('Mandatory Acknowledgements'));
    expect(
      find.text(
        'I confirm that I have read and agree to be bound by '
        'Project Catalyst Terms and Conditions.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'I acknowledge and agree that any data I share in connection with my'
        ' participation in Project Catalyst Funds will be collected, stored,'
        ' used and processed in accordance with the'
        ' Catalyst FC’s Privacy Policy.',
        findRichText: true,
      ),
      findsWidgets,
    );

    expect(
      $(tosCheckbox).text,
      T.get(
        'I confirm that I have read and agree to be bound by Project Catalyst '
        'Terms and Conditions',
      ),
    );
      find.text(
        'I acknowledge that the Catalyst Ops team may use my email only'
        ' for Catalyst communication.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect($(checkbox), findsAtLeast(3));
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
  }
}
