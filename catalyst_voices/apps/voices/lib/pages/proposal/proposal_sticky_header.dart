import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ProposalStickyHeader extends StatelessWidget {
  const ProposalStickyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: colors.elevationsOnSurfaceNeutralLv0,
        border: Border(bottom: BorderSide(color: colors.outlineBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          _ProposalMetadata(
            title: 'Project Mayhem: Freedom by Chaos',
            author: 'Tyler Durden',
            createdAt: DateTime.now(),
            commentsCount: 6,
          ),
          const Spacer(flex: 5),
          _ProposalControls(
            current: null,
            versions: List.generate(3, (index) => const Uuid().v7()),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _ProposalMetadata extends StatelessWidget {
  final String title;
  final String author;
  final DateTime createdAt;
  final int commentsCount;

  const _ProposalMetadata({
    required this.title,
    required this.author,
    required this.createdAt,
    required this.commentsCount,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    final titleTextStyle = (textTheme.titleMedium ?? const TextStyle())
        .copyWith(color: colors.textOnPrimaryLevel0);
    final subtitleTextStyle = (textTheme.bodyMedium ?? const TextStyle())
        .copyWith(color: colors.textOnPrimaryLevel1);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleTextStyle,
        ),
        const SizedBox(height: 2),
        DefaultTextStyle(
          style: subtitleTextStyle,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(author),
              TimestampText(createdAt),
              Text(context.l10n.noOfComments(commentsCount)),
            ].separatedBy(const DotSeparator()).toList(),
          ),
        ),
      ],
    );
  }
}

class _ProposalControls extends StatelessWidget {
  final String? current;
  final List<String> versions;

  const _ProposalControls({
    required this.current,
    required this.versions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DocumentVersionSelector(
          versions: versions,
        ),
        FavoriteButton(onChanged: (value) {}),
        ShareButton(onTap: () {}),
      ].separatedBy(const SizedBox(width: 8)).toList(),
    );
  }
}
