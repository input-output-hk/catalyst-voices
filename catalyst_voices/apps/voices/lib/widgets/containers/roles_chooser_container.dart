import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/widgets/cards/role_chooser_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/widgets.dart';

/// A panel that displays a series of [RoleChooserCard] widgets for selecting
/// various account roles (e.g., voter, proposer, drep).
class RolesChooserContainer extends StatelessWidget {
  /// List of information about roles which should be shown.
  final List<RegistrationRole> roles;

  /// A callback triggered when any role selection changes, passing
  /// the updated set of selected roles.
  final ValueChanged<Set<AccountRole>>? onChanged;

  /// A callback triggered when the user taps "Learn More" for a
  /// specific role.
  final ValueChanged<AccountRole>? onLearnMore;

  const RolesChooserContainer({
    super.key,
    required this.roles,
    this.onChanged,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: roles
          .map<Widget>((role) {
            return RoleChooserCard(
              icon: role.type.icon.buildIcon(
                size: 28,
                allowColorFilter: false,
              ),
              value: role.isSelected,
              label: role.type.getName(context),
              isLocked: role.isLocked,
              isDefault: role.type.isDefault,
              onChanged: (newValue) {
                onChanged?.call(_createNewValue(role.type, newValue));
              },
              onLearnMore: () {
                onLearnMore?.call(role.type);
              },
            );
          })
          .separatedBy(const SizedBox(height: 12))
          .toList(),
    );
  }

  Set<AccountRole> _createNewValue(AccountRole role, bool newValue) {
    final selected = roles.where((role) => role.isSelected).map((e) => e.type);

    return newValue ? ({...selected}..add(role)) : ({...selected}..remove(role));
  }
}
