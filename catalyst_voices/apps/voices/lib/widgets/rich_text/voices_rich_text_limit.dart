import 'dart:async';

import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class VoicesRichTextLimit extends StatefulWidget {
  final Document document;
  final int? charsLimit;

  const VoicesRichTextLimit({
    super.key,
    required this.document,
    this.charsLimit,
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
  void didUpdateWidget(covariant VoicesRichTextLimit oldWidget) {
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.supportingTextLabelText,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Text(
            _buildText(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _buildText() {
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
