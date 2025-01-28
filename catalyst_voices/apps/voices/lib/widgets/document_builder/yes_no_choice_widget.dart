import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class YesNoChoiceWidget extends StatefulWidget {
  final DocumentValueProperty<bool> property;
  final DocumentYesNoChoiceSchema schema;
  final ValueChanged<DocumentChange> onChanged;
  final bool isEditMode;

  const YesNoChoiceWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.onChanged,
    required this.isEditMode,
  });

  @override
  State<YesNoChoiceWidget> createState() => _YesNoChoiceWidgetState();
}

class _YesNoChoiceWidgetState extends State<YesNoChoiceWidget> {
  late bool? _selectedValue;

  String get _title => widget.schema.formattedTitle;

  @override
  void initState() {
    super.initState();

    _handleInitialValue();
  }

  @override
  void didUpdateWidget(covariant YesNoChoiceWidget oldWidget) {
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_title.isNotEmpty) ...[
          Text(
            _title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
        ],
        _YesNoChoiceSegmentButton(
          value: _selectedValue,
          enabled: widget.isEditMode,
          onChanged: _handleValueChanged,
          validator: (value) {
            final result = widget.schema.validate(value);

            return LocalizedDocumentValidationResult.from(result)
                .message(context);
          },
        ),
      ],
    );
  }

  void _handleInitialValue() {
    _selectedValue = widget.property.value;
  }

  void _handleValueChanged(bool? value) {
    setState(() {
      _selectedValue = value;
    });

    if (widget.property.value != value) {
      _notifyChangeListener(value);
    }
  }

  void _notifyChangeListener(bool? value) {
    widget.onChanged(
      DocumentValueChange(
        nodeId: widget.schema.nodeId,
        value: value,
      ),
    );
  }
}

class _YesNoChoiceSegmentButton extends FormField<bool?> {
  final bool? value;
  final ValueChanged<bool?>? onChanged;

  _YesNoChoiceSegmentButton({
    super.key,
    required this.value,
    required this.onChanged,
    super.validator,
    super.enabled,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
  }) : super(
          initialValue: value,
          autovalidateMode: autovalidateMode,
          builder: (field) {
            final state = field as _YesNoChoiceSegmentButtonState;
            void onChangedHandler(Set<bool> selected) {
              final newValue = selected.isEmpty ? null : selected.first;
              field.didChange(newValue);
              onChanged?.call(newValue);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IgnorePointer(
                  ignoring: !enabled,
                  child: VoicesSegmentedButton<bool>(
                    key: key,
                    segments: [
                      ButtonSegment(
                        value: true,
                        label: Text(field.context.l10n.yes),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text(field.context.l10n.no),
                      ),
                    ],
                    selected: state._internalValue != null
                        ? {state._internalValue!}
                        : {},
                    onChanged: onChangedHandler,
                    emptySelectionAllowed: true,
                    style: _getButtonStyle(field),
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

  static ButtonStyle? _getButtonStyle(FormFieldState<bool?> field) {
    if (field.errorText == null) return null;

    return ButtonStyle(
      side: WidgetStatePropertyAll(
        BorderSide(
          color: Theme.of(field.context).colorScheme.error,
        ),
      ),
    );
  }

  @override
  FormFieldState<bool?> createState() => _YesNoChoiceSegmentButtonState();
}

class _YesNoChoiceSegmentButtonState extends FormFieldState<bool?> {
  bool? _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(_YesNoChoiceSegmentButton oldWidget) {
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
