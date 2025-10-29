import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/pages/account/keychain_deleted_dialog.dart';
import 'package:catalyst_voices/pages/campaign_phase_aware/proposal_submission_phase_aware.dart';
import 'package:catalyst_voices/pages/discovery/sections/campaign_details/campaign_details.dart';
import 'package:catalyst_voices/pages/discovery/sections/campaign_hero.dart';
import 'package:catalyst_voices/pages/discovery/sections/how_it_works.dart';
import 'package:catalyst_voices/pages/discovery/sections/most_recent_proposals/most_recent_proposals.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved/stay_involved.dart';
import 'package:catalyst_voices/widgets/common/infrastructure/voices_wide_screen_constrained.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DiscoveryPage extends StatefulWidget {
  final bool keychainDeleted;

  const DiscoveryPage({super.key, this.keychainDeleted = false});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
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
  void didUpdateWidget(DiscoveryPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.keychainDeleted && widget.keychainDeleted != oldWidget.keychainDeleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _showKeychainDeletedDialog(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    unawaited(_loadData());

    if (widget.keychainDeleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _showKeychainDeletedDialog(context);
      });
    }
  }

  Future<void> _loadData() async {
    try {
      await context.read<DiscoveryCubit>().getAllData();
    } finally {
      if (mounted) unawaited(SentryDisplayWidget.of(context).reportFullyDisplayed());
    }
  }

  Future<void> _showKeychainDeletedDialog(BuildContext context) async {
    await KeychainDeletedDialog.show(context);
  }
}
