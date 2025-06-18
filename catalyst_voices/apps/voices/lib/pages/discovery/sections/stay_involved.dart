import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/discovery/sections/session_account_catalyst_id.dart';
import 'package:catalyst_voices/share/share_manager.dart';
import 'package:catalyst_voices/widgets/text/campaign_stage_time_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StayInvolved extends StatelessWidget {
  const StayInvolved({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 120, vertical: 72),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(),
          SizedBox(height: 24),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              _VoterCard(),
              _ReviewerCard(),
            ],
          ),
        ],
      ),
    );
  }
}

class _CopyCatalystIdTipText extends StatelessWidget {
  const _CopyCatalystIdTipText();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, bool>(
      selector: (state) {
        return state.isActive;
      },
      builder: (context, isActive) {
        return Offstage(
          offstage: !isActive,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TipText(
              context.l10n.tipCopyCatalystIdForReviewTool(
                ShareManager.of(context).becomeReviewer().decoded(),
              ),
              style:
                  context.textTheme.bodyMedium?.copyWith(color: context.colors.textOnPrimaryLevel1),
            ),
          ),
        );
      },
    );
  }
}

class _DatetimeRangeTimeline extends StatelessWidget {
  final DateRange? dateRange;
  final String title;

  const _DatetimeRangeTimeline({
    this.dateRange,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return dateRange == null
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: context.textTheme.titleSmall,
              ),
              CampaignStageTimeText(
                dateRange: dateRange!,
              ),
            ],
          );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.stayInvolved,
      style: context.textTheme.headlineMedium,
    );
  }
}

class _RangeTimelineCard extends StatelessWidget {
  final List<Widget> children;

  const _RangeTimelineCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv0,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 8,
        runSpacing: 8,
        children: children,
      ),
    );
  }
}

class _ReviewerCard extends StatelessWidget {
  const _ReviewerCard();

  @override
  Widget build(BuildContext context) {
    return _StayInvolvedCard(
      icon: VoicesAssets.icons.clipboardCheck,
      title: context.l10n.becomeReviewer,
      description: context.l10n.stayInvolvedReviewerDescription,
      actions: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _RangeTimelineCard(
            children: [
              BlocSelector<DiscoveryCubit, DiscoveryState, DateRange?>(
                selector: (state) {
                  return state.campaign.reviewRegistrationStartsAt;
                },
                builder: (context, date) {
                  return _DatetimeRangeTimeline(
                    dateRange: date,
                    title: context.l10n.reviewRegistration,
                  );
                },
              ),
              BlocSelector<DiscoveryCubit, DiscoveryState, DateRange?>(
                selector: (state) {
                  return state.campaign.votingStartsAt;
                },
                builder: (context, date) {
                  return _DatetimeRangeTimeline(
                    dateRange: date,
                    title: context.l10n.reviewTimelineHeader,
                  );
                },
              ),
            ],
          ),
          const _CopyCatalystIdTipText(),
          const SessionAccountCatalystId(
            padding: EdgeInsets.only(top: 20),
          ),
          _StayInvolvedActionButton(
            title: context.l10n.becomeReviewer,
            onTap: () {
              final shareManager = ShareManager.of(context);
              final uri = shareManager.becomeReviewer();
              unawaited(launchUrl(uri));
            },
            trailing: VoicesAssets.icons.externalLink.buildIcon(),
          ),
        ],
      ),
    );
  }
}

class _StayInvolvedActionButton extends StatelessWidget with LaunchUrlMixin {
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _StayInvolvedActionButton({
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: VoicesFilledButton(
        onTap: onTap,
        trailing: trailing,
        child: Text(title),
      ),
    );
  }
}

class _StayInvolvedCard extends StatelessWidget {
  final SvgGenImage icon;
  final String title;
  final String description;
  final Widget actions;

  const _StayInvolvedCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 565,
        maxWidth: 588,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: _getGradientColors(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          icon.buildIcon(size: 53),
          const SizedBox(height: 22),
          Text(
            title,
            style: context.textTheme.headlineLarge?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          actions,
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? [
            const Color(0xFFD1EAFF),
            const Color(0xFFCAD6FE),
          ]
        : [
            const Color(0xFF2D3953),
            const Color(0xFF242C42),
          ];
  }
}

class _VoterCard extends StatelessWidget {
  const _VoterCard();

  @override
  Widget build(BuildContext context) {
    return _StayInvolvedCard(
      icon: VoicesAssets.icons.vote,
      title: context.l10n.registerToVoteFund14,
      description: context.l10n.stayInvolvedContributorDescription,
      actions: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          _RangeTimelineCard(
            children: [
              BlocSelector<DiscoveryCubit, DiscoveryState, DateRange?>(
                selector: (state) {
                  return state.campaign.votingRegistrationStartsAt;
                },
                builder: (context, date) {
                  return _DatetimeRangeTimeline(
                    dateRange: date,
                    title: context.l10n.votingRegistrationTimelineHeader,
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocSelector<DiscoveryCubit, DiscoveryState, DateRange?>(
                selector: (state) {
                  return state.campaign.votingStartsAt;
                },
                builder: (context, date) {
                  return _DatetimeRangeTimeline(
                    dateRange: date,
                    title: context.l10n.votingTimelineHeader,
                  );
                },
              ),
            ],
          ),
          _StayInvolvedActionButton(
            title: context.l10n.becomeVoter,
            onTap: () {
              final uri = Uri.parse(VoicesConstants.afterSubmissionUrl);
              unawaited(launchUrl(uri));
            },
          ),
        ],
      ),
    );
  }
}
