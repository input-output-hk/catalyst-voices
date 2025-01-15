import 'package:catalyst_voices/common/ext/document_property_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleTextEntryWidget extends StatefulWidget {
  final DocumentProperty<String> property;
  final bool isEditMode;
  final ValueChanged<DocumentChange> onChanged;

  const SimpleTextEntryWidget({
    super.key,
    required this.property,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<SimpleTextEntryWidget> createState() => _SimpleTextEntryWidgetState();
}

class _SimpleTextEntryWidgetState extends State<SimpleTextEntryWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  String get _description => widget.property.formattedDescription;
  int? get _maxLength => widget.property.schema.strLengthRange?.max;
  bool get _resizable =>
      widget.property.schema.definition is MultiLineTextEntryDefinition;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.property.value);
    _controller.addListener(_handleValueChange);
    _focusNode = FocusNode(canRequestFocus: widget.isEditMode);
  }

  @override
  void didUpdateWidget(SimpleTextEntryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isEditMode != widget.isEditMode) {
      _handleEditModeChanged();
      if (!widget.isEditMode) {
        _controller.text = widget.property.value ?? '';
      }
    }

    if (widget.property.value != oldWidget.property.value) {
      _controller.text = widget.property.value ?? '';
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
        _SimpleDocumentTextField(
          controller: _controller,
          focusNode: _focusNode,
          onFieldSubmitted: _notifyChangeListener,
          validator: _validate,
          enabled: widget.isEditMode,
          // TODO(ryszard-schossler): check if this is right after schema is finalized
          hintText: widget.property.schema.defaultValue,
          resizable: _resizable,
          maxLength: _maxLength,
        ),
      ],
    );
  }

  void _handleEditModeChanged() {
    _focusNode.canRequestFocus = widget.isEditMode;

    if (widget.isEditMode) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }

  void _handleValueChange() {
    final controllerValue = _controller.text;
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
    if (!widget.isEditMode) {
      return const VoicesTextFieldValidationResult.none();
    }
    final schema = widget.property.schema;
    final result = schema.validatePropertyValue(value);
    if (result.isValid) {
      return const VoicesTextFieldValidationResult.none();
    } else {
      final localized = LocalizedDocumentValidationResult.from(result);
      return VoicesTextFieldValidationResult.error(localized.message(context));
    }
  }
}

class _SimpleDocumentTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onFieldSubmitted;
  final VoicesTextFieldValidator? validator;
  final FocusNode? focusNode;
  final String? hintText;
  final bool enabled;
  final bool resizable;
  final int? maxLength;

  const _SimpleDocumentTextField({
    this.controller,
    this.onFieldSubmitted,
    this.validator,
    this.focusNode,
    this.hintText,
    this.enabled = false,
    this.resizable = false,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTextField(
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      decoration: VoicesTextFieldDecoration(
        hintText: hintText,
      ),
      enabled: enabled,
      resizable: resizable,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      autovalidateMode: AutovalidateMode.disabled,
      maxLines: resizable ? null : 1,
      maxLength: maxLength,
    );
  }
}
