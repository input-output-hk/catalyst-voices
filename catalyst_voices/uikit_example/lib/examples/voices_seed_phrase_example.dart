import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesSeedPhraseExample extends StatefulWidget {
  static const String route = '/seed-phrase-example';

  static const _words = [
    'real',
    'mission',
    'secure',
    'renew',
    'key',
    'audit',
    'right',
    'gas',
    'house',
    'plant',
    'car',
    'sand',
  ];

  const VoicesSeedPhraseExample({
    super.key,
  });

  @override
  State<VoicesSeedPhraseExample> createState() =>
      _VoicesSeedPhraseExampleState();
}

class _VoicesSeedPhraseExampleState extends State<VoicesSeedPhraseExample> {
  final _selectedWords = <String>[];

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
