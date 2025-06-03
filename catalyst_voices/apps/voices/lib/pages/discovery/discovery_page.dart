import 'dart:async';

import 'package:catalyst_voices/common/error_handler.dart';
import 'package:catalyst_voices/pages/account/keychain_deleted_dialog.dart';
import 'package:catalyst_voices/pages/discovery/sections/campaign_hero.dart';
import 'package:catalyst_voices/pages/discovery/sections/how_it_works.dart';
import 'package:catalyst_voices/pages/discovery/sections/stay_involved.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/campaign_categories_state_selector.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/current_campaign_selector.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/most_recent_proposals_selector.dart';
import 'package:catalyst_voices/widgets/common/infrastructure/voices_wide_screen_constrained.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart' hide CampaignTimeline;
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

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
    final timeline = DateRange(
      from: DateTime.now(),
      to: DateTime.now().add(const Duration(days: 7)),
    );
    return SliverMainAxisGroup(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              const CampaignHeroSection(),
              const HowItWorks(),
              SizedBox(
                width: 1700,
                child: CampaignTimeline(
                  timelineItems: [
                    CampaignTimelineViewModel(
                      title: 'Test Title 1',
                      description: 'Test Description 1',
                      timeline: timeline,
                      stage: CampaignTimelineStage.proposalSubmission,
                    ),
                    CampaignTimelineViewModel(
                      title: 'Test Title 2',
                      description: 'Test Description 2',
                      timeline: DateRange(
                        from: DateTime.now().add(const Duration(days: 8)),
                        to: DateTime.now().add(const Duration(days: 15)),
                      ),
                      stage: CampaignTimelineStage.proposalSubmission,
                    ),
                  ],
                ),
              ),
              const CurrentCampaignSelector(),
              const CampaignCategoriesStateSelector(),
              const StayInvolved(),
              const MostRecentProposalsSelector(),
            ].constrainedDelegate(
              excludePredicate: (widget) =>
                  widget is CampaignHeroSection ||
                  widget is MostRecentProposalsSelector ||
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
    return const SelectionArea(
      child: CustomScrollView(
        slivers: [
          _Body(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    unawaited(context.read<DiscoveryCubit>().getAllData());
    if (widget.keychainDeleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _showKeychainDeletedDialog(context);
      });
    }
  }

  Future<void> _showKeychainDeletedDialog(BuildContext context) async {
    await KeychainDeletedDialog.show(context);
  }
}
