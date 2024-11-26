import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VoicesDropdown<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T?>> items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  const VoicesDropdown({
    super.key,
    required this.items,
    this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final ctx = Theme.of(context);
    return DropdownMenu<T?>(
      dropdownMenuEntries: [
        VoicesDropdownMenuEntry<T?>(
          value: null,
          label: context.l10n.all,
          context: context,
        ),
        ...items,
      ],
      onSelected: onChanged,
      initialSelection: value,
      enableSearch: false,
      requestFocusOnTap: false,
      enableFilter: false,
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      menuStyle: MenuStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        visualDensity: VisualDensity.compact,
      ),
      trailingIcon: VoicesAssets.icons.chevronDown
          .buildIcon(color: ctx.colorScheme.primary),
      selectedTrailingIcon: VoicesAssets.icons.chevronUp
          .buildIcon(color: ctx.colorScheme.primary),
      textAlign: TextAlign.end,
      textStyle:
          ctx.textTheme.labelLarge?.copyWith(color: ctx.colorScheme.primary),
    );
  }
}

class VoicesDropdownMenuEntry<T> extends DropdownMenuEntry<T> {
  final BuildContext context;
  VoicesDropdownMenuEntry({
    required super.value,
    required super.label,
    required this.context,
    ButtonStyle? style,
  }) : super(
          style: style ?? _createButtonStyle(context),
        );

  static ButtonStyle _createButtonStyle(BuildContext context) => ButtonStyle(
        textStyle: WidgetStateProperty.all(
          Theme.of(context).textTheme.labelLarge,
        ),
        foregroundColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
        visualDensity: VisualDensity.compact,
      );
}
