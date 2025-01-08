import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../types/registration_state.dart';
import '../utils/selector_utils.dart';
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
  static const nextButton = Key('NextButton');
  static const progressBar = Key('ProgressBar');
  static const downloadSeedPhraseButton = Key('DownloadSeedPhraseButton');
  static const seedPhraseStoredCheckbox = Key('SeedPhraseStoredCheckbox');
  static const uploadKeyButton = Key('UploadKeyButton');
  static const resetButton = Key('ResetButton');

  static Future<int> writedownSeedPhraseNumber(
    PatrolTester $,
    int index,
  ) async {
    final rawNumber = $(Key('SeedPhrase${index}CellKey'))
        .$(const Key('SeedPhraseNumber'))
        .text;
    return int.parse(rawNumber!.split('.').first);
  }

  static Future<int> writedownSeedPhraseWord(
    PatrolTester $,
    int index,
  ) async {
    final rawNumber =
        $(Key('SeedPhrase${index}CellKey')).$(const Key('SeedPhraseWord')).text;
    return int.parse(rawNumber!.split('.').first);
  }

  static Future<String> inputSeedPhraseCompleterWord(
    PatrolTester $,
    int index,
  ) async {
    final seedWord = await getChildNodeText(
      $,
      $(Key('CompleterSeedPhrase${index}CellKey')).$(CommonPage.decoratorData),
    );
    return seedWord!;
  }

  static Future<String?> inputSeedPhrasePickerWord(
      PatrolTester $, int index,) async {
    final seedWord = await getChildNodeText(
      $,
      $(Key('PickerSeedPhrase${index + 1}CellKey')),
    );
    return seedWord!;
  }

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
    return $(registrationDialog)
        .$(CommonPage.dialogCloseButton)
        .waitUntilVisible();
  }

  static Future<String?> getChildNodeText(
    PatrolTester $,
    FinderBase<Element> parent,
  ) async {
    final child = find.descendant(
      of: parent,
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

  static void voicesFilledButtonIsEnabled(
    PatrolTester $,
    Key button,
  ) {
    final child = find.descendant(
      of: $(button),
      matching: find.byType(FilledButton),
    );
    SelectorUtils.isEnabled($, $(child));
  }

  static void voicesFilledButtonIsDisabled(
    PatrolTester $,
    Key button,
  ) {
    final child = find.descendant(
      of: $(button),
      matching: find.byType(FilledButton),
    );
    SelectorUtils.isDisabled($, $(child));
  }

  static String? detailsPartGetStartedQuestionText(PatrolTester $) {
    return $(registrationDetailsPanel).$(const Key('GetStartedQuestion')).text;
  }

  static Future<PatrolFinder> detailsPartGetStartedCreateNewBtn(
    PatrolTester $,
  ) async {
    return $(registrationDetailsPanel)
        .$(const Key('CreateAccountType.createNew'))
        .waitUntilVisible();
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
    return $(registrationDetailsPanel)
        .$(const Key('CreateKeychainButton'))
        .waitUntilVisible();
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
        expect(infoPartTaskPicture($), findsOneWidget);
        expect(
          await getChildNodeText(
            $,
            $(registrationInfoPanel).$(CommonPage.decoratorData),
          ),
          T.get('Learn More'),
        );
        break;
      case RegistrationState.createKeychainInfo:
      case RegistrationState.keychainCreated:
        expect(await infoPartHeaderTitleText($), T.get('Catalyst Keychain'));
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        expect(
          await getChildNodeText(
            $,
            $(registrationInfoPanel).$(CommonPage.decoratorData),
          ),
          T.get('Learn More'),
        );
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
            'Make sure you create an offline backup of your recovery phrase '
            'as well.',
          ),
        );
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        expect(
          await getChildNodeText(
            $,
            $(registrationInfoPanel).$(CommonPage.decoratorData),
          ),
          T.get('Learn More'),
        );
        break;
      case RegistrationState.keychainCreateMnemonicInputInfo:
        expect(await infoPartHeaderTitleText($), T.get('Catalyst Keychain'));
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        expect(
          await getChildNodeText(
            $,
            $(registrationInfoPanel).$(CommonPage.decoratorData),
          ),
          T.get('Learn More'),
        );
      case RegistrationState.keychainCreateMnemonicInput:
        expect(await infoPartHeaderTitleText($), T.get('Catalyst Keychain'));
        expect(
          await infoPartHeaderSubtitleText($),
          T.get('Input your Catalyst security keys'),
        );
        expect(
          await infoPartHeaderBodyText($),
          T.get(
            'Select your 12 written down words in  the correct order.',
          ),
        );
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        expect(
          await getChildNodeText(
            $,
            $(registrationInfoPanel).$(CommonPage.decoratorData),
          ),
          T.get('Learn More'),
        );
        break;
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
        expect(
          await getChildNodeText(
            $,
            $(registrationDetailsPanel).$(registrationDetailsTitle),
          ),
          T.get('Welcome to Catalyst'),
        );
        expect(
          await getChildNodeText(
            $,
            $(registrationDetailsPanel).$(registrationDetailsBody),
          ),
          isNotEmpty,
        );
        expect(
          detailsPartGetStartedQuestionText($),
          T.get('What do you want to do?'),
        );
        expect(await detailsPartGetStartedCreateNewBtn($), findsOneWidget);
        expect(await detailsPartGetStartedRecoverBtn($), findsOneWidget);
        break;
      case RegistrationState.createKeychainInfo:
        expect(
          await getChildNodeText(
            $,
            $(registrationDetailsPanel).$(registrationDetailsTitle),
          ),
          T.get('Create your Catalyst Keychain'),
        );
        expect(
          await getChildNodeText(
            $,
            $(registrationDetailsPanel).$(registrationDetailsBody),
          ),
          isNotEmpty,
        );
        expect(await detailsPartCreateKeychainBtn($), findsOneWidget);
        expect($(backButton), findsOneWidget);
        break;
      case RegistrationState.keychainCreated:
        expect(
          await getChildNodeText(
            $,
            $(registrationDetailsPanel).$(registrationDetailsTitle),
          ),
          T.get('Great! Your Catalyst Keychain  has been created.'),
        );
        expect(
          await getChildNodeText(
            $,
            $(registrationDetailsPanel).$(registrationDetailsBody),
          ),
          isNotEmpty,
        );
        expect($(backButton), findsOneWidget);
        expect($(nextButton), findsOneWidget);
        break;
      case RegistrationState.keychainCreateMnemonicWritedown:
        await writedownSeedPhrasesAreDisplayed($);
        expect($(downloadSeedPhraseButton), findsOneWidget);
        expect(
          await getChildNodeText(
            $,
            $(downloadSeedPhraseButton).$(CommonPage.decoratorData),
          ),
          T.get('Download Catalyst key'),
        );
        expect($(seedPhraseStoredCheckbox), findsOneWidget);
        expect(
          await getChildNodeText($, $(seedPhraseStoredCheckbox)),
          T.get('I have written down/downloaded my 12 words'),
        );
        expect($(backButton), findsOneWidget);
        expect($(nextButton), findsOneWidget);
        break;
      case RegistrationState.keychainCreateMnemonicInputInfo:
        expect(
          await getChildNodeText(
            $,
            $(registrationDetailsPanel).$(registrationDetailsTitle),
          ),
          T.get('Check your Catalyst security keys'),
        );
        expect(
          await getChildNodeText(
            $,
            $(registrationDetailsPanel).$(registrationDetailsBody),
          ),
          isNotEmpty,
        );
        break;
      case RegistrationState.keychainCreateMnemonicInput:
        await inputSeedPhrasesAreDisplayed($);
        expect($(uploadKeyButton), findsOneWidget);
        expect(
          await getChildNodeText(
            $,
            $(uploadKeyButton).$(CommonPage.decoratorData),
          ),
          T.get('Upload Catalyst Key'),
        );
        expect($(backButton), findsOneWidget);
        expect($(nextButton), findsOneWidget);
        break;
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

  static Future<void> writedownSeedPhrasesAreDisplayed(PatrolTester $) async {
    for (var i = 0; i < 12; i++) {
      expect(await writedownSeedPhraseNumber($, i), i + 1);
      expect(await writedownSeedPhraseWord($, i), isNotEmpty);
    }
  }

  static Future<void> inputSeedPhrasesAreDisplayed(PatrolTester $) async {
    for (var i = 0; i < 12; i++) {
      expect(await inputSeedPhrasePickerWord($, i), isNotEmpty);
      expect(await inputSeedPhraseCompleterWord($, i), isNotEmpty);
    }
  }
}
