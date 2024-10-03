import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:flutter/material.dart';

/// Temporary panel with next/back buttons.
class PlaceholderPanel extends StatelessWidget {
  const PlaceholderPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Spacer(),
        RegistrationBackNextNavigation(),
      ],
    );
  }
}
