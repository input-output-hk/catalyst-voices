import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_completer.dart';
import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_picker.dart';
import 'package:flutter/material.dart';

/// A widget that allows users to sequence a set of seed phrases.
///
/// It provides a two-section interface:
///  - A completer section where users can fill slots with selected phrases.
///  - A picker section where users can select available phrases.
///
/// The selected phrases are managed internally and updated through the
/// [onChanged] callback.
class SeedPhrasesSequencer extends StatelessWidget {
  /// The list of available seed phrases.
  final List<String> words;

  /// The list of words selected by user.
  final List<String> selectedWords;

  /// A callback function triggered when the set of selected phrases changes.
  final ValueChanged<List<String>> onChanged;

  /// Creates a [SeedPhrasesSequencer] widget.
  const SeedPhrasesSequencer({
    super.key,
    required this.words,
    this.selectedWords = const [],
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SeedPhrasesCompleter(
          slotsCount: words.length,
          words: selectedWords,
          onWordTap: _removeWord,
        ),
        const SizedBox(height: 10),
        SeedPhrasesPicker(
          words: words,
          selectedWords: selectedWords,
          onWordTap: _selectWord,
        ),
      ],
    );
  }

  void _removeWord(String word) {
    final words = [...selectedWords]..remove(word);

    onChanged(words);
  }

  void _selectWord(String word) {
    final words = [...selectedWords, word];

    onChanged(words);
  }
}
