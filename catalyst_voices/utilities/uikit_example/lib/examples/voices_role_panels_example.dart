import 'package:catalyst_voices/common/ext/account_role_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VoicesRoleContainersExample extends StatefulWidget {
  static const String title = 'Voices Role Containers';
  static const String route = '/role-containers-example';

  const VoicesRoleContainersExample({super.key});

  @override
  State<VoicesRoleContainersExample> createState() {
    return _VoicesRoleContainersExampleState();
  }
}

class _VoicesRoleContainersExampleState
    extends State<VoicesRoleContainersExample> {
  bool _roleChooserCardState1 = true;
  Set<AccountRole> _rolesChooserPanelState1 = {
    AccountRole.voter,
    AccountRole.proposer,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(VoicesRoleContainersExample.title)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 24),
        children: [
          const Text('Role Chooser Card (State #1)'),
          RoleChooserCard(
            icon: AccountRole.voter.icon.buildIcon(
              size: 28,
              allowColorFilter: false,
            ),
            value: _roleChooserCardState1,
            label: 'label',
            onChanged: (changedValue) => {
              setState(() {
                _roleChooserCardState1 = changedValue;
              }),
            },
          ),
          const SizedBox(height: 16),
          const Text('Role Chooser Card (Locked Value, Hidden View More)'),
          RoleChooserCard(
            icon: AccountRole.drep.icon.buildIcon(
              size: 28,
              allowColorFilter: false,
            ),
            value: true,
            label: 'very long label, ' * 20,
            isLearnMoreHidden: true,
            isLocked: true,
            isDefault: true,
          ),
          const SizedBox(height: 16),
          const Text('Role Chooser Card (State #1, View Only)'),
          RoleChooserCard(
            icon: AccountRole.proposer.icon.buildIcon(
              size: 28,
              allowColorFilter: false,
            ),
            value: _roleChooserCardState1,
            label: 'label',
            isViewOnly: true,
            onChanged: (changedValue) => {
              setState(() {
                _roleChooserCardState1 = changedValue;
              }),
            },
          ),
          const SizedBox(height: 16),
          const Text('Role Chooser Card (Locked Value, View Only)'),
          RoleChooserCard(
            icon: AccountRole.proposer.icon.buildIcon(
              size: 28,
              allowColorFilter: false,
            ),
            value: true,
            label: 'very long label, ' * 20,
            isLocked: true,
            isDefault: true,
            isViewOnly: true,
          ),
          const SizedBox(height: 16),
          const Text('Roles Chooser Container (State #1)'),
          RolesChooserContainer(
            roles: AccountRole.values.map((role) {
              return RegistrationRole(
                type: role,
                isSelected: _rolesChooserPanelState1.contains(role),
                isLocked: role == AccountRole.voter,
              );
            }).toList(),
            onChanged: (changedValue) => {
              setState(() {
                _rolesChooserPanelState1 = changedValue;
              }),
            },
          ),
          const SizedBox(height: 16),
          const Text('Roles Summary Container (State #1)'),
          RolesSummaryContainer(
            roles: AccountRole.values.map((role) {
              return RegistrationRole(
                type: role,
                isSelected: _rolesChooserPanelState1.contains(role),
                isLocked: role == AccountRole.voter,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
