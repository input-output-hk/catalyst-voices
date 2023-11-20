# Catalyst Voices Assets Example

This is an example of how to use the Catalyst Voices Assets package.

## Usage

```dart
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

void main() => runApp(Example());

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
                  color: VoicesColors.purpleGradientStart,
                  fontFamily: VoicesFonts.sFPro,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                width: 200,
                child: CatalystImage.asset(
                  VoicesAssets.images.dummyCatalystVoices.path,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
