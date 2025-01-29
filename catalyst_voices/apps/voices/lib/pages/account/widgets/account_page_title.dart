import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class AccountPageTitle extends StatelessWidget {
  const AccountPageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My account',
          style: context.textTheme.titleSmall,
        ),
        Text(
          'Profile & Keychain',
          style: context.textTheme.displaySmall,
        ),
      ],
    );
  }
}
