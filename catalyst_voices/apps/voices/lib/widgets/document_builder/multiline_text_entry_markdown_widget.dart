import 'dart:async';

import 'package:catalyst_voices/common/codecs/markdown_codec.dart';
import 'package:catalyst_voices/common/ext/document_property_ext.dart';
import 'package:catalyst_voices/widgets/rich_text/voices_rich_text.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';

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
  late final VoicesRichTextController _controller;
  late final VoicesRichTextFocusNode _focus;
  late final ScrollController _scrollController;

  final MarkdownEncoder _encoder = const MarkdownEncoder();
  final MarkdownDecoder _decoder = const MarkdownDecoder();

  quill.Document? _observedDocument;
  StreamSubscription<DocChange>? _documentChangeSub;
  quill.Document? _preEditDocument;

  String get _description => widget.property.formattedDescription;
  int? get _maxLength => widget.property.schema.strLengthRange?.max;
  String? get _value => widget.property.value;

  @override
  void initState() {
    super.initState();

    _handleInitialValue();
    _controller.addListener(_onControllerChanged);

    _focus = VoicesRichTextFocusNode();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(covariant MultilineTextEntryMarkdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isEditMode != oldWidget.isEditMode) {
      _focus.toggleFocus(enabled: widget.isEditMode);
      _controller.readOnly = !widget.isEditMode;
      _toggleEditMode();
    }

    if (widget.property.value != oldWidget.property.value) {
      _handleInitialValue();
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
      title: _description,
      focusNode: _focus,
      scrollController: _scrollController,
      charsLimit: _maxLength,
      validator: (val) {
        return null;

        // TODO(LynxxLynx): implement validator when we got answer how to
        // validate formatted document against maxLength
      },
    );
  }

  void _handleInitialValue() {
    if (_value != null) {
      final input = MarkdownData(_value!);
      final delta = _decoder.convert(input);
      _controller = VoicesRichTextController(
        document: quill.Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _controller = VoicesRichTextController(
        document: quill.Document(),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
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

  void _onDocumentChanged(DocChange change) {
    if (change.change.last.data != '\n') {
      _notifyChangeListener();
    }
  }

  void _notifyChangeListener() {
    final delta = _controller.document.toDelta();
    final markdownData = _encoder.convert(delta);
    widget.onChanged(
      DocumentChange(
        nodeId: widget.property.schema.nodeId,
        value: markdownData.data,
      ),
    );
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
