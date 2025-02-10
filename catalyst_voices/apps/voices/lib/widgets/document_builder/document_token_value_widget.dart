import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
import 'package:catalyst_voices/widgets/text_field/token_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_int_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class DocumentTokenValueWidget extends StatefulWidget {
  final DocumentValueProperty<int> property;
  final DocumentIntegerSchema schema;
  final Currency currency;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const DocumentTokenValueWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.currency,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<DocumentTokenValueWidget> createState() {
    return _DocumentTokenValueWidgetState();
  }
}

class _DocumentTokenValueWidgetState extends State<DocumentTokenValueWidget> {
  late final VoicesIntFieldController _controller;
  late final FocusNode _focusNode;

  int? get _value => widget.property.value ?? widget.schema.defaultValue;

  @override
  void initState() {
    super.initState();

    _controller = VoicesIntFieldController(_value);
    _focusNode = FocusNode(canRequestFocus: widget.isEditMode);
  }

  @override
  void didUpdateWidget(DocumentTokenValueWidget oldWidget) {
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
  Widget build(BuildContext context) {
    final schema = widget.schema;

    return TokenField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: _onChanged,
      onFieldSubmitted: _onChanged,
      validator: _validator,
      labelText: schema.title.isEmpty ? null : schema.formattedTitle,
      range: schema.numRange,
      currency: widget.currency,
      showHelper: widget.isEditMode,
      enabled: widget.isEditMode,
      ignorePointers: !widget.isEditMode,
    );
  }

  void _onEditModeChanged() {
    _focusNode.canRequestFocus = widget.isEditMode;

    if (widget.isEditMode) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }

  void _onChanged(int? value) {
    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: value,
    );

    widget.onChanged([change]);
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
