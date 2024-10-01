import 'package:catalyst_voices/widgets/cards/role_chooser_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// A panel that displays a series of [RoleChooserCard] widgets for selecting
/// various account roles (e.g., voter, proposer, drep) in summary.
class RolesSummaryPanel extends StatelessWidget {
  /// A map where keys are [AccountRole] enums and values are booleans
  /// representing whether the corresponding role is selected.
  final Map<AccountRole, bool> value;

  /// A map similar to [value], indicating which roles
  /// should be locked in their default state.
  final Map<AccountRole, bool>? lockedValuesAsDefault;

  const RolesSummaryPanel({
    super.key,
    required this.value,
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
              value: value[AccountRole.voter] ?? false,
              label: context.l10n.voter,
              lockValueAsDefault:
                  lockedValuesAsDefault?[AccountRole.voter] ?? false,
              isLearnMoreHidden: true,
              isViewOnly: true,
            ),
            RoleChooserCard(
              imageUrl: VoicesAssets.images.roleProposer.path,
              value: value[AccountRole.proposer] ?? false,
              label: context.l10n.proposer,
              lockValueAsDefault:
                  lockedValuesAsDefault?[AccountRole.proposer] ?? false,
              isLearnMoreHidden: true,
              isViewOnly: true,
            ),
            RoleChooserCard(
              imageUrl: VoicesAssets.images.roleDrep.path,
              value: value[AccountRole.drep] ?? false,
              label: context.l10n.drep,
              lockValueAsDefault:
                  lockedValuesAsDefault?[AccountRole.drep] ?? false,
              isLearnMoreHidden: true,
              isViewOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}
