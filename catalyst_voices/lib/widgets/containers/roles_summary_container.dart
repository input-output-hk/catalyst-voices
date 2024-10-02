import 'package:catalyst_voices/widgets/cards/role_chooser_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// A panel that displays a series of [RoleChooserCard] widgets for selecting
/// various account roles (e.g., voter, proposer, drep) in summary.
class RolesSummaryContainer extends StatelessWidget {
  /// A map where keys are [AccountRole] enums and values are booleans
  /// representing whether the corresponding role is selected.
  final Set<AccountRole> selected;

  /// A map similar to [selected], indicating which roles
  /// should be locked in their default state.
  final Set<AccountRole>? lockedValuesAsDefault;

  const RolesSummaryContainer({
    super.key,
    required this.selected,
    this.lockedValuesAsDefault,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colors.outlineBorderVariant!,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            RoleChooserCard(
              imageUrl: VoicesAssets.images.roleVoter.path,
              value: selected.contains(AccountRole.voter),
              label: context.l10n.voter,
              lockValueAsDefault:
                  lockedValuesAsDefault?.contains(AccountRole.voter) ?? false,
              isLearnMoreHidden: true,
              isViewOnly: true,
            ),
            RoleChooserCard(
              imageUrl: VoicesAssets.images.roleProposer.path,
              value: selected.contains(AccountRole.proposer),
              label: context.l10n.proposer,
              lockValueAsDefault:
                  lockedValuesAsDefault?.contains(AccountRole.proposer) ?? false,
              isLearnMoreHidden: true,
              isViewOnly: true,
            ),
            RoleChooserCard(
              imageUrl: VoicesAssets.images.roleDrep.path,
              value: selected.contains(AccountRole.drep),
              label: context.l10n.drep,
              lockValueAsDefault:
                  lockedValuesAsDefault?.contains(AccountRole.drep) ?? false,
              isLearnMoreHidden: true,
              isViewOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
