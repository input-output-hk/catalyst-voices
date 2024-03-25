import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

final class ComingSoonPage extends StatelessWidget {
  static const comingSoonPageKey = Key('ComingSoon');

  const ComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: comingSoonPageKey,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CatalystImage.asset(
                VoicesAssets.images.dummyCatalystVoices.path,
              ).image,
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ResponsivePadding(
            xs: const EdgeInsets.only(left: 17),
            sm: const EdgeInsets.only(left: 119),
            other: const EdgeInsets.only(left: 150),
            child: const Text(
              'Coming soon',
              style: TextStyle(
                color: VoicesColors.purple,
                fontSize: 53,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
