import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:flutter/material.dart';

class VoicesSnackbarExample extends StatelessWidget {
  static const String route = '/snackbar-example';

  const VoicesSnackbarExample({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final type in VoicesSnackBarType.values)
              OutlinedButton(
                onPressed: () {
                  VoicesSnackBar(
                    type: type,
                    padding: EdgeInsets.only(
                      bottom: screenWidth / 2,
                      left: screenWidth / 3,
                      right: screenWidth / 3,
                    ),
                    onPrimaryPressed: () {},
                    onSecondaryPressed: () {},
                    onClosePressed: () => VoicesSnackBar.hideCurrent(context),
                  ).show(context);
                },
                child: Text(
                  type.toString().split('.').last,
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
}
