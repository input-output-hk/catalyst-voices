import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:flutter/material.dart';

class VoicesIndicatorsExample extends StatelessWidget {
  static const String route = '/indicators-example';

  const VoicesIndicatorsExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voices Indicators')),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 42, vertical: 24),
        child: Column(
          children: [
            Text('Linear - Indeterminate'),
            SizedBox(height: 8),
            VoicesLinearProgressIndicator(),
            SizedBox(height: 16),
            VoicesLinearProgressIndicator(showTrack: false),
            SizedBox(height: 22),
            Text('Linear - Fixed'),
            SizedBox(height: 8),
            VoicesLinearProgressIndicator(value: 0.25),
            SizedBox(height: 16),
            VoicesLinearProgressIndicator(value: 0.25, showTrack: false),
            SizedBox(height: 22),
            Text('Circular - Indeterminate'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VoicesCircularProgressIndicator(),
                SizedBox(width: 16),
                VoicesCircularProgressIndicator(showTrack: false),
              ],
            ),
            SizedBox(height: 22),
            Text('Circular - Fixed'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VoicesCircularProgressIndicator(value: 0.75),
                SizedBox(width: 16),
                VoicesCircularProgressIndicator(value: 0.75, showTrack: false),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
