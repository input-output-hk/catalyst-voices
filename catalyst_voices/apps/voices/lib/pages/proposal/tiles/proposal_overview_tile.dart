import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_favorite_button.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_share_button.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
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
              const ProposalShareButton(),
              const SizedBox(width: 8),
              // TODO(LynxLynxx): Remove when we support mobile web
              Offstage(
                offstage:
                    context.select<ProposalCubit, bool>((cubit) => cubit.state.readOnlyMode) ||
                    CatalystFormFactor.current.isMobile,
                child: const ProposalFavoriteButton(),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
