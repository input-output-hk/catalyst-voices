import 'package:catalyst_voices/widgets/common/columns_row.dart';
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
    return ColumnsRow(
      columnsCount: 2,
      mainAxisSpacing: 24,
      crossAxisSpacing: 12,
      children: words.mapIndexed((index, word) {
        return SeedPhraseViewer(
          key: ValueKey('SeedPhrase${word}CellKey'),
          number: index + 1,
          word: word,
        );
      }).toList(),
    );
  }
}
