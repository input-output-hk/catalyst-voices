import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/workspace/header/workspace_campaign_timeline.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/gesture/voices_gesture_detector.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class WorkspaceTimeline extends StatelessWidget {
  const WorkspaceTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveChildBuilder(
      sm: (_) => const _SmallScreen(),
      md: (_) => const _LargeScreen(),
    );
  }
}

class _HasCommentCard extends StatelessWidget {
  final BoxConstraints boxConstraints;

  const _HasCommentCard({
    required this.boxConstraints,
  });

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
        constraints: boxConstraints,
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

class _LargeScreen extends StatelessWidget {
  const _LargeScreen();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _ViewComments(
          padding: EdgeInsets.only(right: 24),
          boxConstraints: BoxConstraints(
            maxWidth: 300,
            maxHeight: 190,
          ),
        ),
        Expanded(
          child: _Timeline(),
        ),
      ],
    );
  }
}

class _SmallScreen extends StatelessWidget {
  const _SmallScreen();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        _ViewComments(
          boxConstraints: BoxConstraints.tightFor(height: 120),
          padding: EdgeInsets.zero,
        ),
        _Timeline(),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.onSurfaceNeutralOpaqueLv0.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const WorkspaceCampaignTimeline(),
    );
  }
}

class _ViewComments extends StatelessWidget {
  final EdgeInsets padding;
  final BoxConstraints boxConstraints;

  const _ViewComments({
    required this.padding,
    required this.boxConstraints,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WorkspaceBloc, WorkspaceState, bool>(
      selector: (state) => state.userProposals.hasComments,
      builder: (context, hasComments) {
        return hasComments
            ? Padding(
                padding: padding,
                child: _HasCommentCard(
                  boxConstraints: boxConstraints,
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
