import 'package:catalyst_voices/widgets/document_builder/document_error_text.dart';
import 'package:catalyst_voices/widgets/form/voices_form_field.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class AgreementConfirmationWidget extends StatefulWidget {
  final DocumentValueProperty<bool> property;
  final DocumentAgreementConfirmationSchema schema;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const AgreementConfirmationWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<AgreementConfirmationWidget> createState() =>
      _AgreementConfirmationWidgetState();
}

class _AgreementConfirmationWidgetState
    extends State<AgreementConfirmationWidget> {
  bool? get _value => widget.property.value ?? widget.schema.defaultValue;

  @override
  Widget build(BuildContext context) {
    return _AgreementConfirmationFormField(
      value: _value,
      onChanged: _onChanged,
      validator: _validator,
      readOnly: !widget.isEditMode,
      description: widget.schema.description ?? MarkdownData.empty,
    );
  }

  void _onChanged(bool? value) {
    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: value,
    );

    widget.onChanged([change]);
  }

  String? _validator(bool? value) {
    final result = widget.schema.validate(value);

    return LocalizedDocumentValidationResult.from(result).message(context);
  }
}

class _AgreementConfirmationFormField extends VoicesFormField<bool> {
  _AgreementConfirmationFormField({
    required super.value,
    required super.onChanged,
    super.readOnly,
    super.validator,
    required MarkdownData description,
  }) : super(
          builder: (field) {
            final context = field.context;
            final value = field.value ?? false;

            // ignore: avoid_positional_boolean_parameters
            void onChangedHandler(bool? value) {
              field.didChange(value);
              onChanged?.call(value);
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (description.data.isNotEmpty) ...[
                  MarkdownText(description),
                  const SizedBox(height: 22),
                ],
                VoicesCheckbox(
                  value: value,
                  onChanged: onChangedHandler,
                  isEnabled: !readOnly,
                  isError: field.hasError,
                  label: Text(
                    context.l10n.agree,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: readOnly && !value
                              ? Theme.of(context).colors.textDisabled
                              : null,
                        ),
                  ),
                ),
                if (field.hasError) DocumentErrorText(text: field.errorText),
              ],
            );
          },
        );
}
