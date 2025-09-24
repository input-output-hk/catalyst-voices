import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
import 'package:catalyst_voices/widgets/text_field/voices_int_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// A fallback for [DocumentGenericIntegerSchema] if no other widget matched this schema.
class IntegerValueWidget extends StatefulWidget {
  final DocumentValueProperty<int> property;
  final DocumentIntegerSchema schema;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const IntegerValueWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<IntegerValueWidget> createState() {
    return _IntegerValueWidgetState();
  }
}

class _IntegerValueWidgetState extends State<IntegerValueWidget> {
  late final VoicesIntFieldController _controller;
  late final FocusNode _focusNode;

  int? get _value => widget.property.value ?? widget.schema.defaultValue;

  @override
  Widget build(BuildContext context) {
    final schema = widget.schema;
    final range = schema.numRange;

    return VoicesIntField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: _onChanged,
      onFieldSubmitted: _onChanged,
      validator: _validator,
      decoration: VoicesTextFieldDecoration(
        labelText: schema.title.isEmpty ? null : schema.formattedTitle,
        hintText: range != null && range.min != null ? '${range.min}' : null,
        helperText: schema.placeholder,
        labelStyle: context.textTheme.labelLarge?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
        ),
      ),
      enabled: widget.isEditMode,
      ignorePointers: !widget.isEditMode,
    );
  }

  @override
  void didUpdateWidget(IntegerValueWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldValue = oldWidget.property.value ?? oldWidget.schema.defaultValue;
    final newValue = widget.property.value ?? widget.schema.defaultValue;

    if (oldValue != newValue) {
      _controller.value = newValue;
    }

    if (widget.isEditMode != oldWidget.isEditMode) {
      _onEditModeChanged();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = VoicesIntFieldController(_value);
    _focusNode = FocusNode(canRequestFocus: widget.isEditMode);
  }

  void _onChanged(int? value) {
    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: value,
    );

    widget.onChanged([change]);
  }

  void _onEditModeChanged() {
    _focusNode.canRequestFocus = widget.isEditMode;

    if (widget.isEditMode) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }

  VoicesTextFieldValidationResult _validator(int? value, String text) {
    final result = widget.schema.validate(value);
    if (result.isValid) {
      return const VoicesTextFieldValidationResult.none();
    } else {
      final localized = LocalizedDocumentValidationResult.from(result);
      return VoicesTextFieldValidationResult.error(localized.message(context));
    }
  }
}
