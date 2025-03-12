import '../onboarding_base_page.dart';
import 'step_3_setup_base_profile.dart';

class AcknowledgmentsPanel extends OnboardingPageBase {
  AcknowledgmentsPanel(super.$);
  final acknowledgmentsTile = const Key('AcknowledgementsTitle');
  final tosCheckox = const Key('TosCheckbox');
  final privacyPolicyCheckbox = const Key('PrivacyPolicyCheckbox');

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
        $(acknowledgmentsTile).text, T.get('Mandatory AcknowledgementsTitle'));
    expect(
        $(tosCheckox).text,
        T.get(
            'I confirm that I have read and agree to be bound by Project Catalyst Terms and Conditions'));
  }
}
