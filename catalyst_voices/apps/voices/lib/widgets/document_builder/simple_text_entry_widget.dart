import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
  late final Debouncer _onChangedDebouncer;

  String get _title => widget.schema.title;
  bool get _isRequired => widget.schema.isRequired;
  int? get _maxLength => widget.schema.strLengthRange?.max;
  bool get _resizable => widget.schema is DocumentMultiLineTextEntrySchema;

  @override
  void initState() {
    super.initState();

    final textValue =
        TextEditingValueExt.collapsedAtEndOf(widget.property.value ?? '');

    _controller = TextEditingController.fromValue(textValue);
    _focusNode = FocusNode(canRequestFocus: widget.isEditMode);
    _onChangedDebouncer = Debouncer();
  }

  @override
  void didUpdateWidget(SimpleTextEntryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isEditMode != widget.isEditMode) {
      _onEditModeChanged();
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
    _onChangedDebouncer.dispose();
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
        VoicesTextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onChanged,
          onFieldSubmitted: _onChanged,
          textValidator: _validator,
          decoration: VoicesTextFieldDecoration(
            hintText: widget.schema.placeholder,
          ),
          enabled: widget.isEditMode,
          resizableVertically: false,
          resizableHorizontally: false,
          maxLengthEnforcement: MaxLengthEnforcement.none,
          maxLines: _resizable ? null : 1,
          maxLength: _maxLength,
        ),
      ],
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

  void _onChanged(String? value) {
    _onChangedDebouncer.run(() => _dispatchChange(value));
  }

  void _dispatchChange(String? value) {
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
      return const VoicesTextFieldValidationResult.none();
    } else {
      final localized = LocalizedDocumentValidationResult.from(result);
      return VoicesTextFieldValidationResult.error(localized.message(context));
    }
  }
}
