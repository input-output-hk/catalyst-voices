import 'package:catalyst_voices/pages/spaces/appbar/appbar_config.dart';
import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Space space;
  final bool isAppUnlock;
  final bool isProposer;

  const SpacesAppbar({
    super.key,
    required this.space,
    required this.isAppUnlock,
    required this.isProposer,
  });

  @override
  Size get preferredSize => VoicesAppBar.size;

  SpaceAppbarConfig get _config => switch (space) {
        Space.discovery => DiscoveryAppbarConfig(isAppUnlock: isAppUnlock, isProposer: isProposer),
        Space.workspace => WorkspaceAppbarConfig(isAppUnlock: isAppUnlock, isProposer: isProposer),
        Space.voting => VotingAppbarConfig(isAppUnlock: isAppUnlock, isProposer: isProposer),
        _ => const DefaultSpaceAppbarConfig(),
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
          CampaignPhaseStatus.upcoming => Offstage(
              offstage: !_config.showAppbarUpcoming,
              child: VoicesAppBar(
                automaticallyImplyLeading: false,
                leading: _config.upcomingAppbarLeading,
                actions: _config.upcomingAppbarActions,
              ),
            ),
          CampaignPhaseStatus.active => Offstage(
              offstage: !_config.showAppbarActive,
              child: VoicesAppBar(
                automaticallyImplyLeading: false,
                leading: _config.activeAppbarLeading,
                actions: _config.activeAppbarActions,
              ),
            ),
          CampaignPhaseStatus.post => Offstage(
              offstage: !_config.showAppbarPost,
              child: VoicesAppBar(
                automaticallyImplyLeading: false,
                leading: _config.postAppbarLeading,
                actions: _config.postAppbarActions,
              ),
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
