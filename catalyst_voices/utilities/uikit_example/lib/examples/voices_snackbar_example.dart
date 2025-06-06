import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_action.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VoicesSnackbarExample extends StatelessWidget {
  static const String route = '/snackbar-example';

  const VoicesSnackbarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Snackbar')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final type in VoicesSnackBarType.values)
              for (final actions in _actionList(context, type))
                for (final behavior in SnackBarBehavior.values)
                  OutlinedButton(
                    onPressed: () {
                      VoicesSnackBar(
                        type: type,
                        behavior: behavior,
                        onClosePressed: () => VoicesSnackBar.hideCurrent(context),
                        actions: actions,
                      ).show(context);
                    },
                    child: Text(
                      '${behavior.toString().split('.').last}'
                      ' ${type.toString().split('.').last}'
                      '${actions.isEmpty ? '' : ' with actions'}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  List<List<Widget>> _actionList(
    BuildContext context,
    VoicesSnackBarType type,
  ) {
    return [
      [
        VoicesSnackBarPrimaryAction(
          type: type,
          onPressed: () {},
          child: Text(context.l10n.refresh),
        ),
        VoicesSnackBarSecondaryAction(
          type: type,
          onPressed: () {},
          child: Text(context.l10n.learnMore),
        ),
      ],
      [],
    ];
  }
}
