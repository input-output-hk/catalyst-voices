import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/document_builder/document_error_text.dart';
import 'package:catalyst_voices/widgets/form/voices_form_field.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:collection/collection.dart';
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
    final theme = Theme.of(context);
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
          .buildIcon(color: theme.colorScheme.primary),
      selectedTrailingIcon: VoicesAssets.icons.chevronUp
          .buildIcon(color: theme.colorScheme.primary),
      textAlign: TextAlign.end,
      textStyle: theme.textTheme.labelLarge
          ?.copyWith(color: theme.colorScheme.primary),
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
        foregroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.primary,
        ),
        visualDensity: VisualDensity.compact,
      );
}

class SingleSelectDropdown<T> extends VoicesFormField<T> {
  final List<DropdownMenuEntry<T>> items;
  final String? hintText;

  SingleSelectDropdown({
    super.key,
    required this.items,
    required super.value,
    required super.onChanged,
    super.validator,
    super.enabled,
    this.hintText,
    super.autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(
          builder: (field) {
            final state = field as _DropdownFormFieldState<T>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: DropdownMenu(
                    controller: state._controller,
                    expandedInsets: EdgeInsets.zero,
                    initialSelection: state.value,
                    enabled: enabled,
                    hintText: hintText,
                    dropdownMenuEntries: items,
                    onSelected: field.didChange,
                    inputDecorationTheme: InputDecorationTheme(
                      hintStyle: Theme.of(field.context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                            color: Theme.of(field.context).colors.textDisabled,
                          ),
                      fillColor: Theme.of(field.context)
                          .colors
                          .elevationsOnSurfaceNeutralLv1Grey,
                      filled: true,
                      enabledBorder: _border(field.context),
                      disabledBorder: _border(field.context),
                      focusedBorder: _border(field.context),
                    ),
                    // using visibility so that the widget reserves
                    // the space for the icon, otherwise when widget changes
                    // to edits mode it expands to make space for the icon
                    trailingIcon: Visibility.maintain(
                      visible: enabled,
                      child: VoicesAssets.icons.chevronDown.buildIcon(),
                    ),
                    selectedTrailingIcon:
                        VoicesAssets.icons.chevronUp.buildIcon(),
                    menuStyle: MenuStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Theme.of(field.context)
                            .colors
                            .elevationsOnSurfaceNeutralLv1Grey,
                      ),
                      maximumSize:
                          const WidgetStatePropertyAll(Size.fromHeight(350)),
                    ),
                  ),
                ),
                if (field.hasError) DocumentErrorText(text: field.errorText),
              ],
            );
          },
        );

  static OutlineInputBorder _border(BuildContext context) => OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colors.outlineBorderVariant,
        ),
      );

  @override
  FormFieldState<T> createState() => _DropdownFormFieldState<T>();
}

class _DropdownFormFieldState<T> extends VoicesFormFieldState<T> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void setValue(T? value) {
    super.setValue(value);
    final item = _widget.items.firstWhereOrNull((e) => e.value == value);
    if (item != null) {
      _controller.textWithSelection = item.label;
    }
  }

  SingleSelectDropdown<T> get _widget => widget as SingleSelectDropdown<T>;
}
