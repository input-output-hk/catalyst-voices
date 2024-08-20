import 'package:catalyst_voices/widgets/common/columns_row.dart';
import 'package:flutter/material.dart';

class SeedPhrasesPicker extends StatelessWidget {
  final int columnsCount;
  final List<String> words;
  final Set<String> selectedWords;
  final ValueChanged<String>? onWordTap;

  const SeedPhrasesPicker({
    super.key,
    this.columnsCount = 2,
    required this.words,
    this.selectedWords = const <String>{},
    this.onWordTap,
  });

  @override
  Widget build(BuildContext context) {
    final onWordTap = this.onWordTap;

    return MediaQuery.withNoTextScaling(
      child: ColumnsRow(
        columnsCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 6,
        children: words.map((word) {
          final isSelected = selectedWords.contains(word);

          return _WordCell(
            word,
            key: ValueKey('PickerSeedPhrase${word}CellKey'),
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

class _WordCell extends StatelessWidget {
  final String data;
  final bool isSelected;
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
