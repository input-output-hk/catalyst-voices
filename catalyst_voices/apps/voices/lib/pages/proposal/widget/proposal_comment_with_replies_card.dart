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

class ProposalCommentWithRepliesCard extends StatefulWidget {
  final CommentWithReplies comment;

  const ProposalCommentWithRepliesCard({
    super.key,
    required this.comment,
  });

  @override
  State<ProposalCommentWithRepliesCard> createState() {
    return _ProposalCommentWithRepliesCardState();
  }
}

class _ProposalCommentWithRepliesCardState
    extends State<ProposalCommentWithRepliesCard> {
  bool _showReplies = true;
  bool _showReplyInput = false;

  @override
  Widget build(BuildContext context) {
    final hasActiveAccount = context
        .select<SessionCubit, bool>((value) => value.state.account != null);
    final repliesIndent = 56 * widget.comment.depth;
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        ProposalCommentCard(
          document: widget.comment.comment,
          canReply: hasActiveAccount && widget.comment.depth == 1,
          onReplyTap: _onReplyTap,
          footer: Offstage(
            offstage: widget.comment.replies.isEmpty,
            child: _ToggleRepliesChip(
              repliesCount: widget.comment.replies.length,
              hide: _showReplies,
              onTap: _toggleReplies,
            ),
          ),
        ),
        if (_showReplies)
          Padding(
            padding: EdgeInsets.only(left: repliesIndent.toDouble()),
            child: Column(
              spacing: 8,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final reply in widget.comment.replies)
                  ProposalCommentWithRepliesCard(comment: reply),
              ],
            ),
          ),
        if (_showReplyInput)
          Padding(
            padding: EdgeInsets.only(left: repliesIndent.toDouble()),
            child: ProposalCommentBuilder(
              schema: widget.comment.comment.document.schema,
              parent: widget.comment.comment.metadata.selfRef,
              showCancel: true,
              onCancelTap: _hideReplyInput,
            ),
          ),
      ],
    );
  }

  void _hideReplyInput() {
    setState(() {
      _showReplyInput = false;
    });
  }

  void _onReplyTap() {
    setState(() {
      _showReplyInput = true;
    });
  }

  void _toggleReplies() {
    setState(() {
      _showReplies = !_showReplies;
    });
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
