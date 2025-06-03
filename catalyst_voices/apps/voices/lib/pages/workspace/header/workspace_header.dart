import 'dart:async';
import 'dart:typed_data';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/ext/space_ext.dart';
import 'package:catalyst_voices/routes/routing/routing.dart';
import 'package:catalyst_voices/widgets/buttons/create_proposal_button.dart';
import 'package:catalyst_voices/widgets/campaign_timeline/campaign_timeline_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' show ProposalDocument, Space;
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

part 'import_proposal_button.dart';
part 'timeline_toggle_button.dart';

class WorkspaceHeader extends StatefulWidget {
  const WorkspaceHeader({super.key});

  @override
  State<WorkspaceHeader> createState() => _WorkspaceHeaderState();
}

class _HasCommentCard extends StatelessWidget {
  const _HasCommentCard();

  @override
  Widget build(BuildContext context) {
    return VoicesGestureDetector(
      onTap: () async => ProposalsRoute.myProposals().push(context),
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.elevationsOnSurfaceNeutralLv0,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(
          maxWidth: 300,
          maxHeight: 190,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                VoicesAssets.icons.chat.buildIcon(
                  color: context.colors.iconsPrimary,
                ),
                const Spacer(),
                VoicesAssets.icons.arrowRight.buildIcon(
                  color: context.colors.primaryContainer,
                ),
              ],
            ),
            const Spacer(),
            Text(
              context.l10n.viewProposalComments,
              style: context.textTheme.titleSmall?.copyWith(
                color: context.colors.textOnPrimaryLevel1,
              ),
            ),
            Text(
              context.l10n.viewProposalCommentsDescription,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.sysColorsNeutralN60,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _ViewComments extends StatelessWidget {
  const _ViewComments();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) => state.hasComments,
      builder: (context, hasComments) {
        return hasComments
            ? const Padding(
                padding: EdgeInsets.only(right: 24),
                child: _HasCommentCard(),
              )
            : const SizedBox.shrink();
      },
    );
  }
}

class _WorkspaceHeaderState extends State<WorkspaceHeader> {
  bool _isTimelineVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          Text(
            context.l10n.catalyst,
            style: theme.textTheme.titleSmall?.copyWith(
              color: VoicesColors.lightTextOnPrimaryLevel1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Space.workspace.localizedName(context.l10n),
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const Spacer(),
              const CreateProposalButton(showTrailingIcon: true),
              const SizedBox(width: 8),
              const _ImportProposalButton(),
              const SizedBox(width: 8),
              _TimelineToggleButton(
                onPressed: _toggleTimelineVisibility,
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_isTimelineVisible) ...[
            Row(
              children: [
                const _ViewComments(),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colors.onSurfaceNeutralOpaqueLv0.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: BlocSelector<WorkspaceBloc, WorkspaceState,
                        List<CampaignTimelineViewModel>>(
                      selector: (state) {
                        return state.timelineItems;
                      },
                      builder: (context, timelineItems) {
                        return CampaignTimeline(
                          timelineItems: timelineItems,
                          placement: CampaignTimelinePlacement.workspace,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ],
      ),
    );
  }

  void _toggleTimelineVisibility() {
    setState(() {
      _isTimelineVisible = !_isTimelineVisible;
    });
  }
}
