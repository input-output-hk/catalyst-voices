import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/proposal_submission_phase_aware.dart';
import 'package:catalyst_voices/pages/discovery/sections/campaign_details/campaign_details.dart';
import 'package:catalyst_voices/pages/discovery/sections/campaign_hero.dart';
import 'package:catalyst_voices/pages/discovery/sections/how_it_works.dart';
import 'package:catalyst_voices/pages/discovery/sections/most_recent_proposals/most_recent_proposals.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved/stay_involved.dart';
import 'package:catalyst_voices/widgets/common/infrastructure/voices_wide_screen_constrained.dart';
import 'package:catalyst_voices/widgets/countdown/animated_voices_countdown.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _Body extends StatefulWidget {
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _date = DateTime.now().add(const Duration(days: 5));

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(color: context.colors.primaryContainer),
                child: AnimatedVoicesCountdown(
                  dateTime: _date,
                ),
              ),
              const CampaignHeroSection(),
              const HowItWorks(),
              const CampaignDetails(),
              const StayInvolved(),
              const MostRecentProposals(),
            ].constrainedDelegate(
              excludePredicate: (widget) =>
                  widget is CampaignHeroSection ||
                  widget is MostRecentProposals ||
                  widget is HowItWorks,
            ),
          ),
        ),
      ],
    );
  }
}

class _DiscoveryPageState extends State<DiscoveryPage>
    with ErrorHandlerStateMixin<DiscoveryCubit, DiscoveryPage> {
  @override
  Widget build(BuildContext context) {
    return const ProposalSubmissionPhaseAware(
      activeChild: SelectionArea(
        child: CustomScrollView(
          slivers: [
            _Body(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    unawaited(_loadData());
  }

  Future<void> _loadData() async {
    try {
      await context.read<DiscoveryCubit>().getAllData();
    } finally {
      if (mounted) unawaited(SentryDisplayWidget.of(context).reportFullyDisplayed());
    }
  }
}
