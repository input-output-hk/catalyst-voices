import 'package:catalyst_voices/common/ext/string_ext.dart';
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

  String get _value =>
      widget.property.value ?? widget.schema.defaultValue ?? '';
  String get _title => widget.schema.title;
  bool get _isRequired => widget.schema.isRequired;

  @override
  void initState() {
    super.initState();

    final textValue = TextEditingValueExt.collapsedAtEndOf(_value);

    _textEditingController = TextEditingController.fromValue(textValue)
      ..addListener(_handleControllerChange);

    _focusNode = FocusNode(canRequestFocus: widget.isEditMode);
  }

  @override
  void didUpdateWidget(SingleLineHttpsUrlWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isEditMode != widget.isEditMode &&
        widget.isEditMode == false) {
      _textEditingController.textWithSelection = _value;
    }

    if (widget.isEditMode != oldWidget.isEditMode) {
      _onEditModeChanged();
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
            _title.starred(isEnabled: _isRequired),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
        ],
        VoicesHttpsTextField(
          controller: _textEditingController,
          focusNode: _focusNode,
          
          onFieldSubmitted: _notifyChangeListener,
          validator: _validator,
          enabled: widget.isEditMode,
        ),
      ],
    );
  }

  void _handleControllerChange() {
    final oldValue = widget.property.value;
    final newValue = _textEditingController.text;
    if (oldValue != newValue) {
      _notifyChangeListener(newValue);
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

  VoicesTextFieldValidationResult _validator(String? value) {
    final schema = widget.schema;
    final normalizedValue = schema.normalizeValue(value);
    final result = schema.validate(normalizedValue);
    if (result.isValid) {
      if (normalizedValue == null) {
        return const VoicesTextFieldValidationResult.none();
      } else {
        return const VoicesTextFieldValidationResult.success();
      }
    } else {
      final localized = LocalizedDocumentValidationResult.from(result);
      return VoicesTextFieldValidationResult.error(localized.message(context));
    }
  }

  void _onEditModeChanged() {
    _focusNode.canRequestFocus = widget.isEditMode;

    if (widget.isEditMode) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }
}
