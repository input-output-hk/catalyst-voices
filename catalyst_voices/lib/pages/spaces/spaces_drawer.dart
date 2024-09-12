import 'package:catalyst_voices/pages/spaces/individual_private_campaigns.dart';
import 'package:catalyst_voices/pages/spaces/my_private_proposals.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesDrawer extends StatelessWidget {
  final Space space;

  const SpacesDrawer({
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDrawer(
      children: [
        _SpaceHeader(space),
        _space(),
      ],
      bottom: VoicesDrawerSpaceChooser(
        currentSpace: space,
        onChanged: (space) {
          Scaffold.of(context).closeDrawer();
          _goTo(context, space: space);
        },
      ),
    );
  }

  Widget _space() {
    switch(space) {
      case Space.treasury:
        return IndividualPrivateCampaigns();
      case Space.workspace:
        return MyPrivateProposals();
      default:
        return SizedBox();
    }
  }

  void _goTo(
    BuildContext context, {
    required Space space,
  }) {
    switch (space) {
      case Space.treasury:
        TreasuryRoute().go(context);
      case Space.discovery:
        DiscoveryRoute().go(context);
      case Space.workspace:
        WorkspaceRoute().go(context);
      case Space.voting:
        VotingRoute().go(context);
      case Space.fundedProjects:
        FundedProjectsRoute().go(context);
    }
  }
}

// Note. This should be dropdown bo at the moment we're not
// implementing it.
class _SpaceHeader extends StatelessWidget {
  final Space data;

  const _SpaceHeader(this.data);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 14).add(EdgeInsets.only(left: 16)),
      child: Row(
        children: [
          SpaceAvatar(
            data,
            key: ObjectKey(data),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              data.localizedName(context.l10n),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.colors.textPrimary),
            ),
          ),
          ChevronExpandButton(
            isExpanded: false,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

extension _SpaceExt on Space {
  String localizedName(VoicesLocalizations localizations) {
    return switch (this) {
      Space.treasury => localizations.drawerSpaceTreasury,
      Space.discovery => localizations.drawerSpaceDiscovery,
      Space.workspace => localizations.drawerSpaceWorkspace,
      Space.voting => localizations.drawerSpaceVoting,
      Space.fundedProjects => localizations.drawerSpaceFundedProjects,
    };
  }
}
