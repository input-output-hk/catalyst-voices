import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/cards/role_chooser_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/widgets.dart';

/// A panel that displays a series of [RoleChooserCard] widgets for selecting
/// various account roles (e.g., voter, proposer, drep).
class RolesChooserContainer extends StatelessWidget {
  /// A set where items are [AccountRole] enums
  /// representing whether the corresponding role is selected.
  final Set<AccountRole> selected;

  /// A set similar to [selected], indicating which roles
  /// should be locked in their default state.
  final Set<AccountRole>? lockedValuesAsDefault;

  /// A callback triggered when any role selection changes, passing
  /// the updated map of role values.
  final ValueChanged<Set<AccountRole>>? onChanged;

  /// A callback triggered when the user taps "Learn More" for a
  /// specific role.
  final void Function(AccountRole)? onLearnMore;

  const RolesChooserContainer({
    super.key,
    required this.selected,
    this.lockedValuesAsDefault,
    this.onChanged,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    final roles = [
      (
        AccountRole.voter,
        context.l10n.voter,
        VoicesAssets.images.roleVoter.path,
      ),
      (
        AccountRole.proposer,
        context.l10n.proposer,
        VoicesAssets.images.roleProposer.path,
      ),
      (
        AccountRole.drep,
        context.l10n.drep,
        VoicesAssets.images.roleDrep.path,
      ),
    ];

    return Column(
      children: roles
          .map<Widget>((item) {
            return RoleChooserCard(
              imageUrl: item.$3,
              value: selected.contains(item.$1),
              label: item.$2,
              lockValueAsDefault:
                  lockedValuesAsDefault?.contains(item.$1) ?? false,
              onChanged: (newValue) {
                onChanged?.call(_createNewValue(item.$1, newValue));
              },
              onLearnMore: () {
                onLearnMore?.call(item.$1);
              },
            );
          })
          .separatedBy(const SizedBox(height: 12))
          .toList(),
    );
  }

  Set<AccountRole> _createNewValue(AccountRole role, bool newValue) {
    return newValue
        ? ({...selected}..add(role))
        : ({...selected}..remove(role));
  }
}
