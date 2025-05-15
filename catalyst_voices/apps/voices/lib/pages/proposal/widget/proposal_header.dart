import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposal/proposal_content.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_favorite_button.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_share_button.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_version.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalHeader extends StatelessWidget {
  const ProposalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      notificationPredicate: (notification) {
        if (notification.depth != 0) {
          return false;
        }

        final element = notification.context as Element?;

        // Only react to content scroll not menu.
        return element?.findAncestorWidgetOfExactType<ProposalContent>() != null;
      },
      child: const _ProposalHeader(),
    );
  }
}

class ProposalHeaderWrapper extends StatelessWidget {
  final Widget child;

  const ProposalHeaderWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        const ProposalHeader(),
      ],
    );
  }
}

class _ProposalControls extends StatelessWidget {
  const _ProposalControls();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: [
        ProposalVersion(),
        ProposalShareButton(),
        ProposalFavoriteButton(),
      ],
    );
  }
}

class _ProposalHeader extends StatelessWidget {
  const _ProposalHeader();

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
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          _ProposalMetadataSelector(),
          Spacer(flex: 5),
          _ProposalControls(),
          Spacer(),
        ],
      ),
    );
  }
}

class _ProposalMetadata extends StatelessWidget {
  final String title;
  final String author;
  final DateTime? createdAt;
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

    final titleTextStyle =
        (textTheme.titleMedium ?? const TextStyle()).copyWith(color: colors.textOnPrimaryLevel0);
    final subtitleTextStyle =
        (textTheme.bodyMedium ?? const TextStyle()).copyWith(color: colors.textOnPrimaryLevel1);

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
              if (author.isNotEmpty) Text(author),
              if (createdAt != null) TimestampText(createdAt!),
              Text(context.l10n.noOfComments(commentsCount)),
            ].separatedBy(const DotSeparator()).toList(),
          ),
        ),
      ],
    );
  }
}

class _ProposalMetadataSelector extends StatelessWidget {
  const _ProposalMetadataSelector();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalCubit, ProposalState, ProposalViewHeader>(
      selector: (state) => state.data.header,
      builder: (context, state) {
        return _ProposalMetadata(
          title: state.title,
          author: state.authorName,
          createdAt: state.createdAt,
          commentsCount: state.commentsCount,
        );
      },
    );
  }
}
