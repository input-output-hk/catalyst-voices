import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ModalMenuItem extends Equatable {
  final String id;
  final String label;
  final bool isEnabled;

  const ModalMenuItem({
    required this.id,
    required this.label,
    this.isEnabled = true,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        isEnabled,
      ];
}

class VoicesModalMenu extends StatelessWidget {
  final String? selectedId;
  final List<ModalMenuItem> menuItems;
  final ValueChanged<String>? onTap;

  const VoicesModalMenu({
    super.key,
    this.selectedId,
    required this.menuItems,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final onTap = this.onTap;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: menuItems
          .map<Widget>(
            (item) {
              return _VoicesModalMenuItemTile(
                key: ValueKey('VoicesModalMenu[${item.id}]Key'),
                label: item.label,
                isSelected: selectedId == item.id,
                isEnabled: item.isEnabled,
                onTap: onTap != null ? () => onTap(item.id) : null,
              );
            },
          )
          .separatedBy(const SizedBox(height: 8))
          .toList(),
    );
  }
}

class _VoicesModalMenuItemTile extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  const _VoicesModalMenuItemTile({
    required super.key,
    required this.label,
    required this.isSelected,
    required this.isEnabled,
    this.onTap,
  });

  @override
  State<_VoicesModalMenuItemTile> createState() {
    return _VoicesModalMenuItemTileState();
  }
}

class _VoicesModalMenuItemTileState extends State<_VoicesModalMenuItemTile> {
  late _BackgroundColor _backgroundColor;
  late _ForegroundColor _foregroundColor;
  late _LabelTextStyle _labelTextStyle;
  late _BorderColor _border;

  Set<WidgetState> get _states => {
        if (!widget.isEnabled) WidgetState.disabled,
        if (widget.isSelected) WidgetState.selected,
      };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final theme = Theme.of(context);

    _backgroundColor = _BackgroundColor(theme.colorScheme.brightness);
    _foregroundColor = _ForegroundColor(theme.colors);
    _labelTextStyle = _LabelTextStyle(theme.textTheme);
    _border = _BorderColor(theme.colorScheme.brightness);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isEnabled ? widget.onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        constraints: const BoxConstraints(minWidth: 320),
        decoration: BoxDecoration(
          color: _backgroundColor.resolve(_states),
          border: _border.resolve(_states),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16)
            .add(const EdgeInsets.only(bottom: 2)),
        child: Text(
          widget.label,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: _labelTextStyle
              .resolve(_states)
              .copyWith(color: _foregroundColor.resolve(_states)),
        ),
      ),
    );
  }
}

class _BackgroundColor extends WidgetStateProperty<Color?> {
  final Brightness _brightness;

  _BackgroundColor(this._brightness);

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      // TODO(damian-molinski): Those colors are not using properties.
      // TODO(damian-molinski): Dark/Transparent/On primary surface P40 016
      // TODO(damian-molinski): Light/Transparent/On surface P40 08
      return switch (_brightness) {
        Brightness.dark => const Color(0x29123cd3),
        Brightness.light => const Color(0x1f123cd3),
      };
    }

    return null;
  }
}

class _ForegroundColor extends WidgetStateProperty<Color?> {
  final VoicesColorScheme _colors;

  _ForegroundColor(this._colors);

  @override
  Color? resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.disabled)) {
      return _colors.textDisabled;
    }

    return _colors.textOnPrimaryLevel1;
  }
}

class _LabelTextStyle extends WidgetStateProperty<TextStyle> {
  final TextTheme _textTheme;

  _LabelTextStyle(this._textTheme);

  @override
  TextStyle resolve(Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return _textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold);
    }

    return _textTheme.bodyLarge!;
  }
}

class _BorderColor extends WidgetStateProperty<BoxBorder> {
  final Brightness _brightness;

  _BorderColor(this._brightness);

  @override
  BoxBorder resolve(Set<WidgetState> states) {
    // TODO(damian-molinski): Those colors are not using properties.
    // TODO(damian-molinski): Elevations/On surface/Neutral/Transparent/on surface N10 08
    // TODO(damian-molinski): Elevations/On surface/Neutral/Transparent/on surface N10 08
    return switch (_brightness) {
      Brightness.dark => Border.all(color: const Color(0x1fbfc8d9)),
      Brightness.light => Border.all(color: const Color(0x14212a3d)),
    };
  }
}
