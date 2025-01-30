import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AccountKeychainTile extends StatelessWidget {
  const AccountKeychainTile({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyTile(
      title: 'Catalyst Keychain',
      action: VoicesTextButton.danger(
        onTap: () {},
        child: Text('Remove Keychain'),
      ),
      child: VoicesTextField(
        initialText:
            'addr1q9gkq75mt2hykrktnsgt2zxrj5h9jnd6gkwr5s4r8v5x3dzp8n9h9mns5w7zx95jhtwz46yq4nr7y6hhlwtq75jflsqq9dxry2',
        onFieldSubmitted: null,
        minLines: 1,
        maxLines: 3,
      ),
    );
  }
}
