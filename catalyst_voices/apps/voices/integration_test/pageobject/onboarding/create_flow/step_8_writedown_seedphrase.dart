import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../utils/test_context.dart';
import '../../../utils/translations_utils.dart';
import '../../common_page.dart';
import '../onboarding_base_page.dart';
import 'step_7_catalyst_keychain_success.dart';

class WriteDownSeedphrasePanel extends OnboardingPageBase {
  static const seedPhraseStoredCheckbox = Key('SeedPhraseStoredCheckbox');

  static const seedPhraseWord = Key('SeedPhraseWord');
  static const seedPhraseNumber = Key('SeedPhraseNumber');
  static const downloadSeedPhraseButton = Key('DownloadSeedPhraseButton');
  WriteDownSeedphrasePanel(super.$);

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  Future<void> clickSeedPhraseStoredCheckbox() async {
    await $(seedPhraseStoredCheckbox).tap();
  }

  @override
  Future<void> goto() async {
    await CatalystKeychainSuccessPanel($).goto();
    await CatalystKeychainSuccessPanel($).clickNext();
  }

  Future<void> storeSeedPhraseWords() async {
    for (var i = 0; i < 12; i++) {
      final v1 = $(Key('SeedPhrase${i}CellKey')).$(seedPhraseWord).text;
      if (v1 != null) {
        TestContext.save(key: 'word$i', value: v1);
      }
    }
  }

  Future<void> verifyDetailsPanel() async {
    await writedownSeedPhrasesAreDisplayed();
    expect($(downloadSeedPhraseButton), findsOneWidget);
    expect(
      $(downloadSeedPhraseButton).$(CommonPage($).decorData).$(Text).text,
      (await t()).createKeychainSeedPhraseExport,
    );
    expect($(seedPhraseStoredCheckbox), findsOneWidget);
    expect(
      $(seedPhraseStoredCheckbox).$(Text).text,
      (await t()).createKeychainSeedPhraseStoreConfirmation,
    );
    expect($(backButton), findsOneWidget);
    expect($(nextButton), findsOneWidget);
  }

  Future<void> verifyInfoPanel() async {
    expect(await infoPartHeaderTitleText(), (await t()).catalystKeychain);
    expect(
      await infoPartHeaderSubtitleText(),
      (await t()).createKeychainSeedPhraseSubtitle,
    );
    expect(
      await infoPartHeaderBodyText(),
      (await t()).createKeychainSeedPhraseBody,
    );
    expect(infoPartTaskPicture(), findsOneWidget);
    expect($(progressBar), findsOneWidget);
    expect($(learnMoreButton).$(Text).text, (await t()).learnMore);
  }

  @override
  Future<void> verifyPageElements() async {
    await verifyInfoPanel();
    await verifyDetailsPanel();
  }

  Future<int> writedownSeedPhraseNumber(int index) async {
    final rawNumber = $(Key('SeedPhrase${index}CellKey')).$(seedPhraseNumber).text;
    return int.parse(rawNumber!.split('.').first);
  }

  Future<void> writedownSeedPhrasesAreDisplayed() async {
    for (var i = 0; i < 12; i++) {
      expect(await writedownSeedPhraseNumber(i), i + 1);
      expect(await writedownSeedPhraseWord(i), isNotEmpty);
    }
  }

  Future<String> writedownSeedPhraseWord(int index) async {
    final rawWord = $(Key('SeedPhrase${index}CellKey')).$(const Key('SeedPhraseWord')).text;
    return rawWord!;
  }
}
