import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesSeedPhraseExample extends StatelessWidget {
  static const String route = '/seed-phrase-example';

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
          SeedPhrasesViewer(
            words: [
              'real',
              'mission',
              'secure',
              'renew',
              'renew renew renew',
            ],
          ),
        ],
      ),
    );
  }
}
