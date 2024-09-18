import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

extension SpaceExt on Space {
  void go(BuildContext context) {
    switch (this) {
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

  String localizedName(VoicesLocalizations localizations) {
    return switch (this) {
      Space.treasury => localizations.spaceTreasuryName,
      Space.discovery => localizations.spaceDiscoveryName,
      Space.workspace => localizations.spaceWorkspaceName,
      Space.voting => localizations.spaceVotingName,
      Space.fundedProjects => localizations.spaceFundedProjects,
    };
  }

  SvgGenImage get icon => switch (this) {
        Space.treasury => VoicesAssets.icons.fund,
        Space.discovery => VoicesAssets.icons.lightBulb,
        Space.workspace => VoicesAssets.icons.briefcase,
        Space.voting => VoicesAssets.icons.vote,
        Space.fundedProjects => VoicesAssets.icons.flag,
      };

  Color backgroundColor(BuildContext context) => switch (this) {
        Space.treasury => Theme.of(context).colors.successContainer!,
        Space.discovery =>
          Theme.of(context).colors.iconsSecondary!.withOpacity(0.16),
        Space.workspace => Theme.of(context).colorScheme.primaryContainer,
        Space.voting => Theme.of(context).colors.warningContainer!,
        Space.fundedProjects =>
          Theme.of(context).colors.iconsSecondary!.withOpacity(0.16),
      };

  Color foregroundColor(BuildContext context) => switch (this) {
        Space.treasury => Theme.of(context).colors.iconsSuccess!,
        Space.discovery => Theme.of(context).colors.iconsSecondary!,
        Space.workspace => Theme.of(context).colorScheme.primary,
        Space.voting => Theme.of(context).colors.iconsWarning!,
        Space.fundedProjects => Theme.of(context).colors.iconsSecondary!,
      };
}
