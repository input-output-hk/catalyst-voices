import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/widgets/cards/role_chooser_card.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

/// A panel that displays a series of [RoleChooserCard] widgets for selecting
/// various account roles (e.g., voter, proposer, drep) in summary.
class RolesSummaryContainer extends StatelessWidget {
  /// A set where items are [AccountRole] enums
  /// representing whether the corresponding role is selected.
  final Set<AccountRole> selected;

  /// A set similar to [selected], indicating which roles
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
          color: Theme.of(context).colors.outlineBorderVariant,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: AccountRole.values.map<Widget>((role) {
            return RoleChooserCard(
              imageUrl: role.icon,
              value: selected.contains(role),
              label: role.getName(context),
              lockValueAsDefault:
                  lockedValuesAsDefault?.contains(role) ?? false,
              isLearnMoreHidden: true,
              isViewOnly: true,
            );
          }).toList(),
        ),
      ),
    );
  }
}
