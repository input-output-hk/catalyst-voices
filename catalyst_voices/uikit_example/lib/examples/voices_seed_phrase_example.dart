import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesSeedPhraseExample extends StatelessWidget {
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
    'key',
    'secure',
    'win',
    'review',
    'car',
    'sand',
    'real',
    'house',
  ];

  const VoicesSeedPhraseExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seed Phrase')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        children: [
          const Text('SeedPhrasesViewer'),
          const SizedBox(height: 12),
          const SeedPhrasesViewer(words: _words),
          const SizedBox(height: 24),
          const Text('SeedPhrasesSequencer'),
          const SizedBox(height: 12),
          SeedPhrasesSequencer(
            words: _words,
            onChanged: (value) {},
          ),
        ],
      ),
    );
  }
}
