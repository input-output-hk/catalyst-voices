import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VoicesSeedPhraseExample extends StatefulWidget {
  static const String route = '/seed-phrase-example';

  static const _words = [
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

  const VoicesSeedPhraseExample({
    super.key,
  });

  @override
  State<VoicesSeedPhraseExample> createState() =>
      _VoicesSeedPhraseExampleState();
}

class _VoicesSeedPhraseExampleState extends State<VoicesSeedPhraseExample> {
  final _selectedWords = <SeedPhraseWord>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seed Phrase')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        children: [
          const Text('SeedPhrasesViewer'),
          const SizedBox(height: 12),
          const SeedPhrasesViewer(words: VoicesSeedPhraseExample._words),
          const SizedBox(height: 24),
          const Text('SeedPhrasesSequencer'),
          const SizedBox(height: 12),
          SeedPhrasesSequencer(
            words: VoicesSeedPhraseExample._words,
            selectedWords: _selectedWords,
            onChanged: (value) {
              setState(() {
                _selectedWords
                  ..clear()
                  ..addAll(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
