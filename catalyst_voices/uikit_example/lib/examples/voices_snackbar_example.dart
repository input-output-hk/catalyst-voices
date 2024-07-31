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
                    snackBarType: type,
                    padding: EdgeInsets.only(
                      left: screenWidth / 5,
                      right: screenWidth / 5,
                      bottom: screenWidth / 2,
                    ),
                    onLearnMorePressed: () {},
                    onRefreshPressed: () {},
                    onOkPressed: () {},
                    onClosePressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ).showSnackBar(context);
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
