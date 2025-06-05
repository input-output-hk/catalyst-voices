import 'package:catalyst_voices/widgets/common/columns_row.dart';
import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_completer.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// A widget that displays a grid of seed phrases with selection functionality.
///
/// Typically used together with a [SeedPhrasesCompleter].
class SeedPhrasesPicker extends StatelessWidget {
  /// The number of columns to use for displaying the seed phrases.
  /// Defaults to 2.
  final int columnsCount;

  /// The list of seed phrases to be displayed.
  final List<SeedPhraseWord> words;

  /// A list of currently selected seed phrases. Defaults to empty list.
  final List<SeedPhraseWord> selectedWords;

  /// A callback function triggered when a non-selected seed phrase is tapped.
  final ValueChanged<SeedPhraseWord>? onWordTap;

  /// See [ColumnsRow.mainAxisSpacing].
  final double mainAxisSpacing;

  /// See [ColumnsRow.crossAxisSpacing].
  final double crossAxisSpacing;

  const SeedPhrasesPicker({
    super.key,
    this.columnsCount = 2,
    required this.words,
    this.selectedWords = const <SeedPhraseWord>[],
    this.onWordTap,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    final onWordTap = this.onWordTap;

    return MediaQuery.withNoTextScaling(
      child: ColumnsRow(
        columnsCount: 2,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        children: words.map((word) {
          final isSelected = selectedWords.contains(word);

          return _WordCell(
            word.data,
            key: ValueKey('PickerSeedPhrase${word.nr}CellKey'),
            isSelected: isSelected,
            onTap: isSelected || onWordTap == null
                ? null
                : () {
                    onWordTap(word);
                  },
          );
        }).toList(),
      ),
    );
  }
}

/// A widget representing a single seed phrase cell within the
/// [SeedPhrasesPicker].
class _WordCell extends StatelessWidget {
  /// The seed phrase word to be displayed.
  final String data;

  /// Whether the seed phrase is currently selected.
  final bool isSelected;

  /// A callback function triggered when the cell is tapped (if not selected).
  final VoidCallback? onTap;

  const _WordCell(
    this.data, {
    super.key,
    this.isSelected = false,
    this.onTap,
  });

  Set<WidgetState> get states => {
        if (isSelected) WidgetState.selected,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = WidgetStateProperty<Color?>.fromMap({
      WidgetState.selected: theme.colors.outlineBorderVariant,
      WidgetState.any: theme.colorScheme.primary,
    });
    final foregroundColor = WidgetStateProperty<Color?>.fromMap({
      WidgetState.selected: theme.colors.textDisabled,
      WidgetState.any: theme.colors.textOnPrimaryWhite,
    });

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 32),
      child: Material(
        color: backgroundColor.resolve(states),
        borderRadius: BorderRadius.circular(8),
        textStyle: theme.textTheme.labelLarge?.copyWith(color: foregroundColor.resolve(states)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Center(child: Text(data)),
        ),
      ),
    );
  }
}
