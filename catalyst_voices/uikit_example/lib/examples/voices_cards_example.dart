import 'package:catalyst_voices/widgets/cards/role_chooser_card.dart';
import 'package:catalyst_voices/widgets/containers/roles_chooser_panel.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class VoicesCardsExample extends StatefulWidget {
  static const String route = '/cards-example';

  const VoicesCardsExample({super.key});

  @override
  State<VoicesCardsExample> createState() {
    return _VoicesCardsExampleState();
  }
}

class _VoicesCardsExampleState extends State<VoicesCardsExample> {
  bool _roleChooserCardState1 = true;
  Map<AccountRole, bool> _rolesChooserPanelState1 = {
    AccountRole.voter: true,
    AccountRole.proposer: true,
    AccountRole.drep: false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Cards')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 24),
        children: [
          const Text('Role Chooser Card'),
          RoleChooserCard(
            imageUrl: VoicesAssets.images.dummyCatalystVoices.path,
            value: _roleChooserCardState1,
            label: 'label',
            learnMoreUrl: 'learnMoreUrl1',
            onChanged: (changedValue) => {
              setState(() {
                _roleChooserCardState1 = changedValue;
              }),
            },
          ),
          const SizedBox(height: 16),
          const Text('Role Chooser Card (Locked Value, Without View More URL)'),
          RoleChooserCard(
            imageUrl: VoicesAssets.images.dummyCatalystVoices.path,
            value: true,
            label: 'label',
            lockValueAsDefault: true,
          ),
          const SizedBox(height: 16),
          const Text('Roles Chooser Panel'),
            RolesChooserPanel(
            value: _rolesChooserPanelState1,
            lockedValuesAsDefault: const {
              AccountRole.voter: true,
            },
            onChanged: (changedValue) => {
              setState(() {
                _rolesChooserPanelState1 = changedValue;
              }),
            },
          ),
        ],
      ),
    );
  }
}
