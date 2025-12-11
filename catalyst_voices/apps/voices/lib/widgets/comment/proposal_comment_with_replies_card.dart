import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/comment/proposal_comment_builder.dart';
import 'package:catalyst_voices/widgets/comment/proposal_comment_card.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/common/animated_expand_chevron.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalCommentWithRepliesCard extends StatelessWidget {
  final CommentWithReplies comment;
  final bool canReply;
  final Map<DocumentRef, bool> showReplies;
  final bool showReplyBuilder;
  final OnSubmitProposalComment onSubmit;
  final VoidCallback onCancel;
  final ValueChanged<bool> onToggleBuilder;
  final ValueChanged<bool> onToggleReplies;

  const ProposalCommentWithRepliesCard({
    super.key,
    required this.comment,
    required this.canReply,
    required this.showReplies,
    required this.showReplyBuilder,
    required this.onSubmit,
    required this.onCancel,
    required this.onToggleBuilder,
    required this.onToggleReplies,
  });

  bool get _showCommentFooter => _showToggleReplies;

  bool get _showReplies => showReplies[comment.ref] ?? true;

  bool get _showToggleReplies => comment.replies.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final repliesIndent = 56 * comment.depth;

    final showReplies = _showReplies;
    final showToggleReplies = _showToggleReplies;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        ProposalCommentCard(
          key: ValueKey('ProposalComment${comment.comment.metadata.id}Card'),
          document: comment.comment,
          canReply: canReply,
          trimLines: 6,
          onReplyTap: () => onToggleBuilder(true),
          footer: _showCommentFooter
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showToggleReplies)
                      _ToggleRepliesChip(
                        repliesCount: comment.replies.length,
                        hide: showReplies,
                        onTap: () => onToggleReplies(!showReplies),
                      ),
                  ],
                )
              : null,
        ),
        if (showReplies)
          Padding(
            padding: EdgeInsets.only(left: repliesIndent.toDouble()),
            child: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final reply in comment.replies)
                  _RepliesCard(
                    key: ValueKey('ReplyComment.${reply.comment.metadata.id.id}'),
                    comment: reply,
                    showReplies: this.showReplies,
                    onSubmit: onSubmit,
                    onCancel: onCancel,
                    onToggleBuilder: onToggleBuilder,
                    onToggleReplies: onToggleReplies,
                  ),
              ],
            ),
          ),
        if (showReplyBuilder)
          Padding(
            padding: EdgeInsets.only(
              left: repliesIndent.toDouble(),
              bottom: 16,
            ),
            child: ProposalCommentBuilder(
              schema: comment.comment.document.schema,
              parent: comment.comment.metadata.id,
              showCancel: true,
              onCancelTap: () => onToggleBuilder(false),
              onSubmit: onSubmit,
            ),
          ),
      ],
    );
  }
}

class _RepliesCard extends StatelessWidget {
  final CommentWithReplies comment;
  final Map<DocumentRef, bool> showReplies;
  final OnSubmitProposalComment onSubmit;
  final VoidCallback onCancel;
  final ValueChanged<bool> onToggleBuilder;
  final ValueChanged<bool> onToggleReplies;

  const _RepliesCard({
    required super.key,
    required this.comment,
    required this.showReplies,
    required this.onSubmit,
    required this.onCancel,
    required this.onToggleBuilder,
    required this.onToggleReplies,
  });

  @override
  Widget build(BuildContext context) {
    return ProposalCommentWithRepliesCard(
      comment: comment,
      canReply: false,
      showReplies: showReplies,
      showReplyBuilder: false,
      onSubmit: onSubmit,
      onCancel: onCancel,
      onToggleBuilder: onToggleBuilder,
      onToggleReplies: onToggleReplies,
    );
  }
}

class _ToggleRepliesChip extends StatelessWidget {
  final int repliesCount;
  final bool hide;
  final VoidCallback? onTap;

  const _ToggleRepliesChip({
    required this.repliesCount,
    required this.hide,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(height: 40),
      child: Material(
        textStyle: textTheme.labelMedium?.copyWith(
          color: colors.textOnPrimaryLevel0,
        ),
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: AffixDecorator(
            suffix: AnimatedExpandChevron(isExpanded: hide, size: 18),
            child: Text(
              hide ? context.l10n.commentHideReplies : context.l10n.commentXReplies(repliesCount),
            ),
          ),
        ),
      ),
    );
  }
}
