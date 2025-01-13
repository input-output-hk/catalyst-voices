import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../types/password_validation_states.dart';
import '../types/registration_state.dart';
import '../utils/selector_utils.dart';
import '../utils/test_context.dart';
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
  static const seedPhrasesPicker = Key('SeedPhrasesPicker');
  static const nextStepTitle = Key('NextStepTitle');
  static const nextStepBody = Key('NextStepBody');
  static const passwordInputField = Key('PasswordInputField');
  static const passwordConfirmInputField = Key('PasswordConfirmInputField');
  static const passwordStrengthIndicator = Key('PasswordStrengthIndicator');
  static const passwordStrengthLabel = Key('PasswordStrengthLabel');
  static const finishAccountCreationPanel = Key('FinishAccountCreationPanel');
  static const finishAccountKeychainCreated =
      Key('StepRegistrationProgressStepGroup.createKeychainRowKey');
  static const finishAccountLinkWallet =
      Key('StepRegistrationProgressStepGroup.linkWalletRowKey');
  static const finishAccountAccountComplete =
      Key('StepRegistrationProgressStepGroup.accountCompletedRowKey');
  static const linkWalletAndRolesButton = Key('LinkWalletAndRolesButton');
  static const chooseCardanoWalletButton = Key('ChooseCardanoWalletButton');
  static const seeAllSupportedWalletsBtn = Key('SeeAllSupportedWalletsButton');
  static const walletsLinkBuilder = Key('WalletsLinkBuilder');

  static Future<int> writedownSeedPhraseNumber(
    PatrolTester $,
    int index,
  ) async {
    final rawNumber = $(Key('SeedPhrase${index}CellKey'))
        .$(const Key('SeedPhraseNumber'))
        .text;
    return int.parse(rawNumber!.split('.').first);
  }

  static Future<String> writedownSeedPhraseWord(
    PatrolTester $,
    int index,
  ) async {
    final rawWord =
        $(Key('SeedPhrase${index}CellKey')).$(const Key('SeedPhraseWord')).text;
    return rawWord!;
  }

  static Future<String> inputSeedPhraseCompleterText(
    PatrolTester $,
    int index,
  ) async {
    final seedWord = $(Key('CompleterSeedPhrase${index}CellKey'))
        .$(CommonPage.decorData)
        .$(Text)
        .text;
    return seedWord!;
  }

  static Future<String?> inputSeedPhrasePickerText(
    PatrolTester $,
    int index,
  ) async {
    final seedWord = $(Key('PickerSeedPhrase${index + 1}CellKey')).$(Text).text;
    return seedWord!;
  }

  static Future<PatrolFinder> inputSeedPhrasePicker(
    PatrolTester $,
    String word,
  ) async {
    return $(seedPhrasesPicker).$(find.text(word));
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

  static Finder infoPartTaskPicture(PatrolTester $) {
    return $(registrationInfoPanel)
        .$(registrationInfoPictureContainer)
        .$(IconTheme);
  }

  static void voicesButtonIsEnabled(
    PatrolTester $,
    Key button,
  ) {
    final child = $(button).$(FilledButton);
    SelectorUtils.isEnabled($, $(child));
  }

  static void voicesButtonIsDisabled(
    PatrolTester $,
    Key button,
  ) {
    final child = $(button).$(FilledButton);
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
          $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
          T.get('Learn More'),
        );
        break;
      case RegistrationState.createKeychainInfo:
      case RegistrationState.keychainCreated:
        expect(await infoPartHeaderTitleText($), T.get('Catalyst Keychain'));
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        expect(
          $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
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
          $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
          T.get('Learn More'),
        );
        break;
      case RegistrationState.keychainCreateMnemonicInputInfo:
        expect(await infoPartHeaderTitleText($), T.get('Catalyst Keychain'));
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        expect(
          $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
          T.get('Learn More'),
        );
        break;
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
          $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
          T.get('Learn More'),
        );
        break;
      case RegistrationState.keychainCreateMnemonicVerified:
        expect(await infoPartHeaderTitleText($), T.get('Catalyst Keychain'));
        //temporary: check for specific picture (green checked icon)
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        expect(
          $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
          T.get('Learn More'),
        );
        break;
      case RegistrationState.passwordInfo:
        expect(await infoPartHeaderTitleText($), T.get('Catalyst Keychain'));
        //temporary: check for specific picture (locked icon)
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        expect(
          $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
          T.get('Learn More'),
        );
        break;
      case RegistrationState.passwordInput:
        expect(await infoPartHeaderTitleText($), T.get('Catalyst Keychain'));
        expect(
          await infoPartHeaderSubtitleText($),
          T.get('Catalyst unlock password'),
        );
        expect(
          await infoPartHeaderBodyText($),
          T.get(
            'Please provide a password for your Catalyst Keychain.',
          ),
        );
        //temporary: check for specific picture (locked icon)
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        expect(
          $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
          T.get('Learn More'),
        );
        break;
      case RegistrationState.keychainCreateSuccess:
        expect(await infoPartHeaderTitleText($), T.get('Catalyst Keychain'));
        //temporary: check for specific picture (green key locked icon)
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        expect(
          $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
          T.get('Learn More'),
        );
        break;
      case RegistrationState.keychainRestoreChoice:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreMnemonicInfo:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreMnemonicInput:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreSuccess:
        throw UnimplementedError();
      case RegistrationState.linkWalletInfo:
      case RegistrationState.linkWalletSelect:
        expect(
          await infoPartHeaderTitleText($),
          T.get('Link keys to your Catalyst Keychain'),
        );
        expect(
          await infoPartHeaderSubtitleText($),
          T.get('Link your Cardano wallet'),
        );
        //temporary: check for specific picture (blue key icon)
        expect(infoPartTaskPicture($), findsOneWidget);
        expect($(progressBar), findsOneWidget);
        expect(
          $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
          T.get('Learn More'),
        );
        break;
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
          $(registrationDetailsPanel).$(registrationDetailsTitle).$(Text).text,
          T.get('Welcome to Catalyst'),
        );
        expect(
          $(registrationDetailsPanel).$(registrationDetailsBody).$(Text).text,
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
          $(registrationDetailsPanel).$(registrationDetailsTitle).$(Text).text,
          T.get('Create your Catalyst Keychain'),
        );
        expect(
          $(registrationDetailsPanel).$(registrationDetailsBody).$(Text).text,
          isNotEmpty,
        );
        expect(await detailsPartCreateKeychainBtn($), findsOneWidget);
        expect($(backButton), findsOneWidget);
        break;
      case RegistrationState.keychainCreated:
        expect(
          $(registrationDetailsPanel).$(registrationDetailsTitle).$(Text).text,
          T.get('Great! Your Catalyst Keychain  has been created.'),
        );
        expect(
          $(registrationDetailsPanel).$(registrationDetailsBody).$(Text).text,
          isNotEmpty,
        );
        expect($(backButton), findsOneWidget);
        expect($(nextButton), findsOneWidget);
        break;
      case RegistrationState.keychainCreateMnemonicWritedown:
        await writedownSeedPhrasesAreDisplayed($);
        expect($(downloadSeedPhraseButton), findsOneWidget);
        expect(
          $(downloadSeedPhraseButton).$(CommonPage.decorData).$(Text).text,
          T.get('Download Catalyst key'),
        );
        expect($(seedPhraseStoredCheckbox), findsOneWidget);
        expect(
          $(seedPhraseStoredCheckbox).$(Text).text,
          T.get('I have written down/downloaded my 12 words'),
        );
        expect($(backButton), findsOneWidget);
        expect($(nextButton), findsOneWidget);
        break;
      case RegistrationState.keychainCreateMnemonicInputInfo:
        expect(
          $(registrationDetailsPanel).$(registrationDetailsTitle).$(Text).text,
          T.get('Check your Catalyst security keys'),
        );
        expect(
          $(registrationDetailsPanel).$(registrationDetailsBody).$(Text).text,
          isNotEmpty,
        );
        break;
      case RegistrationState.keychainCreateMnemonicInput:
        await inputSeedPhrasesAreDisplayed($);
        expect($(uploadKeyButton), findsOneWidget);
        expect(
          $(uploadKeyButton).$(CommonPage.decorData).$(Text).text,
          T.get('Upload Catalyst Key'),
        );
        expect($(backButton), findsOneWidget);
        expect($(nextButton), findsOneWidget);
        break;
      case RegistrationState.keychainCreateMnemonicVerified:
        await $(registrationDetailsPanel)
            .$(registrationDetailsTitle)
            .waitUntilVisible();
        expect(
          $(registrationDetailsPanel).$(registrationDetailsTitle).$(Text).text,
          T.get("Nice job! You've successfully verified the seed phrase for "
              'your keychain.'),
        );
        expect(
          $(registrationDetailsPanel).$(registrationDetailsBody).$(Text).text,
          isNotEmpty,
        );
        expect(
          $(nextStepTitle).$(Text).text,
          T.get('Your next step'),
        );
        expect(
          $(nextStepBody).text,
          T.get('Now let’s set your Unlock password '
              'for this device!'),
        );
        expect($(backButton), findsOneWidget);
        expect($(nextButton), findsOneWidget);
        break;
      case RegistrationState.passwordInfo:
        expect(
          $(registrationDetailsPanel).$(registrationDetailsTitle).$(Text).text,
          T.get('Set your Catalyst unlock password  for this device'),
        );
        expect(
          $(registrationDetailsPanel).$(registrationDetailsBody).$(Text).text,
          isNotEmpty,
        );
        expect($(backButton), findsOneWidget);
        expect($(nextButton), findsOneWidget);
        break;
      case RegistrationState.passwordInput:
        expect(
          $(registrationDetailsPanel).$(passwordInputField).$(Text).text,
          T.get('Enter password'),
        );
        expect(
          $(registrationDetailsPanel).$(passwordConfirmInputField).$(Text).text,
          T.get('Confirm password'),
        );
        expect($(passwordStrengthLabel), findsNothing);
        expect($(passwordStrengthIndicator), findsNothing);
        expect($(backButton), findsOneWidget);
        expect($(nextButton), findsOneWidget);
        OnboardingPage.voicesButtonIsDisabled($, OnboardingPage.nextButton);
        break;
      case RegistrationState.keychainCreateSuccess:
        expect(
          $(finishAccountCreationPanel).$(Text).text,
          T.get('Congratulations your Catalyst  Keychain is created!'),
        );
        expect(
          $(finishAccountKeychainCreated).$(Text).text,
          T.get('Catalyst Keychain created'),
        );
        expect(
          $(finishAccountLinkWallet).$(Text).text,
          T.get('Link Cardano Wallet & Roles'),
        );
        expect(
          $(finishAccountAccountComplete).$(Text).text,
          T.get('Catalyst account creation completed!'),
        );
        expect(
          $(nextStepTitle).$(Text).text,
          T.get('Your next step'),
        );
        expect(
          $(nextStepBody).text,
          T.get('In the next step you write your Catalyst roles and  account '
              'to the Cardano Mainnet.'),
        );
        expect(
          $(linkWalletAndRolesButton).$(Text).text,
          T.get('Link your Cardano Wallet & Roles'),
        );
        break;
      case RegistrationState.keychainRestoreChoice:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreMnemonicInfo:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreMnemonicInput:
        throw UnimplementedError();
      case RegistrationState.keychainRestoreSuccess:
        throw UnimplementedError();
      case RegistrationState.linkWalletInfo:
        expect(
          $(registrationDetailsPanel).$(registrationDetailsTitle).$(Text).text,
          T.get('Link Cardano Wallet & Catalyst Roles to you Catalyst '
              'Keychain.'),
        );
        expect(
          $(registrationDetailsPanel).$(registrationDetailsBody).$(Text).text,
          isNotEmpty,
        );
        expect(
          $(chooseCardanoWalletButton).$(Text).text,
          T.get('Choose Cardano Wallet'),
        );
        break;
      case RegistrationState.linkWalletSelect:
        expect(
          $(registrationDetailsPanel).$(registrationDetailsTitle).$(Text).text,
          T.get(
              'Select the Cardano wallet to link\nto your Catalyst Keychain.'),
        );
        expect(
          $(registrationDetailsPanel).$(registrationDetailsBody).$(Text).text,
          isNotEmpty,
        );
        expect($(walletsLinkBuilder), findsOneWidget);
        expect($(backButton), findsOneWidget);
        expect($(seeAllSupportedWalletsBtn), findsOneWidget);
        break;
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
      expect(await inputSeedPhrasePickerText($, i), isNotEmpty);
      expect(await inputSeedPhraseCompleterText($, i), isNotEmpty);
    }
  }

  static Future<void> storeSeedPhrases(PatrolTester $) async {
    for (var i = 0; i < 12; i++) {
      final v1 = await writedownSeedPhraseWord($, i);
      TestContext.save(key: 'word$i', value: v1);
    }
  }

  static Future<void> enterStoredSeedPhrases(PatrolTester $) async {
    for (var i = 0; i < 12; i++) {
      await inputSeedPhrasePicker($, TestContext.get(key: 'word$i')).tap();
    }
  }

  static Future<void> enterPassword(PatrolTester $, String password) async {
    await $(passwordInputField).enterText(password);
  }

  static Future<void> enterPasswordConfirm(
    PatrolTester $,
    String password,
  ) async {
    await $(passwordConfirmInputField).enterText(password);
  }

  static void checkValidationIndicator(
    PatrolTester $,
    PasswordValidationStatus validationStatus,
  ) {
    expect($(passwordStrengthLabel), findsOneWidget);

    switch (validationStatus) {
      case PasswordValidationStatus.weak:
        expect(
          $(passwordStrengthLabel).text,
          T.get('Weak password strength'),
        );
        break;
      case PasswordValidationStatus.normal:
        expect(
          $(passwordStrengthLabel).text,
          T.get('Normal password strength'),
        );
        break;
      case PasswordValidationStatus.good:
        expect(
          $(passwordStrengthLabel).text,
          T.get('Good password strength'),
        );
        break;
    }
  }

  static void passwordConfirmErrorIconIsShown(
    PatrolTester $, {
    bool reverse = false,
  }) {
    if (reverse) {
      expect(
        $(registrationDetailsPanel).$(CommonPage.voicesTextField).$(Icon),
        findsNothing,
      );
    } else {
      expect(
        $(registrationDetailsPanel).$(CommonPage.voicesTextField).$(Icon),
        findsOneWidget,
      );
    }
  }
}
