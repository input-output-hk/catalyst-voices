import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_comment_builder.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_comment_card.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/common/animated_expand_chevron.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalCommentWithRepliesCard extends StatelessWidget {
  final CommentWithReplies comment;
  final bool canReply;
  final bool showReplies;
  final bool showReplyBuilder;

  const ProposalCommentWithRepliesCard({
    super.key,
    required this.comment,
    required this.canReply,
    required this.showReplies,
    required this.showReplyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final repliesIndent = 56 * comment.depth;

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        ProposalCommentCard(
          document: comment.comment,
          canReply: canReply,
          onReplyTap: () {
            context
                .read<ProposalCubit>()
                .updateCommentBuilder(ref: comment.ref, show: true);
          },
          footer: Offstage(
            offstage: comment.replies.isEmpty,
            child: _ToggleRepliesChip(
              repliesCount: comment.replies.length,
              hide: showReplies,
              onTap: () {
                context.read<ProposalCubit>().updateCommentReplies(
                      ref: comment.ref,
                      show: !showReplies,
                    );
              },
            ),
          ),
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
                    key: ValueKey(
                      'ReplyComment.${reply.comment.metadata.selfRef.id}',
                    ),
                    comment: reply,
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
              parent: comment.comment.metadata.selfRef,
              showCancel: true,
              onCancelTap: () {
                context
                    .read<ProposalCubit>()
                    .updateCommentBuilder(ref: comment.ref, show: false);
              },
            ),
          ),
      ],
    );
  }
}

class _RepliesCard extends StatelessWidget {
  final CommentWithReplies comment;

  const _RepliesCard({
    required super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final showReplies = context.select<ProposalCubit, bool>((value) {
      return value.state.data.showReplies[comment.ref] ?? true;
    });

    return ProposalCommentWithRepliesCard(
      comment: comment,
      canReply: false,
      showReplies: showReplies,
      showReplyBuilder: false,
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
              hide
                  ? context.l10n.commentHideReplies
                  : context.l10n.commentXReplies(repliesCount),
            ),
          ),
        ),
      ),
    );
  }
}
