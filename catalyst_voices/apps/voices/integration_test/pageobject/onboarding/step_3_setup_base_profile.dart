import 'onboarding_base_page.dart';
import 'step_2_base_profile_info.dart';

class SetupBaseProfilePanel extends OnboardingPageBase {
  SetupBaseProfilePanel(super.$);

  @override
  Future<void> goto() async {
    await BaseProfileInfoPanel($).goto();
    await BaseProfileInfoPanel($).clickCreateBaseProfile();
  }

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  @override
  Future<void> verifyPageElements() async {
    // TODO(emiride): implement verifyPageElements
  }
}
