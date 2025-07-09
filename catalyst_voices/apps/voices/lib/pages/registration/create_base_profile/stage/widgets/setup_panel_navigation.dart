import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class SetupPanelNavigation extends StatelessWidget {
  const SetupPanelNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<bool>(
      selector: (state) => state.isBaseProfileDataValid,
      builder: (context, state) => _SetupPanelNavigation(isNextEnabled: state),
    );
  }
}

class _SetupPanelNavigation extends StatelessWidget {
  final bool isNextEnabled;

  const _SetupPanelNavigation({
    required this.isNextEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return RegistrationBackNextNavigation(
      isNextEnabled: isNextEnabled,
    );
  }
}
