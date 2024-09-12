import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

extension SpaceExt on Space {
  IconData get icon => switch (this) {
        Space.treasury => CatalystVoicesIcons.fund,
        Space.discovery => CatalystVoicesIcons.light_bulb,
        Space.workspace => CatalystVoicesIcons.briefcase,
        Space.voting => CatalystVoicesIcons.vote,
        Space.fundedProjects => CatalystVoicesIcons.flag,
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
