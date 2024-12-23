library dashboard_page;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'common_page.dart';

class OnboardingPage {
  static const registrationInfoPanel = Key('RegistrationInfoPanel');
  static const registrationInfoLearnMoreButton = Key('LearnMoreButton');
  static const headerTitle = Key('HeaderTitle');
  static const headerSubtitle = Key('HeaderSubtitle');
  static const headerBody = Key('HeaderBody');

  static Future<String?> infoHeaderTitleText(PatrolTester $) async {
    return $(registrationInfoPanel).$(headerTitle).text;
  }

  static Future<String?> infoHeaderSubtitleText(PatrolTester $) async {
    return $(registrationInfoPanel).$(headerSubtitle).text;
  }

  static Future<String?> infoHeaderBodyText(PatrolTester $) async {
    return $(registrationInfoPanel).$(headerBody).text;
  }

  static Future<String?> infoLearnMoreButtonText(PatrolTester $) async {
    final child = find.descendant(
      of: $(registrationInfoPanel).$(CommonPage.decoratorData),
      matching: find.byType(Text),
    );
    return $(child).text;
  }
}
