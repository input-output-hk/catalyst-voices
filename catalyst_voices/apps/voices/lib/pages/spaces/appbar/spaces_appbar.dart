import 'package:catalyst_voices/pages/spaces/appbar/app_bar_config.dart';
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

  SpaceAppBarConfig get _config => switch (space) {
        Space.discovery => DiscoveryAppBarConfig(isAppUnlock: isAppUnlock, isProposer: isProposer),
        Space.workspace => WorkspaceAppBarConfig(isAppUnlock: isAppUnlock, isProposer: isProposer),
        Space.voting => VotingAppBarConfig(isAppUnlock: isAppUnlock, isProposer: isProposer),
        _ => const DefaultSpaceAppBarConfig(),
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
              offstage: !_config.showAppBarUpcoming,
              child: VoicesAppBar(
                automaticallyImplyLeading: false,
                leading: _config.upcomingAppBarLeading,
                actions: _config.upcomingAppBarActions,
              ),
            ),
          CampaignPhaseStatus.active => Offstage(
              offstage: !_config.showAppBarActive,
              child: VoicesAppBar(
                automaticallyImplyLeading: false,
                leading: _config.activeAppBarLeading,
                actions: _config.activeAppBarActions,
              ),
            ),
          CampaignPhaseStatus.post => Offstage(
              offstage: !_config.showAppBarPost,
              child: VoicesAppBar(
                automaticallyImplyLeading: false,
                leading: _config.postAppBarLeading,
                actions: _config.postAppBarActions,
              ),
            ),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}
