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
  late bool? selectedValue;

  String get _description => widget.schema.formattedDescription;

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
        if (_description.isNotEmpty) ...[
          Text(
            _description,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
        ],
        _YesNoChoiceSegmentButton(
          context,
          value: selectedValue,
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
    selectedValue = widget.property.value;
  }

  void _handleValueChanged(bool? value) {
    setState(() {
      selectedValue = value;
    });
    if (value == null && widget.property.value != value) {
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

  _YesNoChoiceSegmentButton(
    BuildContext context, {
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
                        label: Text(context.l10n.yes),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text(context.l10n.no),
                      ),
                    ],
                    selected: value != null ? {value} : {},
                    onChanged: onChangedHandler,
                    emptySelectionAllowed: true,
                    style: _getButtonStyle(field),
                  ),
                ),
                if (field.hasError)
                  Text(
                    field.errorText ?? context.l10n.snackbarErrorLabelText,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
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
}
