import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/document_viewer/document_viewer_content.dart';
import 'package:catalyst_voices/pages/document_viewer/widgets/document_favorite_button.dart';
import 'package:catalyst_voices/pages/document_viewer/widgets/document_share_button.dart';
import 'package:catalyst_voices/pages/document_viewer/widgets/document_version_text.dart';
import 'package:catalyst_voices/pages/proposal_viewer/widget/proposal_app_closed.dart';
import 'package:catalyst_voices/pages/proposal_viewer/widget/proposal_collaborator_banner.dart';
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
        return element?.findAncestorWidgetOfExactType<DocumentViewerContent>() != null;
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
        const Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: Column(
            // Change vertical direction to change the paint order so that the ProposalInvitationBanner
            // is not under the ProposalHeader while ProposalHeader is animating.
            verticalDirection: VerticalDirection.up,
            children: [
              ProposalAppClosed(),
              ProposalHeader(),
              ProposalCollaboratorBanner(),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProposalControls extends StatelessWidget {
  const _ProposalControls();

  @override
  Widget build(BuildContext context) {
    // TODO(LynxLynxx): Remove when we support mobile web
    return ResponsiveChildBuilder(
      xs: (context) => const SizedBox(),
      sm: (context) => const Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          DocumentVersionText(),
          DocumentShareButton(),
          DocumentFavoriteButton(),
        ],
      ),
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
  final String? author;
  final DateTime? createdAt;
  final int? commentsCount;

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

    final titleTextStyle = (textTheme.titleMedium ?? const TextStyle()).copyWith(
      color: colors.textOnPrimaryLevel0,
    );
    final subtitleTextStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: colors.textOnPrimaryLevel1,
    );

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
              UsernameText(author),
              if (createdAt case final createdAt?) TimestampText(createdAt),
              if (commentsCount case final commentsCount?)
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
    return BlocSelector<ProposalViewerCubit, ProposalViewerState, ProposalViewHeader>(
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
