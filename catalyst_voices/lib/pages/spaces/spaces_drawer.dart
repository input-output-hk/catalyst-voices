import 'dart:async';

import 'package:catalyst_voices/pages/spaces/individual_private_campaigns.dart';
import 'package:catalyst_voices/pages/spaces/my_private_proposals.dart';
import 'package:catalyst_voices/pages/spaces/voting_rounds.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesDrawer extends StatelessWidget {
  final Space space;

  const SpacesDrawer({
    super.key,
    required this.space,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDrawer(
      bottom: VoicesDrawerSpaceChooser(
        currentSpace: space,
        onChanged: (space) {
          _goTo(context, space: space);
        },
        onOverallTap: () {
          Scaffold.of(context).closeDrawer();
          unawaited(const OverallSpacesRoute().push<void>(context));
        },
      ),
      children: [
        _SpaceHeader(space),
        _space(),
      ],
    );
  }

  Widget _space() {
    switch (space) {
      case Space.treasury:
        return const IndividualPrivateCampaigns();
      case Space.workspace:
        return const MyPrivateProposals();
      case Space.voting:
        return const VotingRounds();
      case Space.discovery:
      case Space.fundedProjects:
        return const SizedBox();
    }
  }

  void _goTo(
    BuildContext context, {
    required Space space,
  }) {
    switch (space) {
      case Space.treasury:
        const TreasuryRoute().go(context);
      case Space.discovery:
        const DiscoveryRoute().go(context);
      case Space.workspace:
        const WorkspaceRoute().go(context);
      case Space.voting:
        const VotingRoute().go(context);
      case Space.fundedProjects:
        const FundedProjectsRoute().go(context);
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
      padding: const EdgeInsets.symmetric(vertical: 14)
          .add(const EdgeInsets.only(left: 16)),
      child: Row(
        children: [
          SpaceAvatar(
            data,
            key: ObjectKey(data),
          ),
          const SizedBox(width: 12),
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
