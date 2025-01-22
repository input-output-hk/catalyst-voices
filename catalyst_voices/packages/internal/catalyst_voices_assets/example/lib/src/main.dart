import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

void main() => runApp(const Example());

final class Example extends StatelessWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Catalyst Assets',
                style: TextStyle(
                  color: VoicesColors.lightPrimary,
                  fontFamily: VoicesFonts.sFPro,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 20),
              VoicesAssets.images.roleVoter.buildIcon(
                size: 200,
                allowColorFilter: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
