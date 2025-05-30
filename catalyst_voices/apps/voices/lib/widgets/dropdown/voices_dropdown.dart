import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/form/voices_form_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class FilterByDropdown<T> extends StatelessWidget {
  final List<DropdownMenuEntry<T?>> items;
  final ValueChanged<T?>? onChanged;
  final Color? foregroundColor;
  final Widget? leadingIcon;
  final bool isOutlined;
  final bool insertByAll;
  final T? value;

  const FilterByDropdown({
    super.key,
    required this.items,
    this.onChanged,
    this.foregroundColor,
    this.leadingIcon,
    this.isOutlined = false,
    this.insertByAll = true,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final foregroundColor = this.foregroundColor ?? theme.colorScheme.primary;
    final border = isOutlined
        ? OutlineInputBorder(
            borderSide: BorderSide(color: context.colors.outlineBorderVariant),
            borderRadius: BorderRadius.circular(8),
          )
        : InputBorder.none;

    return DropdownMenu<T?>(
      dropdownMenuEntries: [
        if (insertByAll)
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
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        iconColor: foregroundColor,
        prefixIconColor: foregroundColor,
        prefixIconConstraints: BoxConstraints.tight(const Size.square(18)),
        suffixIconColor: foregroundColor,
      ),
      menuStyle: MenuStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        visualDensity: VisualDensity.compact,
      ),
      leadingIcon: leadingIcon,
      trailingIcon: VoicesAssets.icons.chevronDown.buildIcon(),
      selectedTrailingIcon: VoicesAssets.icons.chevronUp.buildIcon(),
      textAlign: TextAlign.end,
      textStyle: (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(color: foregroundColor),
    );
  }
}

class SingleSelectDropdown<T> extends VoicesFormField<T> {
  final List<DropdownMenuEntry<T>> items;
  final String? hintText;
  final bool filled;
  final double borderRadius;

  SingleSelectDropdown({
    super.key,
    required this.items,
    required super.value,
    required super.onChanged,
    super.enabled,
    super.validator,
    this.hintText,
    this.filled = true,
    this.borderRadius = 4,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
    FocusNode? focusNode,
  }) : super(
          builder: (field) {
            final state = field as _DropdownFormFieldState<T>;
            final theme = Theme.of(field.context);

            void onChangedHandler(T? value) {
              field.didChange(value);
              onChanged?.call(value);
            }

            return ConstrainedBox(
              constraints: const BoxConstraints(),
              child: DropdownMenu(
                requestFocusOnTap: false,
                controller: state._controller,
                focusNode: focusNode,
                expandedInsets: EdgeInsets.zero,
                initialSelection: state.value,
                enabled: enabled,
                hintText: hintText,
                dropdownMenuEntries: items,
                onSelected: onChangedHandler,
                inputDecorationTheme: InputDecorationTheme(
                  hintStyle: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colors.textOnPrimaryLevel1,
                  ),
                  fillColor: theme.colors.elevationsOnSurfaceNeutralLv1Grey,
                  filled: filled,
                  enabledBorder: _border(field.context, borderRadius),
                  disabledBorder: _border(field.context, borderRadius),
                  focusedBorder: _border(field.context, borderRadius),
                  errorStyle: theme.textTheme.bodySmall?.copyWith(
                    color: enabled ? theme.colorScheme.error : theme.colors.textDisabled,
                  ),
                  focusColor: Colors.tealAccent,
                ),
                errorText: field.errorText,
                // using visibility so that the widget reserves
                // the space for the icon, otherwise when widget changes
                // to edits mode it expands to make space for the icon
                trailingIcon: Visibility.maintain(
                  visible: enabled,
                  child: VoicesAssets.icons.chevronDown.buildIcon(),
                ),
                selectedTrailingIcon: VoicesAssets.icons.chevronUp.buildIcon(),
                menuStyle: MenuStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    theme.colors.elevationsOnSurfaceNeutralLv1Grey,
                  ),
                  maximumSize: const WidgetStatePropertyAll(Size.fromHeight(350)),
                ),
              ),
            );
          },
        );

  @override
  FormFieldState<T> createState() => _DropdownFormFieldState<T>();

  static OutlineInputBorder _border(
    BuildContext context,
    double borderRadius,
  ) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colors.outlineBorderVariant,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      );
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
        foregroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.primary,
        ),
        visualDensity: VisualDensity.compact,
      );
}

class _DropdownFormFieldState<T> extends VoicesFormFieldState<T> {
  final TextEditingController _controller = TextEditingController();

  @override
  SingleSelectDropdown<T> get widget => super.widget as SingleSelectDropdown<T>;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void setValue(T? value) {
    super.setValue(value);
    final item = widget.items.firstWhereOrNull((e) => e.value == value);
    if (item != null) {
      _controller.textWithSelection = item.label;
    } else {
      _controller.textWithSelection = '';
    }
  }
}
