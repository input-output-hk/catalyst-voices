import 'dart:async';

import 'package:catalyst_voices/common/codecs/markdown_codec.dart';
import 'package:catalyst_voices/common/ext/document_property_schema_ext.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

// TODO(dtscalac): convert to form field !!!
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
  late VoicesRichTextController _controller;
  late final VoicesRichTextFocusNode _focus;
  late final ScrollController _scrollController;

  quill.Document? _observedDocument;
  StreamSubscription<quill.DocChange>? _documentChangeSub;
  quill.Document? _preEditDocument;

  String get _title => widget.schema.formattedTitle;
  int? get _maxLength => widget.schema.strLengthRange?.max;

  @override
  void initState() {
    super.initState();

    _controller = _buildController(widget.property.value ?? '');
    _controller.addListener(_onControllerChanged);

    _focus = VoicesRichTextFocusNode();
    _scrollController = ScrollController();
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

  void _onControllerChanged() {
    if (_observedDocument != _controller.document) {
      _updateObservedDocument();
    }
  }

  void _updateObservedDocument() {
    _observedDocument = _controller.document;
    unawaited(_documentChangeSub?.cancel());
    _documentChangeSub = _observedDocument?.changes.listen(_onDocumentChanged);
  }

  void _updateContents(String value) {
    if (value.isNotEmpty) {
      final input = MarkdownData(value);
      final delta = markdown.encoder.convert(input);
      _controller.setContents(delta, changeSource: quill.ChangeSource.remote);
    } else {
      _controller.clear();
    }
  }

  String? _validator(quill.Document? document) {
    final delta = document?.toDelta();
    final markdownData = delta != null ? markdown.decoder.convert(delta) : null;
    final markdownValue = markdownData?.data;
    final normalizedValue = widget.schema.normalizeValue(markdownValue);

    final error = widget.schema.validate(normalizedValue);
    return LocalizedDocumentValidationResult.from(error).message(context);
  }

  void _onDocumentChanged(quill.DocChange change) {
    if (change.change.last.data != '\n') {
      _notifyChangeListener();
    }
  }

  void _notifyChangeListener() {
    final delta = _controller.document.toDelta();
    final markdownData = markdown.decoder.convert(delta);
    final value = markdownData.data;
    final normalizedValue = widget.schema.normalizeValue(value);

    final change = DocumentValueChange(
      nodeId: widget.schema.nodeId,
      value: normalizedValue,
    );

    widget.onChanged([change]);
  }

  void _toggleEditMode() {
    _controller.readOnly = !widget.isEditMode;
    if (widget.isEditMode) {
      _startEdit();
    } else {
      _stopEdit();
    }
  }

  void _startEdit() {
    final currentDocument = _controller.document;
    _preEditDocument = quill.Document.fromDelta(currentDocument.toDelta());
  }

  void _stopEdit() {
    final preEditDocument = _preEditDocument;
    _preEditDocument = null;

    if (preEditDocument != null) {
      _controller.document = preEditDocument;
    }
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
