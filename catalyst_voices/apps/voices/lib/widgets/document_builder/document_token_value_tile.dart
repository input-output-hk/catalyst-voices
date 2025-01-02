import 'package:catalyst_voices/widgets/document_builder/common/document_property_footer.dart';
import 'package:catalyst_voices/widgets/document_builder/common/document_property_top_bar.dart';
import 'package:catalyst_voices/widgets/text_field/token_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_int_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices/widgets/tiles/selectable_tile.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class DocumentTokenValueTile extends StatefulWidget {
  final DocumentNodeId id;
  final String title;
  final String description;
  final int? initialValue;
  final Currency currency;
  final Range<int>? range;
  final bool isSelected;
  final bool isRequired;
  final ValueChanged<DocumentChange> onChanged;

  const DocumentTokenValueTile({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    this.initialValue,
    required this.currency,
    this.range,
    this.isSelected = false,
    this.isRequired = true,
    required this.onChanged,
  });

  @override
  State<DocumentTokenValueTile> createState() {
    return _DocumentTokenValueTileState();
  }
}

class _DocumentTokenValueTileState extends State<DocumentTokenValueTile> {
  late final VoicesIntFieldController _controller;
  late final FocusNode _focusNode;

  bool _isEditMode = false;
  bool _isValid = false;
  int? _value;

  @override
  void initState() {
    _controller = VoicesIntFieldController(widget.initialValue);
    _focusNode = FocusNode(canRequestFocus: _isEditMode);
    _value = widget.initialValue;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var tokenFieldLabel = widget.title;
    if (widget.isRequired) {
      tokenFieldLabel = '*$tokenFieldLabel';
    }

    return SelectableTile(
      isSelected: widget.isSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DocumentPropertyTopBar(
              isEditMode: _isEditMode,
              onToggleEditMode: _toggleEditMode,
              title: widget.description,
            ),
            const SizedBox(height: 22),
            TokenField(
              controller: _controller,
              focusNode: _focusNode,
              onFieldSubmitted: _handleSubmitted,
              onStatusChanged: _handleStatusChange,
              labelText: tokenFieldLabel,
              range: widget.range,
              currency: widget.currency,
              showHelper: _isEditMode,
              readOnly: !_isEditMode,
            ),
            if (_isEditMode) ...[
              const SizedBox(height: 12),
              DocumentPropertyFooter(
                onSave: _isValid ? _saveChanges : null,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _handleStatusChange(VoicesTextFieldStatus status) {
    final isError = status == VoicesTextFieldStatus.error;
    final hasValue = _controller.value != null;

    final isValid = !isError && hasValue;

    if (_isValid != isValid) {
      setState(() {
        _isValid = isValid;
      });
    }
  }

  void _handleSubmitted(int? value) {
    if (_isValid) {
      _saveChanges();
    }
  }

  void _saveChanges() {
    setState(() {
      _value = _controller.value;
      _isEditMode = false;
      _focusNode.canRequestFocus = false;

      final change = DocumentChange(nodeId: widget.id, value: _value);
      widget.onChanged(change);
    });
  }

  void _toggleEditMode() {
    setState(() {
      final mode = !_isEditMode;

      if (mode) {
        // save last value
        _value = _controller.value;

        _focusNode
          ..canRequestFocus = true
          ..requestFocus();
      } else {
        // restore previous value
        _controller.value = _value;

        _focusNode
          ..canRequestFocus = false
          ..unfocus();
      }

      _isEditMode = mode;
    });
  }
}
