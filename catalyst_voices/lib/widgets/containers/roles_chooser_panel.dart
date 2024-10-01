import 'package:catalyst_voices/widgets/cards/role_chooser_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

/// A panel that displays a series of [RoleChooserCard] widgets for selecting
/// various account roles (e.g., voter, proposer, drep).
class RolesChooserPanel extends StatelessWidget {
  /// A map where keys are [AccountRole] enums and values are booleans
  /// representing whether the corresponding role is selected.
  final Map<AccountRole, bool> value;

  /// A map similar to [value], indicating which roles
  /// should be locked in their default state.
  final Map<AccountRole, bool>? lockedValuesAsDefault;

  /// A callback triggered when any role selection changes, passing
  ///   the updated map of role values.
  final ValueChanged<Map<AccountRole, bool>>? onChanged;

  /// A callback triggered when the user taps "Learn More" for a
  /// specific role.
  final void Function(AccountRole)? onLearnMore;

  const RolesChooserPanel({
    super.key,
    required this.value,
    this.lockedValuesAsDefault,
    this.onChanged,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoleChooserCard(
          imageUrl: VoicesAssets.images.roleVoter.path,
          value: value[AccountRole.voter] ?? false,
          label: context.l10n.voter,
          lockValueAsDefault:
              lockedValuesAsDefault?[AccountRole.voter] ?? false,
          onChanged: (newValue) {
            onChanged?.call({...value, AccountRole.voter: newValue});
          },
          onLearnMore: () {
            onLearnMore?.call(AccountRole.voter);
          },
        ),
        const SizedBox(height: 12),
        RoleChooserCard(
          imageUrl: VoicesAssets.images.roleProposer.path,
          value: value[AccountRole.proposer] ?? false,
          label: context.l10n.proposer,
          lockValueAsDefault:
              lockedValuesAsDefault?[AccountRole.proposer] ?? false,
          onChanged: (newValue) {
            onChanged?.call({...value, AccountRole.proposer: newValue});
          },
          onLearnMore: () {
            onLearnMore?.call(AccountRole.proposer);
          },
        ),
        const SizedBox(height: 12),
        RoleChooserCard(
          imageUrl: VoicesAssets.images.roleDrep.path,
          value: value[AccountRole.drep] ?? false,
          label: context.l10n.drep,
          lockValueAsDefault: lockedValuesAsDefault?[AccountRole.drep] ?? false,
          onChanged: (newValue) {
            onChanged?.call({...value, AccountRole.drep: newValue});
          },
          onLearnMore: () {
            onLearnMore?.call(AccountRole.drep);
          },
        ),
      ],
    );
  }
}
