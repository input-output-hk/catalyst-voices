import 'package:patrol_finders/patrol_finders.dart';

import '../pageobject/app_bar_page.dart';
import '../pageobject/onboarding_page.dart';
import '../utils/constants.dart';

Future<void> goToCreateCata(PatrolTester $) async {
  await $(AppBarPage.getStartedBtn).tap(settleTimeout: Time.short.duration);
  await OnboardingPage.detailsPartGetStartedCreateNewBtn($).tap();
  await $(OnboardingPage.createBaseProfileNext).tap();
  await $(OnboardingPage.nextButton).tap();
  await $(OnboardingPage.nextButton).tap();
  await OnboardingPage.detailsPartCreateKeychainBtn($).tap();
}
