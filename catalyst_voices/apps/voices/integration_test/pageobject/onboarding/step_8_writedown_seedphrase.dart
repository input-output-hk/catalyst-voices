import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/test_context.dart';
import '../../utils/translations_utils.dart';
import '../common_page.dart';
import 'onboarding_base_page.dart';
import 'step_7_catalyst_keychain_success.dart';

class WriteDownSeedphrasePanel extends OnboardingPageBase {
  WriteDownSeedphrasePanel(super.$);

  static const seedPhraseStoredCheckbox = Key('SeedPhraseStoredCheckbox');
  static const seedPhraseWord = Key('SeedPhraseWord');
  static const seedPhraseNumber = Key('SeedPhraseNumber');
  static const downloadSeedPhraseButton = Key('DownloadSeedPhraseButton');

  @override
  Future<void> goto() async {
    await CatalystKeychainSuccessPanel($).goto();
    await CatalystKeychainSuccessPanel($).clickNext();
  }

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  Future<void> clickSeedPhraseStoredCheckbox() async {
    await $(seedPhraseStoredCheckbox).tap();
  }

  Future<String> writedownSeedPhraseWord(int index) async {
    final rawWord =
        $(Key('SeedPhrase${index}CellKey')).$(const Key('SeedPhraseWord')).text;
    return rawWord!;
  }

  Future<int> writedownSeedPhraseNumber(int index) async {
    final rawNumber =
        $(Key('SeedPhrase${index}CellKey')).$(seedPhraseNumber).text;
    return int.parse(rawNumber!.split('.').first);
  }

  Future<void> storeSeedPhraseWords() async {
    for (var i = 0; i < 12; i++) {
      final v1 = $(Key('SeedPhrase${i}CellKey')).$(seedPhraseWord).text;
      if (v1 != null) {
        TestContext.save(key: 'word$i', value: v1);
      }
    }
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), T.get('Catalyst Keychain'));
    expect(
      await infoPartHeaderSubtitleText(),
      T.get('Write down your Catalyst seed phrase'),
    );
    expect(
      await infoPartHeaderBodyText(),
      T.get(
        'Make sure you write down your 12-words in a safe place as well.',
      ),
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect(
      $(registrationInfoPanel).$(CommonPage.decorData).$(Text).text,
      T.get('Learn More'),
    );
  }

  Future<void> verifyDetailsPanel() async {
    await writedownSeedPhrasesAreDisplayed();
    expect($(downloadSeedPhraseButton), findsOneWidget);
    expect(
      $(downloadSeedPhraseButton).$(CommonPage.decorData).$(Text).text,
      T.get('Export Security Words'),
    );
    expect($(seedPhraseStoredCheckbox), findsOneWidget);
    expect(
      $(seedPhraseStoredCheckbox).$(Text).text,
      T.get('I have written down/downloaded my 12 words'),
    );
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
  }

  Future<void> writedownSeedPhrasesAreDisplayed() async {
    for (var i = 0; i < 12; i++) {
      expect(await writedownSeedPhraseNumber(i), i + 1);
      expect(await writedownSeedPhraseWord(i), isNotEmpty);
    }
  }
}
