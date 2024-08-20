import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/common/columns_row.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class SeedPhrasesCompleter extends StatelessWidget {
  final int columnsCount;
  final int slotsCount;
  final Set<String> words;
  final ValueChanged<String>? onWordDeleteTap;

  const SeedPhrasesCompleter({
    super.key,
    this.columnsCount = 2,
    required this.slotsCount,
    this.words = const <String>{},
    this.onWordDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final slots = List.generate(slotsCount, words.elementAtOrNull);
    final onWordDeleteTap = this.onWordDeleteTap;

    // If has less words then slots then next empty slot is "current".
    // Null when has all words completed
    final currentIndex = words.length < slotsCount ? words.length : null;

    return MediaQuery.withNoTextScaling(
      child: ColumnsRow(
        columnsCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 6,
        children: slots.mapIndexed((index, element) {
          final isCurrent = index == currentIndex;
          final isPrevious = currentIndex != null
              ? currentIndex == index + 1
              : index == slotsCount - 1;

          final canDelete = element != null && isPrevious;

          return _WordSlotCell(
            element,
            key: ValueKey('CompleterSeedPhrase${index}CellKey'),
            slotNr: index + 1,
            isActive: isCurrent,
            showDelete: canDelete,
            onTap: !canDelete || onWordDeleteTap == null
                ? null
                : () {
                    onWordDeleteTap(element);
                  },
          );
        }).toList(),
      ),
    );
  }
}

class _WordSlotCell extends StatelessWidget {
  final String? data;
  final int slotNr;
  final bool isActive;
  final bool showDelete;
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
              // TODO(damian): loc
              child: Text(data ?? 'Slot $slotNr'),
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
