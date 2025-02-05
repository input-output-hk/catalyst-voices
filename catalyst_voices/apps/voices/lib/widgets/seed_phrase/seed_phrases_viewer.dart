import 'package:catalyst_voices/widgets/common/columns_row.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Displays a list of seed phrases in a grid-like layout with
/// customizable columns.
class SeedPhrasesViewer extends StatelessWidget {
  /// The number of columns to use for displaying the seed phrases.
  /// Defaults to 2.
  final int columnsCount;

  /// The list of seed phrases to be displayed.
  final List<SeedPhraseWord> words;

  const SeedPhrasesViewer({
    super.key,
    this.columnsCount = 2,
    required this.words,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withNoTextScaling(
      child: ColumnsRow(
        columnsCount: 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 12,
        children: words.mapIndexed((index, word) {
          return _WordCell(
            word.data,
            key: ValueKey('SeedPhrase${index}CellKey'),
            number: word.nr,
          );
        }).toList(),
      ),
    );
  }
}

/// A widget representing a single seed phrase cell within the
/// [SeedPhrasesViewer].
class _WordCell extends StatelessWidget {
  /// The seed phrase word to be displayed.
  final String data;

  /// The sequential number associated with the seed phrase.
  final int number;

  const _WordCell(
    this.data, {
    super.key,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      decoration: BoxDecoration(
        color: theme.colors.onSurfaceNeutralOpaqueLv1,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyLarge ?? const TextStyle(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              key: const Key('SeedPhraseNumber'),
              '${number.toString().padLeft(2, '0')}.',
              style: TextStyle(color: theme.colors.textOnPrimary),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                key: const Key('SeedPhraseWord'),
                data,
                style: TextStyle(color: theme.colors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
