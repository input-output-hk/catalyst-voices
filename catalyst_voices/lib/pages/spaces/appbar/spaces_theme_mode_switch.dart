import 'package:catalyst_voices/app/app.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// A switch that updates the app theme mode.
class SpacesThemeModeSwitch extends StatelessWidget {
  const SpacesThemeModeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesThemeModeSwitch(
      onChanged: AppContent.of(context).updateThemeMode,
    );
  }
}
