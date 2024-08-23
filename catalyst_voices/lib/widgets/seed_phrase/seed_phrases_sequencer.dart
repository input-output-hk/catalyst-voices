import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_completer.dart';
import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_picker.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget that allows users to sequence a set of seed phrases.
///
/// It provides a two-section interface:
///  - A completer section where users can fill slots with selected phrases.
///  - A picker section where users can select available phrases.
///
/// The selected phrases are managed internally and updated through the
/// [onChanged] callback.
class SeedPhrasesSequencer extends StatefulWidget {
  /// The list of available seed phrases.
  final List<String> words;

  /// A callback function triggered when the set of selected phrases changes.
  final ValueChanged<Set<String>> onChanged;

  /// Creates a [SeedPhrasesSequencer] widget.
  const SeedPhrasesSequencer({
    super.key,
    required this.words,
    required this.onChanged,
  });

  @override
  State<SeedPhrasesSequencer> createState() => _SeedPhrasesSequencerState();
}

class _SeedPhrasesSequencerState extends State<SeedPhrasesSequencer> {
  final _selected = <String>{};

  @override
  void didUpdateWidget(covariant SeedPhrasesSequencer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!listEquals(widget.words, oldWidget.words)) {
      _selected.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BorderDecorator(
          child: SeedPhrasesCompleter(
            slotsCount: widget.words.length,
            words: _selected,
            onWordTap: _removeWord,
          ),
        ),
        const SizedBox(height: 12),
        _BorderDecorator(
          child: SeedPhrasesPicker(
            words: widget.words,
            selectedWords: _selected,
            onWordTap: _selectWord,
          ),
        ),
      ],
    );
  }

  void _removeWord(String word) {
    setState(() {
      _selected.remove(word);
      widget.onChanged(Set.of(_selected));
    });
  }

  void _selectWord(String word) {
    setState(() {
      _selected.add(word);
      widget.onChanged(Set.of(_selected));
    });
  }
}

class _BorderDecorator extends StatelessWidget {
  final Widget child;

  const _BorderDecorator({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colors.outlineBorderVariant ??
              Theme.of(context).colorScheme.outlineVariant,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }
}
