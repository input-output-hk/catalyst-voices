import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProposalCommentCard extends StatelessWidget {
  final CommentDocument document;
  final bool canReply;
  final int trimLines;
  final VoidCallback? onReplyTap;
  final Widget? footer;

  const ProposalCommentCard({
    super.key,
    required this.document,
    this.canReply = true,
    required this.trimLines,
    this.onReplyTap,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final authorId = document.metadata.authorId;
    final footer = this.footer;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileAvatar(
          username: authorId.username,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(
                username: authorId.username,
                catalystId: authorId,
                createAt: document.metadata.id.ver!.tryDateTime,
                actions: [
                  if (canReply) ReplyButton(onTap: onReplyTap),
                ],
              ),
              const SizedBox(height: 8),
              for (final property in document.document.properties)
                DocumentPropertyReadBuilder(
                  property: property,
                  overrides: {
                    CommentDocument.content: (context, listItem) {
                      return ExpandableText(
                        key: ValueKey('Comment[${document.metadata.id}]ExpandableText'),
                        listItem.value is String ? listItem.value! as String : '',
                        trimLines: trimLines,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  },
                ),
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
    final catalystId = this.catalystId;
    final createAt = this.createAt;

    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _UsernameText(username),
              if (catalystId != null)
                CatalystIdText(
                  catalystId,
                  isCompact: true,
                  showCopy: false,
                  style: context.textTheme.bodySmall,
                ),
              if (createAt != null) TimestampText(createAt),
            ],
          ),
        ),
        ...actions,
      ],
    );
  }
}

class _UsernameText extends StatelessWidget {
  final String? data;

  const _UsernameText(this.data);

  @override
  Widget build(BuildContext context) {
    return UsernameText(
      data,
      style: context.textTheme.titleSmall?.copyWith(color: context.colors.textOnPrimaryLevel0),
    );
  }
}
