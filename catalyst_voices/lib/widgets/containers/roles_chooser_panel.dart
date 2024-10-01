import 'package:catalyst_voices/widgets/cards/role_chooser_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

class RolesChooserPanel extends StatelessWidget {
  final Map<AccountRole, bool> value;
  final Map<AccountRole, bool>? lockedValuesAsDefault;
  final ValueChanged<Map<AccountRole, bool>>? onChanged;

  const RolesChooserPanel({
    super.key,
    required this.value,
    this.lockedValuesAsDefault,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoleChooserCard(
          imageUrl: VoicesAssets.images.roleVoter.path,
          value: value[AccountRole.voter] ?? false,
          label: context.l10n.voter,
          learnMoreUrl: 'tmp',
          lockValueAsDefault:
              lockedValuesAsDefault?[AccountRole.voter] ?? false,
          onChanged: (newValue) {
            onChanged?.call({...value, AccountRole.voter: newValue});
          },
        ),
        const SizedBox(height: 12),
        RoleChooserCard(
          imageUrl: VoicesAssets.images.roleProposer.path,
          value: value[AccountRole.proposer] ?? false,
          label: context.l10n.proposer,
          learnMoreUrl: 'tmp',
          lockValueAsDefault:
              lockedValuesAsDefault?[AccountRole.proposer] ?? false,
          onChanged: (newValue) {
            onChanged?.call({...value, AccountRole.proposer: newValue});
          },
        ),
        const SizedBox(height: 12),
        RoleChooserCard(
          imageUrl: VoicesAssets.images.roleDrep.path,
          value: value[AccountRole.drep] ?? false,
          label: context.l10n.drep,
          learnMoreUrl: 'tmp',
          lockValueAsDefault: lockedValuesAsDefault?[AccountRole.drep] ?? false,
          onChanged: (newValue) {
            onChanged?.call({...value, AccountRole.drep: newValue});
          },
        ),
      ],
    );
  }
}
