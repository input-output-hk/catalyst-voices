import 'package:catalyst_voices/common/ext/document_property_ext.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class MultilineTextEntryMarkdownWidget extends StatefulWidget {
  final DocumentProperty<String> property;
  final ValueChanged<DocumentChange> onChanged;
  final bool isEditMode;
  final bool isRequired;

  const MultilineTextEntryMarkdownWidget({
    super.key,
    required this.property,
    required this.onChanged,
    required this.isEditMode,
    required this.isRequired,
  });

  @override
  State<MultilineTextEntryMarkdownWidget> createState() =>
      _MultilineTextEntryMarkdownWidgetState();
}

class _MultilineTextEntryMarkdownWidgetState
    extends State<MultilineTextEntryMarkdownWidget> {
  late VoicesRichTextEditModeController _editModeController;
  late VoicesRichTextController _controller;

  String get _description => widget.property.formattedDescription;
  int? get _maxLength => widget.property.schema.strLengthRange?.max;

  @override
  void initState() {
    super.initState();

    _controller = VoicesRichTextController(
      document: quill.Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );
    _editModeController = VoicesRichTextEditModeController(widget.isEditMode);
  }

  @override
  void didUpdateWidget(covariant MultilineTextEntryMarkdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isEditMode != oldWidget.isEditMode) {
      _editModeController.value = widget.isEditMode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return VoicesRichText(
      controller: _controller,
      editModeController: _editModeController,
      title: _description,
      charsLimit: _maxLength,
    );
  }
}
