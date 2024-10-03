import 'package:catalyst_voices/widgets/toggles/voices_switch.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A switch that toggles between light & dark theme mode.
class VoicesThemeModeSwitch extends StatelessWidget {
  final ValueChanged<ThemeMode> onChanged;

  const VoicesThemeModeSwitch({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('${context.l10n.themeLight} / ${context.l10n.themeDark}'),
        const SizedBox(width: 8),
        VoicesSwitch(
          value: Theme.of(context).brightness == Brightness.dark,
          onChanged: (value) {
            onChanged(
              value ? ThemeMode.dark : ThemeMode.light,
            );
          },
        ),
      ],
    );
  }
}
