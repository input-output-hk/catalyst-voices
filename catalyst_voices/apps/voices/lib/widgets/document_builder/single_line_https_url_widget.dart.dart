import 'package:catalyst_voices/widgets/text_field/voices_https_text_field.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SingleLineHttpsUrlWidget extends StatefulWidget {
  final DocumentProperty<String> property;
  final String description;
  final bool isEditMode;
  final ValueChanged<DocumentChange> onChanged;
  const SingleLineHttpsUrlWidget({
    super.key,
    required this.property,
    required this.description,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<SingleLineHttpsUrlWidget> createState() =>
      _SingleLineHttpsUrlWidgetState();
}

class _SingleLineHttpsUrlWidgetState extends State<SingleLineHttpsUrlWidget> {
  late TextEditingController _textEditingController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    final value = widget.property.value;
    if (value != null) {
      _textEditingController.text = value;
    }
    _textEditingController.addListener(_handleControllerChange);
    _focusNode = FocusNode(canRequestFocus: widget.isEditMode);
  }

  @override
  void didUpdateWidget(covariant SingleLineHttpsUrlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isEditMode != widget.isEditMode &&
        widget.isEditMode == false) {
      _textEditingController.text = widget.property.value ?? '';
    }

    if (widget.isEditMode != oldWidget.isEditMode) {
      _handleEditModeChanged();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final description = widget.property.schema.description ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (description.isNotEmpty) ...[
          Text(
            description,
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
    final change = DocumentChange(
      nodeId: widget.property.schema.nodeId,
      value: value,
    );

    widget.onChanged(change);
  }

  VoicesTextFieldValidationResult _validate(String? value) {
    if (value == null || value.isEmpty) {
      return const VoicesTextFieldValidationResult.none();
    }
    final schema = widget.property.schema;
    final result = schema.validatePropertyValue(value);
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
