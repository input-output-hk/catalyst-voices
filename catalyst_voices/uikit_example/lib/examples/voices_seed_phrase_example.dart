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
  ];

  const VoicesSeedPhraseExample({
    super.key,
  });

  @override
  State<VoicesSeedPhraseExample> createState() {
    return _VoicesSeedPhraseExampleState();
  }
}

class _VoicesSeedPhraseExampleState extends State<VoicesSeedPhraseExample> {
  final _selectedWords = <String>{};

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
          const Text('SeedPhrasesEditor'),
          const SizedBox(height: 12),
          SeedPhrasesEditor(
            words: VoicesSeedPhraseExample._words,
            onChanged: (value) {},
          ),
          const SizedBox(height: 24),
          const Text('SeedPhrasesPicker'),
          const SizedBox(height: 12),
          SeedPhrasesPicker(
            words: VoicesSeedPhraseExample._words,
            selectedWords: _selectedWords,
            onWordTap: (value) {
              setState(() {
                _selectedWords.add(value);
              });
            },
          ),
          const SizedBox(height: 24),
          const Text('SeedPhrasesCompleter'),
          const SizedBox(height: 12),
          SeedPhrasesCompleter(
            slotsCount: VoicesSeedPhraseExample._words.length,
            words: _selectedWords,
            onWordTap: (value) {
              setState(() {
                _selectedWords.remove(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
