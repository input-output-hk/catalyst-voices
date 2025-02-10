import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/document_builder/document_error_text.dart';
import 'package:catalyst_voices/widgets/form/voices_form_field.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class YesNoChoiceWidget extends StatefulWidget {
  final DocumentValueProperty<bool> property;
  final DocumentBooleanSchema schema;
  final ValueChanged<List<DocumentChange>> onChanged;
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
  bool? get _value => widget.property.value ?? widget.schema.defaultValue;
  String get _title => widget.schema.title;
  bool get _isRequired => widget.schema.isRequired;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_title.isNotEmpty) ...[
          Text(
            _title.starred(isEnabled: _isRequired),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
        ],
        _YesNoChoiceSegmentButton(
          value: _value,
          enabled: widget.isEditMode,
          onChanged: _onChanged,
          validator: _validate,
        ),
      ],
    );
  }

  void _onChanged(bool? value) {
    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: value,
    );
    widget.onChanged([change]);
  }

  String? _validate(bool? value) {
    final result = widget.schema.validate(value);
    return LocalizedDocumentValidationResult.from(result).message(context);
  }
}

class _YesNoChoiceSegmentButton extends VoicesFormField<bool?> {
  _YesNoChoiceSegmentButton({
    super.key,
    required super.value,
    required super.onChanged,
    super.enabled,
    super.validator,
  }) : super(
          builder: (field) {
            final state = field as VoicesFormFieldState<bool?>;
            final value = state.value;

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
                    selected: {
                      if (value != null) value,
                    },
                    onChanged: onChangedHandler,
                    emptySelectionAllowed: true,
                    style: _getButtonStyle(field),
                  ),
                ),
                if (field.hasError) ...[
                  const SizedBox(height: 4),
                  DocumentErrorText(text: field.errorText),
                ],
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
