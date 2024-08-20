import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_completer.dart';
import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_picker.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SeedPhrasesSequencer extends StatefulWidget {
  final List<String> words;
  final ValueChanged<Set<String>> onChanged;

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
          color: Theme.of(context).colors.outlineBorderVariant!,
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
