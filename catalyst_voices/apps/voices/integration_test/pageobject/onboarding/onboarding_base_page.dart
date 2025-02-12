import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/selector_utils.dart';
import '../common_page.dart';

class OnboardingPageBase {
  PatrolTester $;
  OnboardingPageBase(this.$);
  final registrationDialog = const Key('RegistrationDialog');
  final registrationInfoPanel = const Key('RegistrationInfoPanel');
  final registrationDetailsPanel = const Key('RegistrationDetailsPanel');
  final headerTitle = const Key('HeaderTitle');
  final headerSubtitle = const Key('HeaderSubtitle');
  final headerBody = const Key('HeaderBody');
  final backButton = const Key('BackButton');
  final nextButton = const Key('NextButton');
  final registrationInfoPictureContainer = const Key('PictureContainer');
  final progressBar = const Key('ProgressBar');
  final registrationDetailsTitle = const Key('RegistrationDetailsTitle');
  final registrationDetailsBody = const Key('RegistrationDetailsBody');

  Future<String?> infoPartHeaderTitleText() async {
    return $(registrationInfoPanel).$(headerTitle).text;
  }

  Future<String?> infoPartHeaderSubtitleText() async {
    return $(registrationInfoPanel).$(headerSubtitle).text;
  }

  Future<String?> infoPartHeaderBodyText() async {
    return $(registrationInfoPanel).$(headerBody).text;
  }

  Future<PatrolFinder> closeButton() async {
    return $(registrationDialog)
        .$(CommonPage.dialogCloseButton)
        .waitUntilVisible();
  }

  Future<void> verifyNextButtonIsEnabled() async {
    return SelectorUtils.isEnabled($, $(nextButton).$(FilledButton));
  }

  Future<void> verifyNextButtonIsDisabled() async {
    return SelectorUtils.isDisabled($, $(nextButton).$(FilledButton));
  }

  PatrolFinder infoPartTaskPicture() {
    return $(registrationInfoPanel)
        .$(registrationInfoPictureContainer)
        .$(IconTheme);
  }

  Future<void> clickBack() async {
    await $(backButton).waitUntilVisible().tap();
  }

  Future<void> goto() async {
    throw UnimplementedError('goto() must be overridden in subclasses');
  }

  Future<void> verifyPageElements() async {
    throw UnimplementedError(
      'verifyPageElements() must be overridden in subclasses',
    );
  }
}
