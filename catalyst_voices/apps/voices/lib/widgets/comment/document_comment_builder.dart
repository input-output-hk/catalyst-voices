import 'dart:async';

import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide DocumentPropertyBuilder;
import 'package:flutter/material.dart';

typedef OnSubmitDocumentComment =
    Future<void> Function({
      required Document document,
      SignedDocumentRef? reply,
    });

class DocumentCommentBuilder extends StatefulWidget {
  final DocumentSchema schema;
  final SignedDocumentRef? parent;
  final bool showCancel;
  final OnSubmitDocumentComment onSubmit;
  final VoidCallback? onCancelTap;

  const DocumentCommentBuilder({
    super.key,
    required this.schema,
    this.parent,
    this.showCancel = false,
    required this.onSubmit,
    this.onCancelTap,
  });

  @override
  State<DocumentCommentBuilder> createState() => _DocumentCommentBuilderState();
}

class _Actions extends StatelessWidget {
  final VoidCallback? onSubmitTap;
  final VoidCallback? onCancelTap;
  final bool showCancel;

  const _Actions({
    this.onSubmitTap,
    this.onCancelTap,
    required this.showCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showCancel)
          VoicesTextButton(
            onTap: onCancelTap,
            child: Text(context.l10n.cancelCommit),
          ),
        VoicesFilledButton(
          onTap: onSubmitTap,
          child: Text(context.l10n.submitCommit),
        ),
      ],
    );
  }
}

class _DocumentCommentBuilderState extends State<DocumentCommentBuilder> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusScopeNode();

  late DocumentBuilder _builder;
  late Document _comment;

  @override
  Widget build(BuildContext context) {
    return DocumentBuilderTheme(
      data: const DocumentBuilderThemeData(
        shouldDebounceChange: false,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SessionAccountAvatar(),
          const SizedBox(width: 16),
          Expanded(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: FocusScope(
                node: _focusNode,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final property in _comment.properties)
                      DocumentPropertyBuilder(
                        key: ValueKey(property.nodeId),
                        property: property,
                        isEditMode: true,
                        onChanged: _handlePropertyChanges,
                        collaboratorsSectionData: (
                          editedData: null,
                          isEditMode: true,
                          onCollaboratorsChanged: (_) {},
                        ),
                      ),
                    const SizedBox(height: 4),
                    _Actions(
                      onSubmitTap: _submit,
                      onCancelTap: widget.onCancelTap,
                      showCancel: widget.showCancel,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(DocumentCommentBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.schema != oldWidget.schema) {
      _builder = DocumentBuilder.fromSchema(schema: widget.schema);
      _comment = _builder.build();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _builder = DocumentBuilder.fromSchema(schema: widget.schema);
    _comment = _builder.build();
  }

  void _handlePropertyChanges(List<DocumentChange> changes) {
    setState(() {
      _builder.addChanges(changes);
      _comment = _builder.build();
    });
  }

  Future<void> _submit() async {
    if (!_comment.isValid) {
      return;
    }

    unawaited(
      widget.onSubmit(document: _comment, reply: widget.parent),
    );

    setState(() {
      _formKey.currentState?.reset();
      _focusNode.unfocus();
      _builder = DocumentBuilder.fromSchema(schema: widget.schema);
      _comment = _builder.build();
    });
  }
}

class _SessionAccountAvatar extends StatelessWidget {
  const _SessionAccountAvatar();

  @override
  Widget build(BuildContext context) {
    final username = context.select<SessionCubit, String?>(
      (value) => value.state.account?.username,
    );
    return ProfileAvatar(
      username: username,
    );
  }
}
