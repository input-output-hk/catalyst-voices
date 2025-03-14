import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart'
    hide DocumentPropertyBuilder;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProposalCommentBuilder extends StatefulWidget {
  final CommentTemplate template;
  final CatalystId authorId;
  final bool showCancel;
  final VoidCallback? onCancelTap;

  const ProposalCommentBuilder({
    super.key,
    required this.template,
    required this.authorId,
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

class _Avatar extends StatelessWidget {
  final String? letter;

  const _Avatar({
    this.letter,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesAvatar(
      radius: 40 / 2,
      icon: Text(letter?.toUpperCase() ?? ''),
    );
  }
}

class _ProposalCommentBuilderState extends State<ProposalCommentBuilder> {
  late DocumentBuilder _builder;
  late Document _comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Avatar(letter: widget.authorId.username?.firstLetter),
        const SizedBox(width: 16),
        Expanded(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final property in widget.template.document.properties)
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
      ],
    );
  }

  @override
  void didUpdateWidget(covariant ProposalCommentBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.template != oldWidget.template) {
      _builder = widget.template.document.toBuilder();
      _comment = _builder.build();
    }
  }

  @override
  void initState() {
    super.initState();

    _builder = widget.template.document.toBuilder();
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
  }
}
