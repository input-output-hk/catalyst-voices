import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/widgets/cards/role_chooser_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
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
  /// the updated set of selected roles.
  final ValueChanged<Set<AccountRole>>? onChanged;

  /// A callback triggered when the user taps "Learn More" for a
  /// specific role.
  final ValueChanged<AccountRole>? onLearnMore;

  const RolesChooserContainer({
    super.key,
    required this.selected,
    this.lockedValuesAsDefault,
    this.onChanged,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: AccountRole.values
          .whereNot((role) => role.isHidden)
          .map<Widget>((role) {
            return RoleChooserCard(
              icon: role.icon.buildIcon(
                size: 28,
                allowColorFilter: false,
              ),
              value: selected.contains(role),
              label: role.getName(context),
              lockValueAsDefault:
                  lockedValuesAsDefault?.contains(role) ?? false,
              onChanged: (newValue) {
                onChanged?.call(_createNewValue(role, newValue));
              },
              onLearnMore: () {
                onLearnMore?.call(role);
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
