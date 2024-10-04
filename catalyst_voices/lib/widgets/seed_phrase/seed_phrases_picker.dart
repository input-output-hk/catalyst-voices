import 'package:catalyst_voices/widgets/common/columns_row.dart';
import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_completer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// A widget that displays a grid of seed phrases with selection functionality.
///
/// Typically used together with a [SeedPhrasesCompleter].
class SeedPhrasesPicker extends StatelessWidget {
  /// The number of columns to use for displaying the seed phrases.
  /// Defaults to 2.
  final int columnsCount;

  /// The list of seed phrases to be displayed.
  final List<String> words;

  /// A list of currently selected seed phrases. Defaults to empty list.
  final List<String> selectedWords;

  /// A callback function triggered when a non-selected seed phrase is tapped.
  final ValueChanged<String>? onWordTap;

  /// See [ColumnsRow.mainAxisSpacing].
  final double mainAxisSpacing;

  /// See [ColumnsRow.crossAxisSpacing].
  final double crossAxisSpacing;

  const SeedPhrasesPicker({
    super.key,
    this.columnsCount = 2,
    required this.words,
    this.selectedWords = const <String>[],
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
        children: words.mapIndexed((index, word) {
          final isSelected = selectedWords.contains(word);

          return _WordCell(
            word,
            key: ValueKey('PickerSeedPhrase${index}CellKey'),
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

  Set<WidgetState> get states => {
        if (isSelected) WidgetState.selected,
      };

  const _WordCell(
    this.data, {
    super.key,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = _CellBackgroundColor(theme);
    final foregroundColor = _CellForegroundColor(theme);

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 32),
      child: Material(
        color: backgroundColor.resolve(states),
        borderRadius: BorderRadius.circular(8),
        textStyle: theme.textTheme.labelLarge
            ?.copyWith(color: foregroundColor.resolve(states)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Center(child: Text(data)),
        ),
      ),
    );
  }
}

final class _CellBackgroundColor extends WidgetStateProperty<Color> {
  final ThemeData theme;

  _CellBackgroundColor(this.theme);

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return theme.colorScheme.primary.withOpacity(0.12);
    }

    return theme.colorScheme.primary;
  }
}

final class _CellForegroundColor extends WidgetStateProperty<Color> {
  final ThemeData theme;

  _CellForegroundColor(this.theme);

  @override
  Color resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return theme.colorScheme.primary;
    }

    return theme.colorScheme.onPrimary;
  }
}
