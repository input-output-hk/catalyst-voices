import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/common/columns_row.dart';
import 'package:catalyst_voices/widgets/seed_phrase/seed_phrases_picker.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// A widget that displays slots for selecting seed phrases and filling them up.
///
/// Typically used together with a [SeedPhrasesPicker].
class SeedPhrasesCompleter extends StatelessWidget {
  /// The number of columns to use for displaying the slots.
  /// Defaults to 2.
  final int columnsCount;

  /// The total number of slots available for seed phrases.
  final int slotsCount;

  /// A set of currently selected seed phrases. Defaults to an empty set.
  final List<SeedPhraseWord> words;

  /// A callback function triggered when a non-filled slot or a filled but only
  /// for previous selection.
  final ValueChanged<SeedPhraseWord>? onWordTap;

  /// See [ColumnsRow.mainAxisSpacing].
  final double mainAxisSpacing;

  /// See [ColumnsRow.crossAxisSpacing].
  final double crossAxisSpacing;

  /// Creates a [SeedPhrasesCompleter] widget.
  const SeedPhrasesCompleter({
    super.key,
    this.columnsCount = 2,
    required this.slotsCount,
    this.words = const <SeedPhraseWord>[],
    this.onWordTap,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    final slots = List.generate(slotsCount, words.elementAtOrNull);
    final onWordTap = this.onWordTap;

    // Identify the currently active slot (being filled) and the
    // previous slot (deletable).
    final currentIndex = words.length < slotsCount ? words.length : null;

    return MediaQuery.withNoTextScaling(
      child: ColumnsRow(
        columnsCount: 2,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        children: slots.mapIndexed((index, element) {
          final isCurrent = index == currentIndex;
          final isPrevious = currentIndex != null
              ? currentIndex == index + 1
              : index == slotsCount - 1;

          final canDelete = element != null && isPrevious;

          return _WordSlotCell(
            element?.data,
            key: ValueKey('CompleterSeedPhrase${index}CellKey'),
            slotNr: index + 1,
            isActive: isCurrent,
            showDelete: canDelete,
            onTap: !canDelete || onWordTap == null
                ? null
                : () => onWordTap(element),
          );
        }).toList(),
      ),
    );
  }
}

/// A widget representing a single slot for selecting a seed phrase
/// within the [SeedPhrasesCompleter].
class _WordSlotCell extends StatelessWidget {
  /// The currently selected seed phrase for this slot (can be null).
  final String? data;

  /// The slot number (1-based).
  final int slotNr;

  /// Whether the slot is currently being filled (active).
  final bool isActive;

  /// Whether the slot shows a delete icon when filled.
  final bool showDelete;

  /// A callback function triggered when the slot is tapped (if allowed).
  final VoidCallback? onTap;

  Set<WidgetState> get states => {
        if (data != null) WidgetState.selected,
        if (isActive) WidgetState.focused,
        if (data == null && !isActive) WidgetState.disabled,
      };

  const _WordSlotCell(
    this.data, {
    super.key,
    required this.slotNr,
    this.isActive = false,
    this.showDelete = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final backgroundColor = _CellBackgroundColor(theme);
    final foregroundColor = _CellForegroundColor(theme);
    final border = _CellBorder(theme);

    return AnimatedContainer(
      duration: kThemeChangeDuration,
      constraints: const BoxConstraints.tightFor(height: 32),
      decoration: BoxDecoration(
        color: backgroundColor.resolve(states),
        border: border.resolve(states),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        type: MaterialType.transparency,
        textStyle: (theme.textTheme.labelLarge ?? const TextStyle())
            .copyWith(color: foregroundColor.resolve(states)),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Center(
            child: AffixDecorator(
              gap: showDelete ? 8 : 0,
              suffix: Offstage(
                offstage: !showDelete,
                child: const Icon(Icons.close),
              ),
              iconTheme: IconThemeData(
                color: foregroundColor.resolve(states),
                size: 18,
              ),
              child: Text(data ?? context.l10n.seedPhraseSlotNr(slotNr)),
            ),
          ),
        ),
      ),
    );
  }
}

final class _CellBackgroundColor extends WidgetStateProperty<Color?> {
  final ThemeData theme;

  _CellBackgroundColor(this.theme);

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return theme.colorScheme.onSurface.withOpacity(0.08);
    }

    if (states.contains(WidgetState.focused)) {
      return theme.colors.onSurfaceNeutralOpaqueLv0;
    }

    return theme.colorScheme.primary;
  }
}

final class _CellForegroundColor extends WidgetStateProperty<Color?> {
  final ThemeData theme;

  _CellForegroundColor(this.theme);

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return theme.colors.textDisabled;
    }

    if (states.contains(WidgetState.focused)) {
      return theme.colorScheme.primary;
    }

    return theme.colorScheme.onPrimary;
  }
}

final class _CellBorder extends WidgetStateProperty<BoxBorder?> {
  final ThemeData theme;

  _CellBorder(this.theme);

  @override
  BoxBorder? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.focused)) {
      return Border.all(
        color: theme.colorScheme.primary,
      );
    }

    return null;
  }
}
