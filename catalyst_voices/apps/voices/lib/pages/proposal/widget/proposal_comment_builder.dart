import 'dart:async';

import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    hide DocumentPropertyBuilder;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalCommentBuilder extends StatefulWidget {
  final DocumentSchema schema;
  final SignedDocumentRef? parent;
  final bool showCancel;
  final VoidCallback? onCancelTap;

  const ProposalCommentBuilder({
    super.key,
    required this.schema,
    this.parent,
    this.showCancel = false,
    this.onCancelTap,
  });

  @override
  State<ProposalCommentBuilder> createState() => _ProposalCommentBuilderState();
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

class _ProposalCommentBuilderState extends State<ProposalCommentBuilder> {
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
  void didUpdateWidget(covariant ProposalCommentBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.schema != oldWidget.schema) {
      _builder = DocumentBuilder.fromSchema(schema: widget.schema);
      _comment = _builder.build();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();

    _builder = DocumentBuilder.fromSchema(schema: widget.schema);
    _comment = _builder.build();
  }

  void _handlePropertyChanges(List<DocumentChange> changes) {
    setState(() {
      for (final change in changes) {
        _builder.addChange(change);
      }
      _comment = _builder.build();
    });
  }

  Future<void> _submit() async {
    if (!_comment.isValid) {
      return;
    }

    // TODO(damian-molinski): uncomment
    // final catalystId = context.read<SessionCubit>().state.account?.catalystId;
    // assert(catalystId != null, 'No active account found!');

    final cubit = context.read<ProposalCubit>();

    unawaited(cubit.submitComment(document: _comment, parent: widget.parent));

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
      size: 40,
    );
  }
}
