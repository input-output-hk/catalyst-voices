import 'package:catalyst_voices/widgets/cards/role_chooser_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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
          imageUrl: VoicesAssets.images.dummyCatalystVoices.path,
          value: value[AccountRole.voter] ?? false,
          label: 'Voter',
          lockValueAsDefault: lockedValuesAsDefault?[AccountRole.voter] ?? false,
          onChanged: (value) {
            onChanged?.call(_createModifiedValue(AccountRole.voter, value));
          },
        ),
        const SizedBox(height: 12),
        RoleChooserCard(
          imageUrl: VoicesAssets.images.dummyCatalystVoices.path,
          value: value[AccountRole.proposer] ?? false,
          label: 'Main Proposer',
          lockValueAsDefault:
              lockedValuesAsDefault?[AccountRole.proposer] ?? false,
          onChanged: (value) {
            onChanged?.call(_createModifiedValue(AccountRole.proposer, value));
          },
        ),
        const SizedBox(height: 12),
        RoleChooserCard(
          imageUrl: VoicesAssets.images.dummyCatalystVoices.path,
          value: value[AccountRole.drep] ?? false,
          label: 'Drep',
          lockValueAsDefault: lockedValuesAsDefault?[AccountRole.drep] ?? false,
          onChanged: (value) {
            onChanged?.call(_createModifiedValue(AccountRole.drep, value));
          },
        ),
      ],
    );
  }

  Map<AccountRole, bool> _createModifiedValue(
    AccountRole field,
    bool newValue,
  ) {
    final out = Map<AccountRole, bool>.from(value);
    out[field] = newValue;

    return out;
  }
}
