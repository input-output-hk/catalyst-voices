import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SimpleTextEntryWidget extends StatefulWidget {
  final DocumentValueProperty<String> property;
  final DocumentStringSchema schema;
  final bool isEditMode;
  final ValueChanged<List<DocumentChange>> onChanged;

  const SimpleTextEntryWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.isEditMode,
    required this.onChanged,
  });

  @override
  State<SimpleTextEntryWidget> createState() => _SimpleTextEntryWidgetState();
}

class _SimpleTextEntryWidgetState extends State<SimpleTextEntryWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  String get _title => widget.schema.title;
  bool get _isRequired => widget.schema.isRequired;
  int? get _maxLength => widget.schema.strLengthRange?.max;
  bool get _resizable => widget.schema is DocumentMultiLineTextEntrySchema;

  @override
  void initState() {
    super.initState();

    final textValue =
        TextEditingValueExt.collapsedAtEndOf(widget.property.value ?? '');

    _controller = TextEditingController.fromValue(textValue)
      ..addListener(_handleValueChange);

    _focusNode = FocusNode(canRequestFocus: widget.isEditMode);
  }

  @override
  void didUpdateWidget(SimpleTextEntryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isEditMode != widget.isEditMode) {
      _handleEditModeChanged();
      if (!widget.isEditMode) {
        _controller.textWithSelection = widget.property.value ?? '';
      }
    }

    if (widget.property.value != oldWidget.property.value) {
      _controller.textWithSelection = widget.property.value ?? '';
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
        if (_title.isNotEmpty) ...[
          Text(
            _title.starred(isEnabled: _isRequired),
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
          hintText: widget.schema.placeholder,
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
    final normalizedValue = widget.schema.normalizeValue(value);
    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: normalizedValue,
    );
    widget.onChanged([change]);
  }

  VoicesTextFieldValidationResult _validate(String? value) {
    final schema = widget.schema;
    final normalizedValue = schema.normalizeValue(value);
    final result = schema.validate(normalizedValue);
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
      textValidator: validator,
      decoration: VoicesTextFieldDecoration(
        hintText: hintText,
      ),
      enabled: enabled,
      resizableVertically: resizable,
      resizableHorizontally: false,
      maxLengthEnforcement: MaxLengthEnforcement.none,
      maxLines: resizable ? null : 1,
      maxLength: maxLength,
    );
  }
}
