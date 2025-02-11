import 'package:catalyst_voices/common/codecs/markdown_codec.dart';
import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class MultilineTextEntryMarkdownWidget extends StatefulWidget {
  final DocumentValueProperty<String> property;
  final DocumentMultiLineTextEntryMarkdownSchema schema;
  final ValueChanged<List<DocumentChange>> onChanged;
  final bool isEditMode;

  const MultilineTextEntryMarkdownWidget({
    super.key,
    required this.property,
    required this.schema,
    required this.onChanged,
    required this.isEditMode,
  });

  @override
  State<MultilineTextEntryMarkdownWidget> createState() =>
      _MultilineTextEntryMarkdownWidgetState();
}

class _MultilineTextEntryMarkdownWidgetState
    extends State<MultilineTextEntryMarkdownWidget> {
  late final VoicesRichTextController _controller;
  late final VoicesRichTextFocusNode _focus;
  late final ScrollController _scrollController;
  late final Debouncer _onChangedDebouncer;

  String get _title => widget.schema.formattedTitle;
  int? get _maxLength => widget.schema.strLengthRange?.max;

  @override
  void initState() {
    super.initState();

    _controller = _buildController(widget.property.value ?? '');
    _focus = VoicesRichTextFocusNode();
    _scrollController = ScrollController();
    _onChangedDebouncer = Debouncer();
  }

  @override
  void didUpdateWidget(MultilineTextEntryMarkdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isEditMode != oldWidget.isEditMode) {
      _focus.toggleFocus(enabled: widget.isEditMode);
      _controller.readOnly = !widget.isEditMode;
      _toggleEditMode();
    }

    if (widget.property.value != oldWidget.property.value) {
      _updateContents(widget.property.value ?? '');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    _scrollController.dispose();
    _onChangedDebouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VoicesRichText(
      controller: _controller,
      enabled: widget.isEditMode,
      title: _title,
      focusNode: _focus,
      scrollController: _scrollController,
      charsLimit: _maxLength,
      onChanged: _onChanged,
      validator: _validator,
    );
  }

  VoicesRichTextController _buildController(String value) {
    final quill.Document document;
    if (value.isNotEmpty) {
      final input = MarkdownData(value);
      final delta = markdown.encoder.convert(input);
      document = quill.Document.fromDelta(delta);
    } else {
      document = quill.Document();
    }

    return VoicesRichTextController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  void _updateContents(String value) {
    if (value.isNotEmpty) {
      final input = MarkdownData(value);
      final delta = markdown.encoder.convert(input);

      _controller.replaceText(
        0,
        _controller.document.length,
        delta,
        _controller.document.length <= value.length
            ? null
            : TextSelection.collapsed(offset: value.length),
        shouldNotifyListeners: false,
      );
    } else {
      _controller.clear();
    }
  }

  void _toggleEditMode() {
    _controller.readOnly = !widget.isEditMode;
  }

  void _onChanged(quill.Document? document) {
    _onChangedDebouncer.run(() => _dispatchChange(document));
  }

  void _dispatchChange(quill.Document? document) {
    final delta = document?.toDelta();
    final markdownData = delta != null ? markdown.decoder.convert(delta) : null;
    final value = markdownData?.data;
    final normalizedValue = widget.schema.normalizeValue(value);

    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: normalizedValue,
    );

    widget.onChanged([change]);
  }

  String? _validator(quill.Document? document) {
    final delta = document?.toDelta();
    final markdownData = delta != null ? markdown.decoder.convert(delta) : null;
    final markdownValue = markdownData?.data;
    final normalizedValue = widget.schema.normalizeValue(markdownValue);

    final error = widget.schema.validate(normalizedValue);
    return LocalizedDocumentValidationResult.from(error).message(context);
  }
}

/// This focus helps to interact with [VoicesRichText] widget
/// When widget is not in edit mode this focus allows user to interact with
/// links and other elements that are inside of the textfield..
class VoicesRichTextFocusNode extends FocusNode {
  bool _disableFocus = true;

  // Can't request focus when disabled
  @override
  bool get canRequestFocus => !_disableFocus;

  @override
  bool get hasFocus => !_disableFocus && (hasPrimaryFocus);

  void allowFocus() => _disableFocus = false;
  void disableFocus() => _disableFocus = true;

  void toggleFocus({required bool enabled}) {
    enabled ? allowFocus() : disableFocus();
  }
}
