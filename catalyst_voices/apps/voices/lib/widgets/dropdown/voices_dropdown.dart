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

class SingleSelectDropdown<T> extends FormField<T> {
  final ValueChanged<T?>? onChanged;
  final List<DropdownMenuEntry<T>> items;
  final String? hintText;
  SingleSelectDropdown({
    super.key,
    super.initialValue,
    super.validator,
    super.enabled,
    required this.onChanged,
    required this.items,
    this.hintText,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(
          autovalidateMode: autovalidateMode,
          builder: (field) {
            final state = field as _SelectDropdownState;
            void onChangedHandler(T? value) {
              field.didChange(value);
              onChanged?.call(value);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: DropdownMenu(
                    expandedInsets: EdgeInsets.zero,
                    initialSelection: state._internalValue as T?,
                    enabled: enabled,
                    enableSearch: false,
                    requestFocusOnTap: false,
                    hintText: hintText,
                    dropdownMenuEntries: items,
                    onSelected: onChangedHandler,
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
                    trailingIcon: Offstage(
                      offstage: !enabled,
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
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      field.errorText ??
                          field.context.l10n.snackbarErrorLabelText,
                      style: Theme.of(field.context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            color: Theme.of(field.context).colorScheme.error,
                          ),
                    ),
                  ),
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
  FormFieldState<T> createState() => _SelectDropdownState<T>();
}

class _SelectDropdownState<T> extends FormFieldState<T> {
  T? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant SingleSelectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != _internalValue) {
      _internalValue = widget.initialValue;
    }
    if (_internalValue != value) {
      setValue(_internalValue);
      validate();
    }
  }
}
