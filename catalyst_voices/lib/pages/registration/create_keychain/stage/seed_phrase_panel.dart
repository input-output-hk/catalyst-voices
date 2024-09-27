import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class SeedPhrasePanel extends StatelessWidget {
  const SeedPhrasePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SeedPhrasesViewer(
          words: List.generate(
            12,
            (index) => 'word_$index',
          ),
        ),
      ],
    );
  }
}
