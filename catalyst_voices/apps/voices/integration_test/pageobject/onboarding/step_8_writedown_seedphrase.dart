import 'package:flutter/material.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../../utils/test_context.dart';
import 'onboarding_page_interface.dart';
import 'step_7_catalyst_keychain_success.dart';

class WriteDownSeedphrasePanel implements OnboardingPage {
  PatrolTester $;

  WriteDownSeedphrasePanel(this.$);

  static const nextButton = Key('NextButton');
  static const seedPhraseStoredCheckbox = Key('SeedPhraseStoredCheckbox');
  static const seedPhraseWord = Key('SeedPhraseWord');

  Future<void> clickNext() async {
    await $(nextButton).tap();
  }

  Future<void> clickSeedPhraseStoredCheckbox() async {
    await $(seedPhraseStoredCheckbox).tap();
  }

  Future<String> writedownSeedPhraseWord(
    PatrolTester $,
    int index,
  ) async {
    final rawWord =
        $(Key('SeedPhrase${index}CellKey')).$(const Key('SeedPhraseWord')).text;
    return rawWord!;
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
  Future<void> goto() async {
    await CatalystKeychainSuccessPanel($).goto();
    await CatalystKeychainSuccessPanel($).clickNext();
  }

  @override
  void verifyPageElements() {
    // TODO: implement verifyPageElements
  }
}
