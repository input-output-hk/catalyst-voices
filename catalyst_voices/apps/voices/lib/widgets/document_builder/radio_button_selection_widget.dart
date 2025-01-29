import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class RadioButtonSelectWidget extends StatefulWidget {
  final DocumentValueProperty<String> property;
  final DocumentRadioButtonSelect schema;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const RadioButtonSelectWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<RadioButtonSelectWidget> createState() =>
      _RadioButtonSelectionWidgetState();
}

class _RadioButtonSelectionWidgetState extends State<RadioButtonSelectWidget> {
  late String _selectedValue;

  List<String> get _items => widget.schema.enumValues ?? <String>[];

  String get _title => widget.schema.formattedTitle;

  @override
  void initState() {
    super.initState();
    _handleInitialValue();
  }

  @override
  void didUpdateWidget(RadioButtonSelectWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.property.value != widget.property.value) {
      _handleInitialValue();
    }

    if (oldWidget.isEditMode != widget.isEditMode &&
        widget.isEditMode == false) {
      _handleInitialValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_title.isNotEmpty) ...[
          Text(
            _title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _RadioButtonForm(
            selectedValue: _selectedValue,
            items: _items,
            enabled: widget.isEditMode,
            onChanged: _handleValueChanged,
            validator: _validate,
          ),
        ],
      ],
    );
  }

  void _handleInitialValue() {
    _selectedValue = widget.property.value ?? '';
  }

  void _handleValueChanged(String? value) {
    setState(() {
      _selectedValue = value ?? '';
    });

    if (widget.property.value != value) {
      _notifyChangeListener(value);
    }
  }

  void _notifyChangeListener(String? value) {
    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: value,
    );
    widget.onChanged([change]);
  }

  String? _validate(String? value) {
    final result = widget.schema.validate(value);
    return LocalizedDocumentValidationResult.from(result).message(context);
  }
}

class _RadioButtonForm extends FormField<String> {
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final List<String> items;

  _RadioButtonForm({
    required this.items,
    required this.onChanged,
    required this.selectedValue,
    super.enabled,
    super.validator,
    AutovalidateMode autovalidateMode = AutovalidateMode.always,
  }) : super(
          initialValue: selectedValue,
          autovalidateMode: autovalidateMode,
          builder: (field) {
            final state = field as _RadioButtonFormState;
            void onChangedHandler(String? selected) {
              field.didChange(selected);
              onChanged?.call(selected);
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RadioButtonList(
                  enabled: enabled,
                  items: items,
                  onChanged: onChangedHandler,
                  value: state._internalValue,
                ),
                if (field.hasError)
                  _ErrorText(
                    errorText: field.errorText,
                  ),
              ],
            );
          },
        );

  @override
  FormFieldState<String> createState() => _RadioButtonFormState();
}

class _RadioButtonList extends StatelessWidget {
  final bool enabled;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? value;
  const _RadioButtonList({
    required this.enabled,
    required this.items,
    this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map<Widget>(
              (e) => VoicesRadio<String>(
                key: ValueKey(e),
                value: e,
                label: Text(
                  e,
                  style: getStyle(context, e),
                ),
                groupValue: value,
                onChanged: onChanged,
              ),
            )
            .separatedBy(const SizedBox(height: 10))
            .toList(),
      ),
    );
  }

  TextStyle? getStyle(BuildContext context, String? itemValue) {
    final textStyle = context.textTheme.bodyLarge;
    if (enabled || value == itemValue) {
      return textStyle;
    }
    return textStyle?.copyWith(
      color: context.colors.textDisabled,
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String? errorText;

  const _ErrorText({
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        errorText ?? context.l10n.snackbarErrorLabelText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}

class _RadioButtonFormState extends FormFieldState<String> {
  String? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(_RadioButtonForm oldWidget) {
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
