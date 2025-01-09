import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class FilterByDropdown<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T?>> items;
  final ValueChanged<T?>? onChanged;
  final T? value;
  const FilterByDropdown({
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

class SingleSelectDropdown<T> extends StatelessWidget {
  final TextEditingController? textEditingController;
  final List<DropdownMenuEntry<T>> items;
  final T? initialValue;
  final bool enabled;
  final ValueChanged<T?>? onSelected;
  final String? hintText;

  const SingleSelectDropdown({
    super.key,
    this.textEditingController,
    this.initialValue,
    required this.items,
    this.enabled = true,
    required this.onSelected,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: double.infinity,
      controller: textEditingController,
      initialSelection: initialValue,
      enabled: enabled,
      hintText: hintText,
      dropdownMenuEntries: items,
      onSelected: onSelected,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colors.textDisabled,
            ),
        fillColor: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
        filled: true,
        enabledBorder: _border(context),
        disabledBorder: _border(context),
        focusedBorder: _border(context),
      ),
      trailingIcon: Offstage(
        offstage: enabled,
        child: VoicesAssets.icons.chevronDown.buildIcon(),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(
          Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
        ),
      ),
    );
  }

  OutlineInputBorder _border(BuildContext context) => OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colors.outlineBorderVariant!,
        ),
      );
}
