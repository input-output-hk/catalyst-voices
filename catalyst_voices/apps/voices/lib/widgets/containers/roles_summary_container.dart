import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/widgets/cards/role_chooser_card.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// A panel that displays a series of [RoleChooserCard] widgets for selecting
/// various account roles (e.g., voter, proposer, drep) in summary.
class RolesSummaryContainer extends StatelessWidget {
  /// List with information's about roles.
  final List<RegistrationRole> roles;

  const RolesSummaryContainer({
    super.key,
    required this.roles,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colors.outlineBorderVariant,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: roles.map<Widget>((role) {
            return RoleChooserCard(
              icon: role.type.icon.buildIcon(
                size: 66,
                allowColorFilter: false,
              ),
              value: role.isSelected,
              label: role.type.getName(context),
              isDefault: role.type.isDefault,
              isLearnMoreHidden: true,
              isViewOnly: true,
            );
          }).toList(),
        ),
      ),
    );
  }
}
