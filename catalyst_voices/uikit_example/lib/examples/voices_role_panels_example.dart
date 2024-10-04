import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
            imageUrl: VoicesAssets.images.dummyCatalystVoices.path,
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
            imageUrl: VoicesAssets.images.dummyCatalystVoices.path,
            value: true,
            label: 'very long label, ' * 20,
            isLearnMoreHidden: true,
            lockValueAsDefault: true,
          ),
          const SizedBox(height: 16),
          const Text('Role Chooser Card (State #1, View Only)'),
          RoleChooserCard(
            imageUrl: VoicesAssets.images.dummyCatalystVoices.path,
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
            imageUrl: VoicesAssets.images.dummyCatalystVoices.path,
            value: true,
            label: 'very long label, ' * 20,
            lockValueAsDefault: true,
            isViewOnly: true,
          ),
          const SizedBox(height: 16),
          const Text('Roles Chooser Container (State #1)'),
          RolesChooserContainer(
            selected: _rolesChooserPanelState1,
            lockedValuesAsDefault: const {
              AccountRole.voter,
            },
            onChanged: (changedValue) => {
              setState(() {
                _rolesChooserPanelState1 = changedValue;
              }),
            },
          ),
          const SizedBox(height: 16),
          const Text('Roles Summary Container (State #1)'),
          RolesSummaryContainer(
            selected: _rolesChooserPanelState1,
            lockedValuesAsDefault: const {
              AccountRole.voter,
            },
          ),
        ],
      ),
    );
  }
}
