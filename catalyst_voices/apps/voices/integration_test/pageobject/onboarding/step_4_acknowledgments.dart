import 'onboarding_base_page.dart';
import 'step_3_setup_base_profile.dart';

class AcknowledgmentsPanel extends OnboardingPageBase {
  AcknowledgmentsPanel(super.$);

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
    // TODO(emiride): implement verifyPageElements
  }
}
