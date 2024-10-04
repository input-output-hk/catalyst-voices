import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_sequencer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SeedPhrasesSequencer', () {
    const words = ['real', 'mission', 'secure', 'renew', 'key', 'audit'];

    testWidgets(
      'clicking word in picker triggers on change callback',
      (tester) async {
        // Given
        final selectedWords = <String>{};
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
        const wordPickerKey = ValueKey('PickerSeedPhrase${0}CellKey');

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
        final selectedWords = <String>[
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
  });
}
