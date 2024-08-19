import 'package:catalyst_voices/widgets/seed_phrase/seed_phrase_viewer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class SeedPhrasesViewer extends StatelessWidget {
  final List<String> words;
  final int columnsCount;

  const SeedPhrasesViewer({
    super.key,
    required this.words,
    this.columnsCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    final columnWordsCount = (words.length / columnsCount).ceil();
    final columns = words
        .mapIndexed((index, element) => (index, element))
        .slices(columnWordsCount)
        .toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columns
          .map((words) => _SeedPhrasesColumn(words: words))
          .map((e) => Expanded(child: e))
          .expandIndexed(
            (index, element) => [
              if (index != 0) const SizedBox(width: 24),
              element,
            ],
          )
          .toList(),
    );
  }
}

class _SeedPhrasesColumn extends StatelessWidget {
  const _SeedPhrasesColumn({
    required this.words,
  });

  final List<(int, String)> words;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: words
          .map((word) {
            return SeedPhraseViewer(
              number: word.$1 + 1,
              word: word.$2,
            );
          })
          .expandIndexed(
            (index, element) => [
              if (index != 0) const SizedBox(height: 12),
              element,
            ],
          )
          .toList(),
    );
  }
}
