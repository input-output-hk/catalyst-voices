import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:flutter/material.dart';

class VoicesSnackbarExample extends StatelessWidget {
  static const String route = '/snackbar-example';

  const VoicesSnackbarExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            VoicesSnackBar.show(
              context,
              snackBarType: VoicesSnackBarType.info,
            ),
            VoicesSnackBar.show(
              context,
              snackBarType: VoicesSnackBarType.success,
            ),
            VoicesSnackBar.show(
              context,
              snackBarType: VoicesSnackBarType.warning,
            ),
            VoicesSnackBar.show(
              context,
              snackBarType: VoicesSnackBarType.error,
            ),
          ],
        ),
      ),
    );
  }
}
