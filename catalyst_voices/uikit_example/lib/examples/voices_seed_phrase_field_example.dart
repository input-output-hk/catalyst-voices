import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VoicesSeedPhraseFieldExample extends StatefulWidget {
  static const String route = '/seed-phrase-field-example';

  const VoicesSeedPhraseFieldExample({super.key});

  @override
  State<VoicesSeedPhraseFieldExample> createState() {
    return _VoicesSeedPhraseFieldExampleState();
  }
}

class _VoicesSeedPhraseFieldExampleState
    extends State<VoicesSeedPhraseFieldExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: const Text('Voices Text Field')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: AspectRatio(
            aspectRatio: 1,
            child: SeedPhraseField(
              wordList: SeedPhrase.wordList,
              onChanged: (value) {
                debugPrint('words: $value');
              },
            ),
          ),
        ),
      ),
    );
  }
}
