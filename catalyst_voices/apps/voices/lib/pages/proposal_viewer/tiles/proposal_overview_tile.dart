import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/document_viewer/widgets/document_favorite_button.dart';
import 'package:catalyst_voices/pages/document_viewer/widgets/document_share_button.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProposalOverviewTile extends StatelessWidget {
  final String categoryName;
  final String proposalTitle;
  final bool isVotingStage;

  const ProposalOverviewTile({
    super.key,
    required this.categoryName,
    required this.proposalTitle,
    required this.isVotingStage,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(color: colors.textOnPrimaryLevel1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    proposalTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.headlineLarge?.copyWith(color: colors.textOnPrimaryLevel0),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            if (!isVotingStage) ...[
              const DocumentShareButton(),
              const SizedBox(width: 8),
              // TODO(LynxLynxx): Remove when we support mobile web
              Offstage(
                offstage: CatalystFormFactor.current.isMobile,
                child: const DocumentFavoriteButton(),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
