library dashboard_page;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../types/registration_state.dart';
import '../utils/translations_utils.dart';
import 'common_page.dart';

class OnboardingPage {
  static const registrationInfoPanel = Key('RegistrationInfoPanel');
  static const registrationDetailsPanel = Key('RegistrationDetailsPanel');
  static const registrationInfoLearnMoreButton = Key('LearnMoreButton');
  static const headerTitle = Key('HeaderTitle');
  static const headerSubtitle = Key('HeaderSubtitle');
  static const headerBody = Key('HeaderBody');
  static const registrationInfoPictureContainer = Key('PictureContainer');
  static const registrationInfoTaskPicture = Key('TaskPictureIconBox');
  static const registrationDetailsTitle = Key('RegistrationDetailsTitle');
  static const registrationDetailsBody = Key('RegistrationDetailsBody');

  static Future<String?> infoPartHeaderTitleText(PatrolTester $) async {
    return $(registrationInfoPanel).$(headerTitle).text;
  }

  static Future<String?> infoPartHeaderSubtitleText(PatrolTester $) async {
    return $(registrationInfoPanel).$(headerSubtitle).text;
  }

  static Future<String?> infoPartHeaderBodyText(PatrolTester $) async {
    return $(registrationInfoPanel).$(headerBody).text;
  }

  static Future<String?> infoPartLearnMoreButtonText(PatrolTester $) async {
    final child = find.descendant(
      of: $(registrationInfoPanel).$(CommonPage.decoratorData),
      matching: find.byType(Text),
    );
    return $(child).text;
  }

  static Finder infoPartTaskPicture(PatrolTester $) {
    final child = find.descendant(
      of: $(registrationInfoPanel).$(registrationInfoPictureContainer),
      matching: find.byType(IconTheme),
    );
    return child;
  }

  static String? detailsPartGetStartedTitle(PatrolTester $) {
    final child = find.descendant(
      of: $(registrationDetailsPanel).$(registrationDetailsTitle),
      matching: find.byType(Text),
    );
    return $(child).text;
  }

  static String? detailsPartGetStartedBody(PatrolTester $) {
    final child = find.descendant(
      of: $(registrationDetailsPanel).$(registrationDetailsBody),
      matching: find.byType(Text),
    );
    return $(child).text;
  }

  static String? detailsPartGetStartedQuestionText(PatrolTester $) {
    return $(registrationDetailsPanel).$(const Key('GetStartedQuestion')).text;
  }

  static Future<PatrolFinder> detailsPartGetStartedCreateNewBtn(
    PatrolTester $,
  ) async {
    return $(registrationDetailsPanel)
        .$(const Key('CreateAccountType.createNew'));
  }

  static Future<PatrolFinder> detailsPartGetStartedRecoverBtn(
      PatrolTester $,
      ) async {
    return $(registrationDetailsPanel)
        .$(const Key('CreateAccountType.recover'));
  }

  static Future<void> getStartedScreenLooksAsExpected(PatrolTester $) async {
    await registrationInfoPanelLooksAsExpected($, RegistrationState.getStarted);
    await registrationDetailsPanelLooksAsExpected(
      $,
      RegistrationState.getStarted,
    );
  }

  static Future<void> registrationInfoPanelLooksAsExpected(
    PatrolTester $,
    RegistrationState step,
  ) async {
    switch (step) {
      case RegistrationState.getStarted:
        expect(await infoPartHeaderTitleText($), T.get('Get Started'));
        expect(await infoPartLearnMoreButtonText($), T.get('Learn More'));
        expect(infoPartTaskPicture($), findsOneWidget);
        break;
      case RegistrationState.checkYourKeychain:
        // TODO: Handle this case.
        throw UnimplementedError();
      case RegistrationState.createKeychain:
        // TODO: Handle this case.
        throw UnimplementedError();
      case RegistrationState.keychainCreated:
        // TODO: Handle this case.
        throw UnimplementedError();
      case RegistrationState.keychainRestoreInfo:
        // TODO: Handle this case.
        throw UnimplementedError();
      case RegistrationState.keychainRestoreInput:
        // TODO: Handle this case.
        throw UnimplementedError();
      case RegistrationState.keychainRestoreStart:
        // TODO: Handle this case.
        throw UnimplementedError();
      case RegistrationState.keychainRestoreSuccess:
        // TODO: Handle this case.
        throw UnimplementedError();
      case RegistrationState.mnemonicInput:
        // TODO: Handle this case.
        throw UnimplementedError();
      case RegistrationState.mnemonicVerified:
        // TODO: Handle this case.
        throw UnimplementedError();
      case RegistrationState.mnemonicWritedown:
        // TODO: Handle this case.
        throw UnimplementedError();
      case RegistrationState.passwordInfo:
        // TODO: Handle this case.
        throw UnimplementedError();
      case RegistrationState.passwordInput:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  static Future<void> registrationDetailsPanelLooksAsExpected(
      PatrolTester $, RegistrationState getStarted,) async {
    expect(
      detailsPartGetStartedTitle($),
      T.get('Welcome to Catalyst'),
    );
    expect(
      detailsPartGetStartedBody($), isNotEmpty,
    );
    expect(
      detailsPartGetStartedQuestionText($),
      T.get('What do you want to do?'),
    );
    expect(
      await detailsPartGetStartedCreateNewBtn($),
      findsOneWidget,
    );
    expect(
      await detailsPartGetStartedRecoverBtn($),
      findsOneWidget,
    );
    expect(
      $(CommonPage.dialogCloseButton),
      findsOneWidget,
    );
  }
}
