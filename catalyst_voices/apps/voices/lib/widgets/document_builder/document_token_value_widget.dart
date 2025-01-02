import 'package:catalyst_voices/pages/proposal_builder/elements/token_field.dart';
import 'package:catalyst_voices/widgets/document_builder/document_property_footer.dart';
import 'package:catalyst_voices/widgets/document_builder/document_property_topbar.dart';
import 'package:catalyst_voices/widgets/text_field/voices_int_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class DocumentTokenValueWidget extends StatefulWidget {
  final String title;
  final String description;
  final int? initialValue;
  final Currency currency;
  final Range<int>? range;
  final bool isRequired;

  // TODO(damian-molinski): Change to DocumentChange
  final ValueChanged<int?> onChanged;

  const DocumentTokenValueWidget({
    required super.key,
    required this.title,
    required this.description,
    this.initialValue,
    required this.currency,
    this.range,
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

  bool _editMode = false;
  bool _isValid = false;
  int? _value;

  @override
  void initState() {
    _controller = VoicesIntFieldController(widget.initialValue);
    _focusNode = FocusNode(canRequestFocus: _editMode);
    _value = widget.initialValue;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;

    var tokenFieldLabel = widget.title;
    if (widget.isRequired) {
      tokenFieldLabel = '*$tokenFieldLabel';
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.elevationsOnSurfaceNeutralLv1White,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DocumentPropertyTopbar(
              isEditMode: _editMode,
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
              readOnly: !_editMode,
            ),
            Offstage(
              offstage: !_editMode,
              child: DocumentPropertyFooter(
                onSave: _isValid ? _saveChanges : null,
              ),
            ),
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
      _editMode = false;
      _focusNode.canRequestFocus = false;

      widget.onChanged(_value);
    });
  }

  void _toggleEditMode() {
    setState(() {
      final mode = !_editMode;

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

      _editMode = mode;
    });
  }
}
