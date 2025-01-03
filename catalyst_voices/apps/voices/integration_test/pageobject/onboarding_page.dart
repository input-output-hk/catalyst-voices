import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../types/registration_state.dart';
import '../utils/translations_utils.dart';
import 'common_page.dart';

class OnboardingPage {
  static const registrationDialog = Key('RegistrationDialog');
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
  static const backButton = Key('BackButton');
  static const progressBar = Key('ProgressBar');

  static Future<String?> infoPartHeaderTitleText(PatrolTester $) async {
    return $(registrationInfoPanel).$(headerTitle).text;
  }

  static Future<String?> infoPartHeaderSubtitleText(PatrolTester $) async {
    return $(registrationInfoPanel).$(headerSubtitle).text;
  }

  static Future<String?> infoPartHeaderBodyText(PatrolTester $) async {
    return $(registrationInfoPanel).$(headerBody).text;
  }

  static Future<PatrolFinder> closeBtn(PatrolTester $) async {
    return $(registrationDialog).$(CommonPage.dialogCloseButton);
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

  static String? detailsPartGetStartedTitleBody(PatrolTester $) {
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

  static Future<PatrolFinder> detailsPartCreateKeychainBtn(
    PatrolTester $,
  ) async {
    return $(registrationDetailsPanel).$(const Key('CreateKeychainButton'));
  }

  static Future<void> onboardingScreenLooksAsExpected(
    PatrolTester $,
    RegistrationState step,
  ) async {
    await registrationInfoPanelLooksAsExpected($, step);
    await registrationDetailsPanelLooksAsExpected($, step);
    expect(await closeBtn($), findsOneWidget);
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
      case RegistrationState.createKeychainInfo:
      case RegistrationState.keychainCreated:
        expect(await infoPartHeaderTitleText($), T.get('Catalyst Keychain'));
        expect(await infoPartLearnMoreButtonText($), T.get('Learn More'));
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        break;
      case RegistrationState.keychainCreateMnemonicWritedown:
        expect(await infoPartHeaderTitleText($), T.get('Catalyst Keychain'));
        expect(
          await infoPartHeaderSubtitleText($),
          T.get('Write down your 12 Catalyst  security words'),
        );
        expect(
          await infoPartHeaderBodyText($),
          T.get(
              'Make sure you create an offline backup of your recovery phrase as well.'),
        );
        expect(await infoPartLearnMoreButtonText($), T.get('Learn More'));
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        break;
      case RegistrationState.keychainCreateMnemonicInputInfo:
        throw UnimplementedError();
      case RegistrationState.keychainCreateMnemonicInput:
        throw UnimplementedError();
      case RegistrationState.keychainCreateMnemonicVerified:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreChoice:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreMnemonicInfo:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreMnemonicInput:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreSuccess:
        throw UnimplementedError();
      case RegistrationState.passwordInfo:
        throw UnimplementedError();
      case RegistrationState.passwordInput:
        throw UnimplementedError();
      case RegistrationState.keychainCreateSuccess:
        throw UnimplementedError();
      case RegistrationState.linkWalletInfo:
        throw UnimplementedError();
      case RegistrationState.linkWalletSelect:
        throw UnimplementedError();
      case RegistrationState.linkWalletSuccess:
        throw UnimplementedError();
      case RegistrationState.rolesSelect:
        throw UnimplementedError();
      case RegistrationState.rolesConfirm:
        throw UnimplementedError();
      case RegistrationState.rolesSummary:
        throw UnimplementedError();
      case RegistrationState.keychainTransactionPending:
        throw UnimplementedError();
      case RegistrationState.accountCreationSuccess:
        throw UnimplementedError();
    }
  }

  static Future<void> registrationDetailsPanelLooksAsExpected(
    PatrolTester $,
    RegistrationState step,
  ) async {
    switch (step) {
      case RegistrationState.getStarted:
        expect(detailsPartGetStartedTitle($), T.get('Welcome to Catalyst'));
        expect(detailsPartGetStartedTitleBody($), isNotEmpty);
        expect(
          detailsPartGetStartedQuestionText($),
          T.get('What do you want to do?'),
        );
        expect(await detailsPartGetStartedCreateNewBtn($), findsOneWidget);
        expect(await detailsPartGetStartedRecoverBtn($), findsOneWidget);
        break;
      case RegistrationState.createKeychainInfo:
        expect(
          detailsPartGetStartedTitle($),
          T.get('Create your Catalyst Keychain'),
        );
        expect(detailsPartGetStartedTitleBody($), isNotEmpty);
        expect(await detailsPartCreateKeychainBtn($), findsOneWidget);
        expect($(backButton), findsOneWidget);
        break;
      case RegistrationState.keychainCreated:
        expect(
          detailsPartGetStartedTitle($),
          T.get('Great! Your Catalyst Keychain  has been created.'),
        );
        expect(detailsPartGetStartedTitleBody($), isNotEmpty);
        expect($(backButton), findsOneWidget);
        break;
      case RegistrationState.keychainCreateMnemonicWritedown:
        throw UnimplementedError();
      case RegistrationState.keychainCreateMnemonicInputInfo:
        throw UnimplementedError();
      case RegistrationState.keychainCreateMnemonicInput:
        throw UnimplementedError();
      case RegistrationState.keychainCreateMnemonicVerified:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreChoice:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreMnemonicInfo:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreMnemonicInput:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreSuccess:
        throw UnimplementedError();
      case RegistrationState.passwordInfo:
        throw UnimplementedError();
      case RegistrationState.passwordInput:
        throw UnimplementedError();
      case RegistrationState.keychainCreateSuccess:
        throw UnimplementedError();
      case RegistrationState.linkWalletInfo:
        throw UnimplementedError();
      case RegistrationState.linkWalletSelect:
        throw UnimplementedError();
      case RegistrationState.linkWalletSuccess:
        throw UnimplementedError();
      case RegistrationState.rolesSelect:
        throw UnimplementedError();
      case RegistrationState.rolesConfirm:
        throw UnimplementedError();
      case RegistrationState.rolesSummary:
        throw UnimplementedError();
      case RegistrationState.keychainTransactionPending:
        throw UnimplementedError();
      case RegistrationState.accountCreationSuccess:
        throw UnimplementedError();
    }
  }
}
