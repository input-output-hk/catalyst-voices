import 'package:catalyst_voices/pages/spaces/drawer/space_end_drawer_config.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesEndDrawer extends StatelessWidget {
  final Space space;

  const SpacesEndDrawer({super.key, required this.space});

  SpaceEndDrawerConfig get _config => switch (space) {
        Space.voting => const VotingSpaceEndDrawerConfig(),
        _ => const DefaultSpaceEndDrawerConfig(),
      };
  @override
  Widget build(BuildContext context) {
    return BlocSelector<CampaignPhaseAwareCubit, CampaignPhaseAwareState, CampaignPhaseStatus?>(
      selector: (state) {
        if (state case final DataCampaignPhaseAwareState campaignData) {
          return campaignData.getPhaseStatus(_config.phaseType).status;
        }
        return null;
      },
      builder: (context, state) {
        return switch (state) {
          CampaignPhaseStatus.upcoming when _config.upcomingEndDrawer != null =>
            _config.upcomingEndDrawer!,
          CampaignPhaseStatus.active when _config.activeEndDrawer != null =>
            _config.activeEndDrawer!,
          CampaignPhaseStatus.post when _config.postEndDrawer != null => _config.postEndDrawer!,
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
