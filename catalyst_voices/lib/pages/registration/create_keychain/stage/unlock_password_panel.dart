import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:flutter/material.dart';

class UnlockPasswordPanel extends StatelessWidget {
  const UnlockPasswordPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 24),
        Spacer(),
        SizedBox(height: 10),
        RegistrationBackNextNavigation(isNextEnabled: false),
      ],
    );
  }
}
