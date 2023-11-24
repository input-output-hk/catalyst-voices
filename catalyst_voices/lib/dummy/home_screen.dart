import 'package:catalyst_voices/dummy/dummy.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

final class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: WidgetKeys.homeScreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.l10n.homeScreenText,
              style: const TextStyle(
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
    );
  }
}
