import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AccountRolesTile extends StatelessWidget {
  const AccountRolesTile({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyTile(
      title: 'My Roles',
      action: VoicesTextButton(
        child: Text('Add role'),
        onTap: () {},
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Roles(),
        ],
      ),
    );
  }
}

class _Roles extends StatelessWidget {
  const _Roles();

  @override
  Widget build(BuildContext context) {
    return Text('TODO');
  }
}
