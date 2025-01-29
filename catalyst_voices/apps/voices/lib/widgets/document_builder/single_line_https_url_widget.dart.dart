import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/text_field/voices_https_text_field.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SingleLineHttpsUrlWidget extends StatefulWidget {
  final DocumentValueProperty<String> property;
  final DocumentStringSchema schema;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const SingleLineHttpsUrlWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<SingleLineHttpsUrlWidget> createState() =>
      _SingleLineHttpsUrlWidgetState();
}

class _SingleLineHttpsUrlWidgetState extends State<SingleLineHttpsUrlWidget> {
  late final TextEditingController _textEditingController;
  late final FocusNode _focusNode;

  String get _title => widget.schema.formattedTitle;

  @override
  void initState() {
    super.initState();

    final textValue =
        TextEditingValueExt.collapsedAtEndOf(widget.property.value ?? '');

    _textEditingController = TextEditingController.fromValue(textValue)
      ..addListener(_handleControllerChange);

    _focusNode = FocusNode(canRequestFocus: widget.isEditMode);
  }

  @override
  void didUpdateWidget(covariant SingleLineHttpsUrlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isEditMode != widget.isEditMode &&
        widget.isEditMode == false) {
      _textEditingController.textWithSelection = widget.property.value ?? '';
    }

    if (widget.isEditMode != oldWidget.isEditMode) {
      _handleEditModeChanged();
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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
        VoicesHttpsTextField(
          controller: _textEditingController,
          focusNode: _focusNode,
          onFieldSubmitted: _notifyChangeListener,
          validator: _validate,
          enabled: widget.isEditMode,
        ),
      ],
    );
  }

  void _handleControllerChange() {
    final controllerValue = _textEditingController.text;
    if (widget.property.value != controllerValue &&
        controllerValue.isNotEmpty) {
      _notifyChangeListener(controllerValue);
    }
  }

  void _notifyChangeListener(String? value) {
    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: value,
    );

    widget.onChanged([change]);
  }

  VoicesTextFieldValidationResult _validate(String? value) {
    if (value == null || value.isEmpty) {
      return const VoicesTextFieldValidationResult.none();
    }
    final schema = widget.schema;
    final result = schema.validate(value);
    if (result.isValid) {
      return const VoicesTextFieldValidationResult.success();
    } else {
      final localized = LocalizedDocumentValidationResult.from(result);
      return VoicesTextFieldValidationResult.error(localized.message(context));
    }
  }

  void _handleEditModeChanged() {
    _focusNode.canRequestFocus = widget.isEditMode;

    if (widget.isEditMode) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }
}
