import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:flutter/material.dart';

class VoicesChipExample extends StatelessWidget {
  static const String route = '/chips-example';

  const VoicesChipExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            VoicesChip.round(
              content: Text('Label'),
            ),
            SizedBox(height: 16),
            VoicesChip.rectangular(
              content: Text('Label'),
            ),
          ],
        ),
      ),
    );
  }
}
