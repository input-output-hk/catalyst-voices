import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProposalCommentCard extends StatelessWidget {
  final CommentDocument document;
  final bool canReply;
  final VoidCallback? onReplyTap;
  final Widget? footer;

  const ProposalCommentCard({
    super.key,
    required this.document,
    this.canReply = true,
    this.onReplyTap,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final author = document.author;
    final footer = this.footer;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileAvatar(
          size: 40,
          username: author?.catalystId.username,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(
                username: author?.catalystId.username,
                catalystId: author?.catalystId,
                createAt: document.metadata.selfRef.version!.tryDateTime,
                actions: [
                  if (canReply) ReplyButton(onTap: onReplyTap),
                ],
              ),
              const SizedBox(height: 8),
              for (final property in document.document.properties)
                DocumentPropertyReadBuilder(property: property),
              if (footer != null) ...[
                const SizedBox(height: 8),
                footer,
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String? username;
  final CatalystId? catalystId;
  final DateTime? createAt;
  final List<Widget> actions;

  const _Header({
    this.username,
    this.catalystId,
    this.createAt,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final username = this.username;
    final catalystId = this.catalystId;
    final createAt = this.createAt;

    return Row(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (username != null) _UsernameText(username),
        if (catalystId != null)
          CatalystIdText(
            catalystId,
            isCompact: true,
            showCopy: false,
            style: context.textTheme.bodySmall,
          ),
        if (createAt != null) TimestampText(createAt),
        const Spacer(),
        ...actions,
      ],
    );
  }
}

class _UsernameText extends StatelessWidget {
  final String data;

  const _UsernameText(this.data);

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: context.textTheme.titleSmall
          ?.copyWith(color: context.colors.textOnPrimaryLevel0),
    );
  }
}
