import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class VoicesRichTextLimit extends StatefulWidget {
  final Document document;
  final int? charsLimit;
  final String? errorMessage;

  const VoicesRichTextLimit({
    super.key,
    required this.document,
    this.charsLimit,
    this.errorMessage,
  });

  @override
  State<VoicesRichTextLimit> createState() => _VoicesRichTextLimitState();
}

class _VoicesRichTextLimitState extends State<VoicesRichTextLimit> {
  StreamSubscription<DocChange>? _docChangesSub;

  @override
  void initState() {
    super.initState();
    _docChangesSub = widget.document.changes.listen(_updateDocLength);
  }

  @override
  void didUpdateWidget(VoicesRichTextLimit oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.document != oldWidget.document) {
      unawaited(_docChangesSub?.cancel());
      _docChangesSub = widget.document.changes.listen(_updateDocLength);
    }
  }

  @override
  void dispose() {
    unawaited(_docChangesSub?.cancel());
    _docChangesSub = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = widget.errorMessage ?? '';

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: error.isEmpty ? 0 : 4,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
            _formatText(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _formatText() {
    final charsLimit = widget.charsLimit;
    final documentLength = widget.document.length;
    if (charsLimit == null) {
      return '$documentLength';
    }

    return '$documentLength/$charsLimit';
  }

  void _updateDocLength(DocChange change) {
    setState(() {});
  }
}
