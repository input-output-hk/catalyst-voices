import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_sequencer.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SeedPhrasesSequencer', () {
    const words = [
      SeedPhraseWord('real', nr: 1),
      SeedPhraseWord('mission', nr: 2),
      SeedPhraseWord('secure', nr: 3),
      SeedPhraseWord('renew', nr: 4),
      SeedPhraseWord('key', nr: 5),
      SeedPhraseWord('audit', nr: 6),
    ];

    testWidgets(
      'clicking word in picker triggers on change callback',
      (tester) async {
        // Given
        final selectedWords = <SeedPhraseWord>{};
        final word = words[0];
        final expectedWords = {word};

        final sequencer = SeedPhrasesSequencer(
          words: words,
          onChanged: (value) {
            selectedWords
              ..clear()
              ..addAll(value);
          },
        );
        final wordPickerKey = ValueKey('PickerSeedPhrase${word.nr}CellKey');

        // When
        await tester.pumpApp(sequencer);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(wordPickerKey));

        // Then
        expect(selectedWords, expectedWords);
      },
    );

    testWidgets(
      'clicking last word in completer removes word from list',
      (tester) async {
        // Given
        final selectedWords = <SeedPhraseWord>[
          words[0],
          words[1],
        ];
        final expectedWords = {words[0]};

        final sequencer = SeedPhrasesSequencer(
          words: words,
          selectedWords: selectedWords,
          onChanged: (value) {
            selectedWords
              ..clear()
              ..addAll(value);
          },
        );

        final completerKeys = <ValueKey<String>>[
          const ValueKey('CompleterSeedPhrase${1}CellKey'),
        ];

        // When
        await tester.pumpApp(sequencer);
        await tester.pumpAndSettle();

        // Removes from selectedWords
        for (final key in completerKeys) {
          await tester.tap(find.byKey(key));
        }

        // Then
        expect(selectedWords, expectedWords);
      },
    );

    testWidgets(
      'picking duplicated word selects only clicked one ',
      (tester) async {
        // Given
        const words = [
          SeedPhraseWord('broken', nr: 1),
          SeedPhraseWord('member', nr: 2),
          SeedPhraseWord('repeat', nr: 3),
          SeedPhraseWord('liquid', nr: 4),
          SeedPhraseWord('barely', nr: 5),
          SeedPhraseWord('electric', nr: 6),
          SeedPhraseWord('theory', nr: 7),
          SeedPhraseWord('paddle', nr: 8),
          SeedPhraseWord('coyote', nr: 9),
          SeedPhraseWord('behind', nr: 10),
          SeedPhraseWord('unique', nr: 11),
          SeedPhraseWord('member', nr: 12),
        ];

        final selectedWords = <SeedPhraseWord>[];

        const expectedWords = [
          SeedPhraseWord('member', nr: 2),
        ];

        final sequencer = SeedPhrasesSequencer(
          words: words,
          selectedWords: selectedWords,
          onChanged: (value) {
            selectedWords
              ..clear()
              ..addAll(value);
          },
        );

        // When
        await tester.pumpApp(sequencer);
        await tester.pumpAndSettle();

        final key = ValueKey('PickerSeedPhrase${words[1].nr}CellKey');
        await tester.tap(find.byKey(key));

        // Then
        expect(selectedWords, expectedWords);
      },
    );
  });
}
