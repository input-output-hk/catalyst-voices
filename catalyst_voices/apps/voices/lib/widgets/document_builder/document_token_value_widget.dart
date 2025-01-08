import 'package:catalyst_voices/common/ext/string_ext.dart';
import 'package:catalyst_voices/widgets/text_field/token_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_int_field.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class DocumentTokenValueWidget extends StatefulWidget {
  final DocumentNodeId id;
  final String label;
  final int? value;
  final Currency currency;
  final Range<int>? range;
  final bool isEditMode;
  final bool isRequired;
  final ValueChanged<DocumentChange> onChanged;

  const DocumentTokenValueWidget({
    super.key,
    required this.id,
    required this.label,
    this.value,
    required this.currency,
    this.range,
    this.isEditMode = false,
    this.isRequired = true,
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

  @override
  void initState() {
    super.initState();

    _controller = VoicesIntFieldController(widget.value);
    _controller.addListener(_handleControllerChange);
    _focusNode = FocusNode(canRequestFocus: widget.isEditMode);
  }

  @override
  void didUpdateWidget(covariant DocumentTokenValueWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      _controller.value = widget.value;
    }

    if (widget.isEditMode != oldWidget.isEditMode) {
      _handleEditModeChanged();
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
    return TokenField(
      controller: _controller,
      focusNode: _focusNode,
      onFieldSubmitted: _notifyChangeListener,
      labelText: widget.label.starred(isEnabled: widget.isRequired),
      range: widget.range,
      currency: widget.currency,
      showHelper: widget.isEditMode,
      readOnly: !widget.isEditMode,
      ignorePointers: !widget.isEditMode,
    );
  }

  void _handleControllerChange() {
    final value = _controller.value;
    _notifyChangeListener(value);
  }

  void _handleEditModeChanged() {
    _focusNode.canRequestFocus = widget.isEditMode;

    if (widget.isEditMode) {
      _focusNode.requestFocus();
    } else {
      _focusNode.unfocus();
    }
  }

  void _notifyChangeListener(int? value) {
    final change = DocumentChange(nodeId: widget.id, value: value);
    widget.onChanged(change);
  }
}
