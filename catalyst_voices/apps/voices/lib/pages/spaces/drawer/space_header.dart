import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

// Note. This should be dropdown bo at the moment we're not
// implementing it.
class SpaceHeader extends StatelessWidget {
  final Space data;

  const SpaceHeader(
    this.data, {
    super.key,
  });

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
